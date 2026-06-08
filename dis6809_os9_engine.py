#!/usr/bin/env python3
"""
dis6809_os9_engine.py — OS-9 6809 Disassembler Engine
======================================================
Layer 1: Pure 6809 instruction decoder
Layer 2: OS-9 platform knowledge  
Layer 3: Two-pass recursive-descent data/code classification
Layer 4: Structured output (intermediate representation)

This module exposes a clean API for use by a driver script.
It has NO knowledge of any specific binary — all binary-specific
annotations come from the caller via a Project object.

Usage:
    from dis6809_os9_engine import Engine, Project
    proj = Project.from_json("myproject.json")
    eng  = Engine(proj)
    eng.load(open(proj.binary, 'rb').read())
    eng.run()                  # two-pass classification + disassembly
    print(eng.render())        # returns annotated ASM text
"""

import json, os, sys

# ── helpers ───────────────────────────────────────────────────────────────────

def s8(v):  return v - 256 if v >= 128 else v
def s16(v): return v - 65536 if v >= 32768 else v

KIND_CODE = 'CODE'
KIND_DATA = 'DATA'

# ── OS-9 platform tables ──────────────────────────────────────────────────────

OS9_SYSCALLS = {
    0x00:("F$Link",   "module_name→X"),
    0x01:("F$Load",   "name→X  mode=B"),
    0x02:("F$UnLink", "module→X"),
    0x03:("F$Fork",   "module→D:X  args→Y  size=D"),
    0x04:("F$Wait",   "→ wait for child; status→D"),
    0x05:("F$Chain",  "module→D:X  args→Y"),
    0x06:("F$Exit",   "status=B"),
    0x07:("F$Mem",    "size→D  → new top→Y"),
    0x08:("F$Send",   "pid=A  signal=B"),
    0x09:("F$Icpt",   "handler→X  data→U"),
    0x0A:("F$Sleep",  "ticks→X  (0=forever)"),
    0x0B:("F$SSpd",   "pid=A"),
    0x0C:("F$ID",     "→ pid→A  uid→B"),
    0x0D:("F$SPrior", "pid=A  priority=B"),
    0x0E:("F$SSWI",   "level=A  handler→X"),
    0x0F:("F$PErr",   "path=A  error=B"),
    0x10:("F$PrsNam", "name→X"),
    0x11:("F$CmpNam", "name→X  len=Y  name2→D"),
    0x12:("F$SchBit", "bitmap→X  count=D  start=Y"),
    0x13:("F$AllBit", "bitmap→X  count=D  start=Y"),
    0x14:("F$DelBit", "bitmap→X  count=D  start=Y"),
    0x15:("F$Time",   "buf→X  → 6-byte time"),
    0x16:("F$STime",  "buf→X"),
    0x17:("F$CRC",    "buf→X  count=Y  seed=D  → CRC-24"),
    0x18:("F$GPrDsc", "pid=A  buf→X"),
    0x19:("F$GBlkMp", "buf→X"),
    0x1A:("F$GModDr", "buf→X"),
    0x1B:("F$CpyMem", "src→X  dst→Y  count=D"),
    0x1C:("F$SUser",  "uid=D"),
    0x1D:("F$UnLoad", "name→X"),
    0x1E:("F$Alarm",  "func=A  time=D"),
    0x2C:("F$Move",   "src→X  dst→Y  count=D"),
    0x2D:("F$AllRAM", "count=B"),
    0x2E:("F$Permit", "pid=A  perms=B"),
    0x2F:("F$Protect","addr→X  count=D"),
    0x80:("I$Attach", "mode=A  name→X"),
    0x81:("I$Detach", "port→X"),
    0x82:("I$Dup",    "path=A  → new path→A"),
    0x83:("I$Create", "mode=B  name→X  → path→A"),
    0x84:("I$Open",   "mode=B  name→X  → path→A"),
    0x85:("I$MakDir", "mode=B  name→X"),
    0x86:("I$ChgDir", "mode=B  name→X"),
    0x87:("I$Delete", "name→X"),
    0x88:("I$Seek",   "path=A  mode=B  offset→X:D"),
    0x89:("I$Read",   "path=A  count=Y  buf→X"),
    0x8A:("I$Write",  "path=A  count=Y  buf→X"),
    0x8B:("I$ReadLn", "path=A  max=Y  buf→X"),
    0x8C:("I$WritLn", "path=A  buf→X"),
    0x8D:("I$GetStt", "path=A  subcode=B  buf→X"),
    0x8E:("I$SetStt", "path=A  subcode=B  buf→X"),
    0x8F:("I$Close",  "path=A"),
    0x90:("I$DupS",   "path=A  new#=B"),
}

SS_CODES = {
    0x00:"SS.Opt",  0x01:"SS.Ready",0x02:"SS.Size", 0x03:"SS.Reset",
    0x05:"SS.Pos",  0x06:"SS.EOF",  0x0A:"SS.DevNm",0x0B:"SS.FD",
    0x20:"SS.ScSiz",0x21:"SS.KySns",0x22:"SS.ComSt",0x25:"SS.HngUp",
    0x26:"SS.FSig", 0x27:"SS.Sign", 0x28:"SS.EnRTS",0x2B:"SS.CtlSg",
    0x2C:"SS.Break",
}

WIN_ESC = {
    0x20:("W.DWSet", "Device Window Set",   8),
    0x21:("W.Select","Select window",       1),
    0x22:("W.OWSet", "Overlay Window Set",  7),
    0x23:("W.OWEnd", "Overlay Window End",  0),
    0x24:("W.DWEnd", "Device Window End",   0),
    0x25:("W.CWArea","Change Working Area", 4),
    0x30:("W.DefClr","Default Color",       0),
    0x32:("W.FColor","Foreground Color",    1),
    0x33:("W.Bcolor","Background Color",    1),
    0x34:("W.Border","Border Color",        1),
    0x36:("W.DWProt","DW Protect",          1),
    0x3A:("W.Font",  "Select Font",         2),
    0x3D:("W.BoldSw","Bold Switch",         1),
    0x41:("W.CurU",  "Cursor up",           0),
    0x42:("W.CurD",  "Cursor down",         0),
    0x43:("W.CurR",  "Cursor right",        0),
    0x44:("W.CurL",  "Cursor left",         0),
    0x45:("W.ClrHm", "Clear+home",          0),
    0x48:("W.Home",  "Home cursor",         0),
    0x59:("W.CurXY", "Set cursor",          2),
    0x4A:("W.ClrEOS","Clear to EOS",        0),
    0x4B:("W.ClrEOL","Clear to EOL",        0),
    0x4C:("W.InsLn", "Insert line",         0),
    0x4D:("W.DelLn", "Delete line",         0),
    0x4E:("W.DelCh", "Delete char",         0),
    0x4F:("W.InsCh", "Insert space",        0),
    0x52:("W.ScRgn", "Scroll region",       2),
    0x53:("W.ScrlU", "Scroll up",           0),
    0x54:("W.ScrlD", "Scroll down",         0),
    0x70:("W.FgCol", "FG color",            1),
    0x71:("W.BgCol", "BG color",            1),
    0x78:("W.RevOn", "Reverse on",          0),
    0x79:("W.RevOff","Reverse off",         0),
    0x7A:("W.UndOn", "Underline on",        0),
    0x7B:("W.UndOff","Underline off",       0),
}

SCF_CTRL = {
    0x00:"NUL",0x01:"SOH",0x02:"CurXY",0x03:"ETX",0x04:"EOT",
    0x07:"BEL",0x08:"BS", 0x09:"HT",  0x0A:"LF",
    0x0B:"VT cursor-up",  0x0C:"FF clear+home",
    0x0D:"CR", 0x0E:"SO cursor-right",0x0F:"SI cursor-left",
    0x11:"DC1/XON",0x13:"DC3/XOFF",
    0x14:"DC4 erase-EOL", 0x15:"NAK erase-EOS",
    0x16:"SYN insert-line",0x17:"ETB delete-line",
    0x18:"CAN erase-BOL", 0x19:"EM home",
    0x1A:"SUB clear+home",0x1B:"ESC windowing cmd",
}

EQUATES_BLOCK = """\
; ================================================================
; OS-9 Level II Equates
; ================================================================
NUL      EQU    $00      ; null
CurXY    EQU    $02      ; set cursor: row+$20 col+$20 follow
BEL      EQU    $07      ; bell
BS       EQU    $08      ; backspace
LF       EQU    $0A      ; line feed
FF       EQU    $0C      ; form feed / clear screen + home
CR       EQU    $0D      ; carriage return
SUB      EQU    $1A      ; clear screen + home (alternate)
ESC      EQU    $1B      ; escape — windowing command prefix

; OS-9 Windowing (follow ESC)
W.DWSet  EQU    $20
W.Select EQU    $21
W.OWSet  EQU    $22      ; SVS CPX CPY SZX SZY PRN1 PRN2
W.OWEnd  EQU    $23
W.DWEnd  EQU    $24
W.CWArea EQU    $25      ; CPX CPY SZX SZY
W.DefClr EQU    $30
W.FColor EQU    $32      ; palette 0-15
W.Bcolor EQU    $33      ; palette 0-15
W.Border EQU    $34
W.DWProt EQU    $36
W.Font   EQU    $3A
W.BoldSw EQU    $3D
W.CurU   EQU    $41
W.CurD   EQU    $42
W.CurR   EQU    $43
W.CurL   EQU    $44
W.ClrHm  EQU    $45
W.Home   EQU    $48
W.ClrEOS EQU    $4A
W.ClrEOL EQU    $4B
W.InsLn  EQU    $4C
W.DelLn  EQU    $4D
W.DelCh  EQU    $4E
W.InsCh  EQU    $4F
W.ScRgn  EQU    $52
W.ScrlU  EQU    $53
W.ScrlD  EQU    $54
W.CurXY  EQU    $59      ; row+$20 col+$20
W.FgCol  EQU    $70
W.BgCol  EQU    $71
W.RevOn  EQU    $78
W.RevOff EQU    $79
W.UndOn  EQU    $7A
W.UndOff EQU    $7B

; Path numbers
STDIN    EQU    0
STDOUT   EQU    1
STDERR   EQU    2

; I$Open mode flags
O.Read   EQU    $01
O.Write  EQU    $02
O.RdWr   EQU    $03
O.Exec   EQU    $04
O.Dir    EQU    $05

; OS-9 I/O system calls
I$Attach EQU    $80
I$Detach EQU    $81
I$Dup    EQU    $82
I$Create EQU    $83
I$Open   EQU    $84
I$MakDir EQU    $85
I$ChgDir EQU    $86
I$Delete EQU    $87
I$Seek   EQU    $88
I$Read   EQU    $89
I$Write  EQU    $8A
I$ReadLn EQU    $8B
I$WritLn EQU    $8C
I$GetStt EQU    $8D
I$SetStt EQU    $8E
I$Close  EQU    $8F
I$DupS   EQU    $90

; OS-9 F$ system calls
F$Link   EQU    $00
F$Load   EQU    $01
F$UnLink EQU    $02
F$Fork   EQU    $03
F$Wait   EQU    $04
F$Chain  EQU    $05
F$Exit   EQU    $06
F$Mem    EQU    $07
F$Send   EQU    $08
F$Icpt   EQU    $09
F$Sleep  EQU    $0A
F$SSpd   EQU    $0B
F$ID     EQU    $0C
F$SPrior EQU    $0D
F$SSWI   EQU    $0E
F$PErr   EQU    $0F
F$PrsNam EQU    $10
F$CmpNam EQU    $11
F$SchBit EQU    $12
F$AllBit EQU    $13
F$DelBit EQU    $14
F$Time   EQU    $15
F$STime  EQU    $16
F$CRC    EQU    $17
F$GPrDsc EQU    $18
F$GBlkMp EQU    $19
F$GModDr EQU    $1A
F$CpyMem EQU    $1B
F$SUser  EQU    $1C
F$UnLoad EQU    $1D
F$RTE    EQU    $1E
F$GPrDBT EQU    $1F
F$Julian EQU    $20
F$TLink  EQU    $21
F$DFork  EQU    $22
F$DExec  EQU    $23
F$DExit  EQU    $24
F$DaTim  EQU    $25
F$ALARM  EQU    $26
F$SigMask EQU   $27
F$NMLink EQU    $28
; ================================================================
"""

# ── Project: binary-specific knowledge ────────────────────────────────────────

class Project:
    """
    All binary-specific knowledge for a disassembly project.
    Loaded from a JSON file; editable by hand between runs.
    """

    def __init__(self):
        self.binary       = None      # path to binary file
        self.cpu          = '6809'    # '6809' or '6309'
        self.output       = None      # path for output ASM
        self.entry        = None      # override entry point (int hex)
        self.module_notes = []        # free-form notes about the module
        self.labels       = {}        # int_addr -> label_str
        self.bss          = {}        # int_offset -> name_str
        self.data_regions = []        # [{start, end, label, comment}]
        self.line_comments= {}        # int_addr -> comment_str
        self.block_comments={}        # int_addr -> [lines] before instruction
        self.custom_equates=[]        # extra EQU lines to prepend
        self.footnotes    = {}        # int -> {inline, detail:[lines]}
        self.patches      = {}        # int_addr -> [bytes_to_insert_before_addr]
        self.forced_equs  = {}        # int_addr -> comment (emit as EQU, not instruction)

    @classmethod
    def from_json(cls, path):
        """Load project from JSON file."""
        p = cls()
        with open(path) as f:
            d = json.load(f)

        p.binary        = d.get('binary', '')
        p.cpu           = d.get('cpu', '6809')  # '6809' or '6309'
        p.output        = d.get('output', None)
        p.module_notes  = d.get('module_notes', [])
        p.custom_equates= d.get('custom_equates', [])

        # entry: hex string or None
        entry = d.get('entry', None)
        p.entry = int(entry, 16) if isinstance(entry, str) else entry

        # labels: "HHHH" -> "Name"
        p.labels = {int(k,16): v for k,v in d.get('labels', {}).items()}

        # bss: decimal int or "D" -> "Name"  (support both "51" and 51)
        for k,v in d.get('bss', {}).items():
            p.bss[int(k)] = v

        # data_regions: [{start:"HHHH", end:"HHHH", label:"X", comment:"Y"}]
        for r in d.get('data_regions', []):
            p.data_regions.append({
                'start':   int(r['start'], 16),
                'end':     int(r['end'],   16),
                'label':   r.get('label', f"Dat_{r['start']}"),
                'comment': r.get('comment', ''),
                'format':  r.get('format', 'auto'),  # 'auto','fdb','raw'
            })

        # line_comments: "HHHH" -> "text"
        p.line_comments = {int(k,16): v
                           for k,v in d.get('line_comments', {}).items()}

        # block_comments: "HHHH" -> ["line1","line2",...]
        p.block_comments = {int(k,16): v if isinstance(v,list) else [v]
                            for k,v in d.get('block_comments', {}).items()}
        # forced_equs: {"HHHH": "comment"} — mid-instruction overlap addresses
        p.forced_equs = {int(k, 16): v 
                         for k, v in d.get('forced_equs', {}).items()}

        # patches: {"HHHH": {"insert":["$xx",...], "comment":"..."}}
        p.patches = {}
        for k, v in d.get('patches', {}).items():
            addr = int(k, 16)
            bytes_list = [int(b.strip().lstrip('$'), 16) for b in v.get('insert', [])]
            p.patches[addr] = {'bytes': bytes_list, 'comment': v.get('comment', '')}

        # footnotes: {"1": {inline:"...", detail:["line1","line2"]}}
        p.footnotes = {}
        for k, v in d.get('footnotes', {}).items():
            p.footnotes[int(k)] = {
                'inline': v.get('inline', ''),
                'detail': v.get('detail', []),
            }
        return p

    def to_json(self, path):
        """Save project to JSON file."""
        d = {
            'binary':  self.binary,
            'cpu':     self.cpu,
            'output':  self.output,
            'entry':   f'{self.entry:04X}' if self.entry else None,
            'module_notes':   self.module_notes,
            'custom_equates': self.custom_equates,
            'labels':         {f'{k:04X}': v for k,v in sorted(self.labels.items())},
            'bss':            {str(k): v for k,v in sorted(self.bss.items())},
            'data_regions':   [
                {'start': f'{r["start"]:04X}', 'end': f'{r["end"]:04X}',
                 'label': r['label'], 'comment': r['comment'],
                 'format': r.get('format','auto')}
                for r in self.data_regions
            ],
            'line_comments':  {f'{k:04X}': v
                               for k,v in sorted(self.line_comments.items())},
            'block_comments': {f'{k:04X}': v
                               for k,v in sorted(self.block_comments.items())},
            'footnotes':     {str(k): v for k,v in sorted(p.footnotes.items()) if hasattr(p,'footnotes')},
        }
        with open(path, 'w') as f:
            json.dump(d, f, indent=2)

    @classmethod
    def scaffold(cls, binary_path, output_path=None):
        """Create a minimal project scaffold for a new binary."""
        p = cls()
        p.binary = binary_path
        p.output = output_path or binary_path + '.asm'
        p.module_notes = ["Add notes about this module here."]
        p.cpu = '6809'  # change to '6309' for Hitachi HD6309 binaries
        return p


# ── Engine: generalized disassembler ─────────────────────────────────────────

class Engine:
    """
    Two-pass recursive-descent disassembler for OS-9 6809 binaries.

    Pass 1: Trace all code paths from declared entry point and any
            project-declared entry points.  Classify each referenced
            address as KIND_CODE or KIND_DATA.  Apply explicit
            data_regions from the project.

    Pass 2: Walk sorted label spans.  DATA spans → annotated FCB/FCC.
            CODE spans → disassembled instructions with comments.
    """

    def __init__(self, project=None):
        self.project  = project or Project()
        self.data     = None      # bytearray
        self.hdr      = {}        # parsed module header
        self.exec_off = 0
        self.crc_off  = 0
        self.labels   = {}        # addr -> str
        self.regions  = {}        # addr -> KIND_CODE | KIND_DATA
        self.xrefs    = {}        # data_addr -> [code_addrs that LEA to it]
        self._output  = []        # rendered lines
        self.insn_spans = {}      # addr -> end_addr for each decoded instruction
        self.found_6309 = False   # set True if any 6309-specific instruction found
        self.data_hints = {}      # data_addr -> dict with format hints (e.g. 'iwrite')

    def load(self, data: bytes):
        self.data = bytearray(data)
        self.hdr  = self._parse_header()
        self.exec_off = (self.project.entry
                         if self.project.entry is not None
                         else self.hdr['exec_off'])
        self.crc_off  = self.hdr['crc_off']

    # ── Header ────────────────────────────────────────────────────────────

    def _parse_header(self):
        d = self.data
        if len(d) < 13 or d[0] != 0x87 or d[1] != 0xCD:
            raise ValueError(
                f"Not an OS-9 module (expected $87CD, got ${d[0]:02X}{d[1]:02X})")
        mod_size = (d[2]<<8)|d[3]
        name_off = (d[4]<<8)|d[5]
        exec_off = (d[9]<<8)|d[10]
        bss_size = (d[11]<<8)|d[12]
        name = []
        i = name_off
        while i < min(len(d), name_off+64):
            b = d[i]; i += 1
            name.append(chr(b & 0x7F))
            if b & 0x80: break
        crc_off = mod_size - 3
        crc = (d[crc_off]<<16)|(d[crc_off+1]<<8)|d[crc_off+2] if crc_off+2 < len(d) else None
        TYPE_NAMES = {1:"program",2:"subroutine",3:"multi-module",4:"data",
                      0x0B:"trap lib",0x0C:"system",0x0D:"file mgr",
                      0x0E:"device drvr",0x0F:"device desc",0x11:"program"}
        return {
            'mod_size': mod_size, 'name_off': name_off,
            'mod_type': d[6], 'lang': d[7], 'attr': d[8],
            'exec_off': exec_off, 'bss_size': bss_size,
            'mod_name': ''.join(name),
            'crc_off':  crc_off, 'crc': crc,
            'type_name': TYPE_NAMES.get(d[6]&0x0F, f'${d[6]:02X}'),
        }

    # ── Pass 1: recursive-descent classification ──────────────────────────

    def _decode_indexed_pb(self, pos):
        """Decode postbyte. Returns (new_pos, pc_target_or_None)."""
        d = self.data
        pb = d[pos]; pos += 1
        if not (pb & 0x80): return pos, None
        md = pb & 0x1F
        if md == 0x0C:
            off = s8(d[pos]); pos += 1; return pos, pos+off
        elif md == 0x0D:
            off = s16((d[pos]<<8)|d[pos+1]); pos += 2; return pos, pos+off
        elif md in (0x08,0x18): return pos+1, None
        elif md in (0x09,0x19): return pos+2, None
        elif md == 0x1F:        return pos+2, None
        # 6309 extended indirect modes
        elif md == 0x0E:        return pos+1, None  # [n8,PC] indirect
        elif md == 0x0F:        return pos+2, None  # [n16,PC] indirect
        elif md == 0x1E:        return pos+2, None  # [addr] extended indirect
        else:                   return pos, None

    def pass1(self):
        """Recursive-descent tracing. Populates self.labels and self.regions."""
        d = self.data
        exec_off = self.exec_off
        crc_off  = self.crc_off
        refs     = {}   # addr -> set of kinds

        def add(addr, kind):
            if addr not in refs: refs[addr] = set()
            refs[addr].add(kind)

        # Seed: entry point + any project labels that are code
        add(exec_off, KIND_CODE)
        for addr, name in self.project.labels.items():
            if exec_off <= addr < crc_off:
                # Project labels in code section are assumed CODE
                # unless they're in a declared data_region
                add(addr, KIND_CODE)

        visited  = set()
        worklist = [exec_off] + [a for a in self.project.labels
                                  if exec_off <= a < crc_off]

        while worklist:
            start = worklist.pop()
            if start in visited: continue
            if not (exec_off <= start < crc_off): continue

            pos = start
            # Context window for syscall-aware data characterisation
            # Tracks the most recent LEAX→X target and LDY immediate within
            # a linear trace sequence, reset at each new worklist entry.
            ctx_leax_x  = None   # last PC-relative LEAX into X → data addr
            ctx_ldy_imm = None   # last LDY #n immediate value
            while pos < crc_off and pos not in visited:
                visited.add(pos)
                insn_start = pos
                try:
                    op = d[pos]; pos += 1
                except IndexError:
                    break

                stop = False

                # ── branches / calls → CODE ───────────────────────────
                if op in range(0x20, 0x30):          # short branches
                    off = s8(d[pos]); pos += 1
                    t = pos + off; add(t, KIND_CODE); worklist.append(t)
                    if op == 0x20: stop = True       # BRA unconditional
                elif op == 0x8D:                     # BSR
                    off = s8(d[pos]); pos += 1
                    t = pos + off; add(t, KIND_CODE); worklist.append(t)
                elif op == 0x17:                     # LBSR
                    off = s16((d[pos]<<8)|d[pos+1]); pos += 2
                    t = pos + off; add(t, KIND_CODE); worklist.append(t)
                elif op == 0x16:                     # LBRA
                    off = s16((d[pos]<<8)|d[pos+1]); pos += 2
                    t = pos + off; add(t, KIND_CODE); worklist.append(t)
                    stop = True
                elif op == 0x7E:                     # JMP ext
                    t = (d[pos]<<8)|d[pos+1]; pos += 2
                    add(t, KIND_CODE); worklist.append(t); stop = True
                elif op == 0xBD:                     # JSR ext
                    t = (d[pos]<<8)|d[pos+1]; pos += 2
                    add(t, KIND_CODE); worklist.append(t)
                elif op in (0x39, 0x3B):             # RTS, RTI
                    stop = True
                elif op == 0x35:                     # PULS
                    pb = d[pos]; pos += 1
                    if pb & 0x80: stop = True        # PULS PC = RTS
                elif op == 0x37:                     # PULU
                    pb = d[pos]; pos += 1
                    if pb & 0x80: stop = True

                # ── LEA PC-relative → DATA ────────────────────────────
                elif op in (0x30, 0x31, 0x32, 0x33):
                    pb = d[pos]
                    if pb == 0x8D:
                        pos += 1
                        off = s16((d[pos]<<8)|d[pos+1]); pos += 2
                        t = pos + off; add(t, KIND_DATA)
                        if op == 0x30: ctx_leax_x = t   # LEAX ,PC → track X
                    else:
                        pos, t = self._decode_indexed_pb(pos)
                        if t is not None:
                            add(t, KIND_DATA)
                            if op == 0x30: ctx_leax_x = t  # LEAX indexed → track X

                # ── Page 1 ($10) ──────────────────────────────────────
                elif op == 0x10:
                    op2 = d[pos]; pos += 1
                    if op2 in range(0x21, 0x30):
                        off = s16((d[pos]<<8)|d[pos+1]); pos += 2
                        t = pos + off; add(t, KIND_CODE); worklist.append(t)
                        if op2 == 0x16: stop = True
                    elif op2 == 0x16:  # 6309 LBRA
                        off = s16((d[pos]<<8)|d[pos+1]); pos += 2
                        t = pos + off; add(t, KIND_CODE); worklist.append(t); stop = True
                    elif op2 == 0x17:  # 6309 LBSR
                        off = s16((d[pos]<<8)|d[pos+1]); pos += 2
                        t = pos + off; add(t, KIND_CODE); worklist.append(t)
                    elif op2 == 0x20:  # 6309 LBRA variant
                        off = s16((d[pos]<<8)|d[pos+1]); pos += 2
                        t = pos + off; add(t, KIND_CODE); worklist.append(t); stop = True
                    elif op2 == 0x3F:   # OS9 syscall
                        sc = d[pos]; pos += 1
                        if sc == 0x8A and ctx_leax_x is not None:  # I$Write
                            hint = {'syscall': 'I$Write', 'caller': insn_start}
                            if ctx_ldy_imm is not None:
                                hint['count'] = ctx_ldy_imm
                            self.data_hints[ctx_leax_x] = hint
                    # 6309 register-register (1 post-byte)
                    elif op2 in (0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x3D,0x3E,0x3F): pos += 1
                    # 6309 PSHSW/PULSW/PSHUW/PULUW (no operand)
                    elif op2 in (0x38,0x39,0x3A,0x3B): pass
                    # 6309 inherent D/W ops (no operand)
                    elif op2 in (0x43,0x44,0x46,0x47,0x48,0x49,0x4A,0x4C,0x4D,0x4F,
                                 0x53,0x54,0x56,0x59,0x5A,0x5C,0x5D,0x5F): pass
                    # 6309 W immediate (2 bytes)
                    elif op2 in (0x80,0x81,0x86,0xCC): pos+=2
                    # 6309 W direct (1 byte)
                    elif op2 in (0x90,0x91,0x97,0xC6,0xD6,0xD7): pos+=1
                    # 6309 W indexed
                    elif op2 in (0xA6,0xA7,0xA9):
                        pos, t = self._decode_indexed_pb(pos)
                        if t is not None: add(t, KIND_DATA)
                    # 6309 W extended (2 bytes)
                    elif op2 in (0xB6,0xB7,0xBF,0xF6,0xF7,0xFD): pos+=2
                    # 6309 LDQ immediate (4 bytes)
                    elif op2 == 0xCC: pos+=4
                    elif op2 in (0x83,0x8C,0xCE,0xB3,0xBC,0xFE,0xFF): pos+=2
                    elif op2 == 0x8E:   # LDY immediate — track for I$Write context
                        v = (d[pos]<<8)|d[pos+1]; pos += 2
                        ctx_ldy_imm = v
                    elif op2 in (0x93,0x9C,0x9E,0x9F): pos += 1
                    elif op2 in (0xAE,0xAF,0xA3,0xAC):
                        pos, t = self._decode_indexed_pb(pos)
                        if t is not None: add(t, KIND_DATA)

                # ── Page 2 ($11) ──────────────────────────────────────
                elif op == 0x11:
                    op2 = d[pos]; pos += 1
                    if op2 == 0x3F:   pos += 1
                    elif op2 in (0x83,0x8C,0xB3,0xBC): pos += 2
                    elif op2 in (0x93,0x9C): pos += 1
                    elif op2 in (0xA3,0xAC):
                        pos, t = self._decode_indexed_pb(pos)
                        if t is not None: add(t, KIND_DATA)
                    # 6309 page 2 ops
                    elif op2 in (0x38,0x39): pos += 1  # BITMD/LDMD #imm

                # ── indexed ───────────────────────────────────────────
                elif op in (
                    0x60,0x63,0x64,0x66,0x67,0x68,0x69,0x6A,0x6C,0x6D,
                    0x6E,0x6F,0xA0,0xA1,0xA2,0xA3,0xA4,0xA5,0xA6,0xA7,
                    0xA8,0xA9,0xAA,0xAB,0xAC,0xAD,0xAE,0xAF,
                    0xE0,0xE1,0xE2,0xE3,0xE4,0xE5,0xE6,0xE7,0xE8,0xE9,
                    0xEA,0xEB,0xEC,0xED,0xEE,0xEF):
                    pos, t = self._decode_indexed_pb(pos)
                    if t is not None:
                        kind = KIND_CODE if op == 0xAD else KIND_DATA
                        add(t, kind)
                        if op == 0xAD: worklist.append(t)
                    if op == 0x6E: stop = True     # JMP indexed

                # ── immediate/direct/extended — advance over operands ──
                elif op in (0x80,0x81,0x82,0x84,0x85,0x86,0x88,0x89,0x8A,
                            0x8B,0x8C,0x8E,0xC0,0xC1,0xC2,0xC4,0xC5,0xC6,
                            0xC8,0xC9,0xCA,0xCB,0x1A,0x1C,0x3C): pos += 1
                elif op in (0x83,0xCC,0xCE): pos += 2
                elif op in (0x1E,0x1F,0x34,0x36): pos += 1
                elif op in (
                    0x90,0x91,0x92,0x93,0x94,0x95,0x96,0x97,0x98,0x99,
                    0x9A,0x9B,0x9C,0x9D,0x9E,0x9F,0xD0,0xD1,0xD2,0xD3,
                    0xD4,0xD5,0xD6,0xD7,0xD8,0xD9,0xDA,0xDB,0xDC,0xDD,
                    0xDE,0xDF): pos += 1
                elif op in (
                    0xB0,0xB1,0xB2,0xB3,0xB4,0xB5,0xB6,0xB7,0xB8,0xB9,
                    0xBA,0xBB,0xBC,0xBD,0xBE,0xBF,0xF0,0xF1,0xF2,0xF3,
                    0xF4,0xF5,0xF6,0xF7,0xF8,0xF9,0xFA,0xFB,0xFC,0xFD,
                    0xFE,0xFF,0x70,0x73,0x74,0x76,0x77,0x78,0x79,0x7A,
                    0x7C,0x7D,0x7E,0x7F): pos += 2
                # single-byte ops: nothing to advance

                # Record instruction span: insn_start -> pos
                self.insn_spans[insn_start] = pos

                if stop: break

        # ── Apply project data_regions (override auto-classification) ──
        forced_data = {}   # addr -> True
        for r in self.project.data_regions:
            # Force the region start as DATA, and mark interior as forced
            add(r['start'], KIND_DATA)
            for addr in range(r['start'], r['end']):
                forced_data[addr] = True

        # ── Resolve final labels and regions ──────────────────────────
        labels  = {}
        regions = {}

        for addr, kinds in refs.items():
            if addr < exec_off:
                regions[addr] = KIND_DATA
                labels[addr]  = f"Dat_{addr:04X}"
            elif addr >= crc_off:
                pass
            else:
                # CODE wins unless address is inside a forced data region
                if addr in forced_data:
                    regions[addr] = KIND_DATA
                    labels[addr]  = f"Dat_{addr:04X}"
                elif KIND_CODE in kinds:
                    regions[addr] = KIND_CODE
                    labels[addr]  = f"Sub_{addr:04X}"
                else:
                    regions[addr] = KIND_DATA
                    labels[addr]  = f"Dat_{addr:04X}"

        # Entry point always Code
        labels[exec_off]  = 'Init'
        regions[exec_off] = KIND_CODE

        # Apply project label names (override auto-generated names)
        for addr, name in self.project.labels.items():
            labels[addr] = name
            # If a project label exists in code section, force CODE
            # unless it's explicitly in a data_region
            if exec_off <= addr < crc_off and addr not in forced_data:
                regions[addr] = KIND_CODE

        # Apply project data_region labels
        for r in self.project.data_regions:
            labels[r['start']]  = r['label']
            regions[r['start']] = KIND_DATA

        self.labels  = labels
        self.regions = regions

        # ── Cross-reference map ───────────────────────────────────────
        # xrefs[target] = [code_addr, ...] for every LEAX/LEAY/LEAS/LEAU
        # PC-relative instruction in the code section that points to target.
        # Used by render() to annotate each data label with its callers,
        # so a human analyst can quickly determine the format of the data.
        xrefs = {}
        d = self.data
        pos = exec_off
        while pos < crc_off - 3:
            op = d[pos]
            if op in (0x30, 0x31, 0x32, 0x33) and d[pos+1] == 0x8D:
                off = s16((d[pos+2]<<8)|d[pos+3])
                tgt = pos + 4 + off
                if 0 < tgt < crc_off:
                    if tgt not in xrefs: xrefs[tgt] = []
                    xrefs[tgt].append(pos)
                pos += 4
            else:
                pos += 1
        self.xrefs = xrefs

        n_data = sum(1 for a,k in regions.items() if k==KIND_DATA and a>=exec_off)
        n_code = sum(1 for k in regions.values() if k==KIND_CODE)
        print(f"; Pass 1: {len(labels)} labels  "
              f"({n_code} code  {n_data} data in code section)",
              file=sys.stderr)

    # ── Pass 2: instruction decoder ───────────────────────────────────────

    def _char_ann(self, v):
        if 32<=v<127: return f"'{chr(v)}'"
        return {0x0D:'CR',0x0A:'LF',0x1B:'ESC',0x00:'NUL',
                0x02:'CurXY',0x11:'XON',0x13:'XOFF',
                0x08:'BS',0x0C:'FF',0x1A:'SUB'}.get(v,'')

    def _cc_str(self, v):
        return ','.join(n for i,n in enumerate(['C','V','Z','N','I','H','F','E'])
                        if v&(1<<i)) or 'none'

    def _push_regs(self, pb, use_u):
        nms = ['CC','A','B','DP','X','Y','U' if use_u else 'S','PC']
        return ','.join(n for i,n in enumerate(nms) if pb&(1<<i))

    def _idx_full(self, pos):
        """Decode indexed postbyte with full label/BSS resolution."""
        d = self.data
        pb = d[pos]; pos += 1
        rn = {0:'X',1:'Y',2:'U',3:'S'}[(pb>>5)&3]
        ind = (pb & 0x10) != 0
        w = lambda s: f"[{s}]" if ind else s

        if not (pb & 0x80):
            off = pb & 0x1F
            if off >= 16: off -= 32
            if rn == 'U' and not ind:
                bn = self.project.bss.get(off,'')
                if bn: return f"{bn},U", pos
            return f"{off},{rn}", pos

        md = pb & 0x1F
        if md == 0x00: return w(f",{rn}+"),  pos
        elif md == 0x01: return w(f",{rn}++"), pos
        elif md == 0x02: return w(f",-{rn}"),  pos
        elif md == 0x03: return w(f",--{rn}"), pos
        elif md == 0x04: return w(f",{rn}"),   pos
        elif md == 0x05: return w(f"B,{rn}"),  pos
        elif md == 0x06: return w(f"A,{rn}"),  pos
        elif md == 0x08:
            off = s8(d[pos]); pos += 1
            if rn == 'U' and not ind:
                bn = self.project.bss.get(off,'')
                if bn: return f"{bn},U", pos
            return w(f"{off},{rn}"), pos
        elif md == 0x09:
            off = s16((d[pos]<<8)|d[pos+1]); pos += 2
            if rn == 'U' and not ind:
                bn = self.project.bss.get(off,'')
                if bn: return f"{bn},U", pos
            return w(f"{off},{rn}"), pos
        elif md == 0x0B: return w(f"D,{rn}"), pos
        elif md == 0x0C or md == 0x1C:  # 8-bit PCR (direct or indirect)
            off = s8(d[pos]); pos += 1; tgt = pos+off
            lb = self.labels.get(tgt,'')
            return w(f"{lb},PC" if lb else f"{off:+d},PC"), pos
        elif md == 0x0D or md == 0x1D:  # 16-bit PCR (direct or indirect)
            off = s16((d[pos]<<8)|d[pos+1]); pos += 2; tgt = pos+off
            lb = self.labels.get(tgt,'')
            return w(f"{lb},PC" if lb else f"{off:+d},PC"), pos
        elif md == 0x11: return w(f",{rn}++"), pos
        elif md == 0x13: return w(f",--{rn}"), pos
        elif md == 0x14: return w(f",{rn}"),   pos
        elif md == 0x15: return w(f"B,{rn}"),  pos   # 6309
        elif md == 0x16: return w(f"A,{rn}"),  pos   # 6309
        elif md == 0x17: return w(f"E,{rn}"),  pos   # 6309
        elif md == 0x18: off=s8(d[pos]);  pos+=1; return w(f"{off},{rn}"), pos
        elif md == 0x19: off=s16((d[pos]<<8)|d[pos+1]); pos+=2; return w(f"{off},{rn}"), pos
        elif md == 0x1A: return w(f"F,{rn}"),  pos   # 6309
        elif md == 0x1B: return w(f"D,{rn}"),  pos   # 6309
        elif md == 0x1D: return w(f"W,{rn}"),  pos   # 6309
        elif md == 0x1F: a=(d[pos]<<8)|d[pos+1]; pos+=2; return f"[${a:04X}]", pos
        # 6309 PC-relative indirect modes
        elif md == 0x0E or md == 0x1E:
            off = s8(d[pos]); pos += 1; tgt = pos+off
            lb = self.labels.get(tgt,'')
            return f"[{lb},PC]" if lb else f"[{off:+d},PC]", pos
        elif md == 0x0F or md == 0x1F:
            a=(d[pos]<<8)|d[pos+1]; pos+=2
            return f"[${a:04X}]", pos
        else: return f"?${pb:02X}", pos

    def _lea_pc(self, pos):
        """Handle LEAX/LEAY/LEAS/LEAU with possible PC-relative."""
        d = self.data
        pb = d[pos]
        if pb == 0x8D:
            pos += 1
            off = s16((d[pos]<<8)|d[pos+1]); pos += 2; tgt = pos+off
            lb = self.labels.get(tgt,'')
            # Always include ,PC so assembler knows to use PCR mode
            return (f"{lb},PC" if lb else f'{off:+d},PC'), tgt, pos
        else:
            s2, pos = self._idx_full(pos)
            return s2, None, pos

    def decode_one(self, pos):
        """
        Decode one instruction.
        Returns (mnemonic, operand, comment, raw_bytes, new_pos).
        """
        d    = self.data
        lbs  = self.labels
        start= pos
        mn='???'; op_str=''; cm=''

        def rb():
            nonlocal pos; v=d[pos]; pos+=1; return v
        def rw():
            nonlocal pos; v=(d[pos]<<8)|d[pos+1]; pos+=2; return v
        def rq():
            nonlocal pos; v=(d[pos]<<24)|(d[pos+1]<<16)|(d[pos+2]<<8)|d[pos+3]; pos+=4; return v
        def rel8():
            o=s8(rb()); t=(pos+o)&0xFFFF; return lbs.get(t,f'${t:04X}'), t
        def rel16():
            o=s16(rw()); t=(pos+o)&0xFFFF; return lbs.get(t,f'${t:04X}'), t
        def idx():
            nonlocal pos; s2,pos=self._idx_full(pos); return s2
        def lea():
            nonlocal pos; s2,tgt,pos=self._lea_pc(pos); return s2, tgt

        IREG16={0:'D',1:'X',2:'Y',3:'U',4:'S',5:'PC',
                6:'W',7:'V',8:'A',9:'B',10:'CC',11:'DP',
                14:'E',15:'F'}  # 6309 extensions: W,V,E,F

        op = rb()

        if op==0x10:
            op2=rb()
            LB={0x21:'LBRN',0x22:'LBHI',0x23:'LBLS',0x24:'LBCC',0x25:'LBCS',
                0x26:'LBNE',0x27:'LBEQ',0x28:'LBVC',0x29:'LBVS',0x2A:'LBPL',
                0x2B:'LBMI',0x2C:'LBGE',0x2D:'LBLT',0x2E:'LBGT',0x2F:'LBLE',
                0x16:'LBRA',0x17:'LBSR',0x20:'LBRA'}  # 6309 page1 variants
            if op2 in LB: l,t=rel16(); mn=LB[op2]; op_str=l
            elif op2==0x3F:
                sc=rb(); nm,conv=OS9_SYSCALLS.get(sc,(f'${sc:02X}',''))
                mn='OS9'; op_str=nm; cm=conv
            elif op2==0x83: v=rw(); mn='CMPD'; op_str=f'#${v:04X}'
            elif op2==0x8C: v=rw(); mn='CMPY'; op_str=f'#${v:04X}'
            elif op2==0x8E: v=rw(); mn='LDY';  op_str=f'#${v:04X}'
            elif op2==0xCE: v=rw(); mn='LDS';  op_str=f'#${v:04X}'
            elif op2==0x9E: v=rb(); mn='LDY';  op_str=f'<${v:02X}'
            elif op2==0x9F: v=rb(); mn='STY';  op_str=f'<${v:02X}'
            elif op2==0x93: v=rb(); mn='CMPD'; op_str=f'<${v:02X}'
            elif op2==0x9C: v=rb(); mn='CMPY'; op_str=f'<${v:02X}'
            elif op2==0xAE: op_str=idx(); mn='LDY'
            elif op2==0xAF: op_str=idx(); mn='STY'
            elif op2==0xA3: op_str=idx(); mn='CMPD'
            elif op2==0xAC: op_str=idx(); mn='CMPY'
            elif op2==0xBE: v=rw(); mn='LDY'; op_str=f'${v:04X}'
            elif op2==0xBF: v=rw(); mn='STY'; op_str=f'${v:04X}'
            elif op2==0xFE: v=rw(); mn='LDS'; op_str=f'${v:04X}'
            elif op2==0xFF: v=rw(); mn='STS'; op_str=f'${v:04X}'
            elif op2==0xB3: v=rw(); mn='CMPD'; op_str=f'${v:04X}'
            elif op2==0xBC: v=rw(); mn='CMPY'; op_str=f'${v:04X}'
            # ── 6309 page 1 ops ──────────────────────────────────────
            # Register-register ops (1 post-byte)
            elif op2 in (0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x3F):
                names6309 = {0x30:'ADDR',0x31:'ADCR',0x32:'SUBR',0x33:'SBCR',
                             0x34:'ANDR',0x35:'ORR',0x36:'EORR',0x37:'CMPR',
                             0x38:'PSHSW',0x39:'PULSW',0x3A:'PSHUW',0x3B:'PULUW',
                             0x3D:'MULD',0x3E:'DIVD',0x3F:'DIVQ'}
                if op2 in (0x38,0x39,0x3A,0x3B): mn=names6309[op2]; self.found_6309=True
                elif op2 in (0x3D,0x3E,0x3F): mn=names6309[op2]; self.found_6309=True
                else:
                    pb=rb(); s2=IREG16.get((pb>>4)&0xF,'?'); d2=IREG16.get(pb&0xF,'?')
                    mn=names6309.get(op2,f'10{op2:02X}?'); op_str=f'{s2},{d2}'
                    self.found_6309=True
            # Inherent D/W register ops
            elif op2==0x43: mn='COMD'; self.found_6309=True
            elif op2==0x44: mn='LSRD'; self.found_6309=True
            elif op2==0x46: mn='RORD'; self.found_6309=True
            elif op2==0x47: mn='ASRD'; self.found_6309=True
            elif op2==0x48: mn='ASLD'; self.found_6309=True
            elif op2==0x49: mn='ROLD'; self.found_6309=True
            elif op2==0x4A: mn='DECD'; self.found_6309=True
            elif op2==0x4C: mn='INCD'; self.found_6309=True
            elif op2==0x4D: mn='TSTD'; self.found_6309=True
            elif op2==0x4F: mn='CLRD'; self.found_6309=True
            elif op2==0x53: mn='COMW'; self.found_6309=True
            elif op2==0x54: mn='LSRW'; self.found_6309=True
            elif op2==0x56: mn='RORW'; self.found_6309=True
            elif op2==0x59: mn='ROLW'; self.found_6309=True
            elif op2==0x5A: mn='DECW'; self.found_6309=True
            elif op2==0x5C: mn='INCW'; self.found_6309=True
            elif op2==0x5D: mn='TSTW'; self.found_6309=True
            elif op2==0x5F: mn='CLRW'; self.found_6309=True
            # W register memory ops
            elif op2==0x80: v=rw(); mn='SUBW'; op_str=f'#${v:04X}'; self.found_6309=True
            elif op2==0x81: v=rw(); mn='CMPW'; op_str=f'#${v:04X}'; self.found_6309=True
            elif op2==0x86: v=rw(); mn='LDW';  op_str=f'#${v:04X}'; self.found_6309=True
            elif op2==0x90: v=rb(); mn='SUBW'; op_str=f'<${v:02X}'; self.found_6309=True
            elif op2==0x91: v=rb(); mn='CMPW'; op_str=f'<${v:02X}'; self.found_6309=True
            elif op2==0x97: v=rb(); mn='STW';  op_str=f'<${v:02X}'; self.found_6309=True
            elif op2==0xA6: op_str=idx(); mn='LDW'; self.found_6309=True
            elif op2==0xA7: op_str=idx(); mn='STW'; self.found_6309=True
            elif op2==0xA9: op_str=idx(); mn='ADCW'; self.found_6309=True
            elif op2==0xB6: v=rw(); mn='LDW'; op_str=f'${v:04X}'; self.found_6309=True
            elif op2==0xB7: v=rw(); mn='STW'; op_str=f'${v:04X}'; self.found_6309=True
            elif op2==0xBF: v=rw(); mn='STW'; op_str=f'${v:04X}'; self.found_6309=True
            elif op2==0xC6: v=rb(); mn='LDW'; op_str=f'<${v:02X}'; self.found_6309=True
            elif op2==0xCC: v=rq(); mn='LDQ'; op_str=f'#${v:08X}'; self.found_6309=True
            elif op2==0xD6: v=rb(); mn='LDW'; op_str=f'<${v:02X}'; self.found_6309=True
            elif op2==0xD7: v=rb(); mn='STW'; op_str=f'<${v:02X}'; self.found_6309=True
            elif op2==0xF6: v=rw(); mn='LDW'; op_str=f'${v:04X}'; self.found_6309=True
            elif op2==0xF7: v=rw(); mn='STW'; op_str=f'${v:04X}'; self.found_6309=True
            elif op2==0xFD: v=rw(); mn='STQ'; op_str=f'${v:04X}'; self.found_6309=True
            # TFM -- block transfer (4 variants, 1 post-byte)
            elif op2 in (0x38,0x39,0x3A,0x3B):
                tfm_modes = {0x38:'TFM r+,r+',0x39:'TFM r-,r-',0x3A:'TFM r+,r',0x3B:'TFM r,r+'}
                pb=rb(); s2=IREG16.get((pb>>4)&0xF,'?'); d2=IREG16.get(pb&0xF,'?')
                mn=tfm_modes.get(op2,'TFM'); op_str=f'{s2},{d2}'; self.found_6309=True
            # page 1 LBRA variant
            elif op2==0x16: l,t=rel16(); mn='LBRA'; op_str=l; stop=True
            elif op2==0x17: l,t=rel16(); mn='LBSR'; op_str=l
            elif op2==0x20: l,t=rel16(); mn='LBRA'; op_str=l; stop=True
            else: mn=f'FCB'; op_str=f'$10,${op2:02X}'; cm=f'unknown opcode $10{op2:02X}'
        elif op==0x11:
            op2=rb()
            if op2==0x3F:
                sc=rb(); nm,conv=OS9_SYSCALLS.get(sc,(f'${sc:02X}',''))
                mn='OS9'; op_str=nm; cm=conv
            elif op2==0x83: v=rw(); mn='CMPU'; op_str=f'#${v:04X}'
            elif op2==0x8C: v=rw(); mn='CMPS'; op_str=f'#${v:04X}'
            elif op2==0x93: v=rb(); mn='CMPU'; op_str=f'<${v:02X}'
            elif op2==0x9C: v=rb(); mn='CMPS'; op_str=f'<${v:02X}'
            elif op2==0xA3: op_str=idx(); mn='CMPU'
            elif op2==0xAC: op_str=idx(); mn='CMPS'
            elif op2==0xB3: v=rw(); mn='CMPU'; op_str=f'${v:04X}'
            elif op2==0xBC: v=rw(); mn='CMPS'; op_str=f'${v:04X}'
            # 6309 page 2 ops
            elif op2==0x38: v=rb(); mn='BITMD'; op_str=f'#${v:02X}'; cm='6309: test MD register bits'; self.found_6309=True
            elif op2==0x39: v=rb(); mn='LDMD';  op_str=f'#${v:02X}'; cm='6309: load MD register'; self.found_6309=True
            else:
                mn='FCB'; op_str=f'$11,${op2:02X}'; cm=f'unknown opcode $11{op2:02X}'
        elif op==0x12: mn='NOP'
        elif op==0x13: mn='SYNC'; cm='wait for interrupt'
        elif op==0x16: l,t=rel16(); mn='LBRA'; op_str=l
        elif op==0x17:
            l,t=rel16(); mn='LBSR'; op_str=l
            if t in lbs: cm=f"call {lbs[t]}"
        elif op==0x19: mn='DAA'
        elif op==0x1A: v=rb(); mn='ORCC';  op_str=f'#${v:02X}'; cm=f"set CC: {self._cc_str(v)}"
        elif op==0x1C: v=rb(); mn='ANDCC'; op_str=f'#${v:02X}'; cm=f"clr CC: {self._cc_str(~v&0xFF)}"
        elif op==0x1D: mn='SEX'; cm='sign-extend B into A'
        elif op==0x1E:
            pb=rb(); s2=IREG16.get((pb>>4)&0xF,'?'); d2=IREG16.get(pb&0xF,'?')
            if '?' in (s2, d2):
                mn='FCB'; op_str=f'${op:02X},${pb:02X}'; cm=f'EXG with unknown register code ${pb:02X}'
            else:
                mn='EXG'; op_str=f'{s2},{d2}'
                if any(r in (s2,d2) for r in ('W','V','E','F')): self.found_6309=True
        elif op==0x1F:
            pb=rb(); s2=IREG16.get((pb>>4)&0xF,'?'); d2=IREG16.get(pb&0xF,'?')
            if '?' in (s2, d2):
                mn='FCB'; op_str=f'${op:02X},${pb:02X}'; cm=f'TFR with unknown register code ${pb:02X}'
            else:
                mn='TFR'; op_str=f'{s2},{d2}'
                if any(r in (s2,d2) for r in ('W','V','E','F')): self.found_6309=True
        elif op==0x20: l,t=rel8(); mn='BRA'; op_str=l
        elif op==0x21: l,t=rel8(); mn='BRN'; op_str=l
        elif op==0x22: l,t=rel8(); mn='BHI'; op_str=l
        elif op==0x23: l,t=rel8(); mn='BLS'; op_str=l
        elif op==0x24: l,t=rel8(); mn='BCC'; op_str=l; cm='C=0 (BHS)'
        elif op==0x25: l,t=rel8(); mn='BCS'; op_str=l; cm='C=1 (BLO)'
        elif op==0x26: l,t=rel8(); mn='BNE'; op_str=l
        elif op==0x27: l,t=rel8(); mn='BEQ'; op_str=l
        elif op==0x28: l,t=rel8(); mn='BVC'; op_str=l
        elif op==0x29: l,t=rel8(); mn='BVS'; op_str=l
        elif op==0x2A: l,t=rel8(); mn='BPL'; op_str=l
        elif op==0x2B: l,t=rel8(); mn='BMI'; op_str=l
        elif op==0x2C: l,t=rel8(); mn='BGE'; op_str=l
        elif op==0x2D: l,t=rel8(); mn='BLT'; op_str=l
        elif op==0x2E: l,t=rel8(); mn='BGT'; op_str=l
        elif op==0x2F: l,t=rel8(); mn='BLE'; op_str=l
        elif op==0x30:
            s2,tgt=lea(); mn='LEAX'; op_str=s2
            if tgt and tgt in lbs: cm=f"X → {lbs[tgt]}"
        elif op==0x31:
            s2,tgt=lea(); mn='LEAY'; op_str=s2
            if tgt and tgt in lbs: cm=f"Y → {lbs[tgt]}"
        elif op==0x32:
            s2,tgt=lea(); mn='LEAS'; op_str=s2
        elif op==0x33:
            s2,tgt=lea(); mn='LEAU'; op_str=s2
            if tgt and tgt in lbs: cm=f"U → {lbs[tgt]}"
        elif op==0x34: pb=rb(); mn='PSHS'; op_str=self._push_regs(pb,True)
        elif op==0x35:
            pb=rb(); mn='PULS'; op_str=self._push_regs(pb,True)
            if pb&0x80: cm='return from subroutine  (PULS PC = RTS)'
        elif op==0x36: pb=rb(); mn='PSHU'; op_str=self._push_regs(pb,False)
        elif op==0x37: pb=rb(); mn='PULU'; op_str=self._push_regs(pb,False)
        elif op==0x39: mn='RTS'; cm='return from subroutine'
        elif op==0x3A: mn='ABX'
        elif op==0x3B: mn='RTI'; cm='return from interrupt'
        elif op==0x3C: v=rb(); mn='CWAI'; op_str=f'#${v:02X}'
        elif op==0x3D: mn='MUL'; cm='D = A×B unsigned'
        elif op==0x3F: mn='SWI'
        elif op==0x40: mn='NEGA'
        elif op==0x43: mn='COMA'
        elif op==0x44: mn='LSRA'
        elif op==0x46: mn='RORA'
        elif op==0x47: mn='ASRA'
        elif op==0x48: mn='LSLA'
        elif op==0x49: mn='ROLA'
        elif op==0x4A: mn='DECA'
        elif op==0x4C: mn='INCA'
        elif op==0x4D: mn='TSTA'
        elif op==0x4F: mn='CLRA'; cm='A = 0'
        elif op==0x50: mn='NEGB'
        elif op==0x53: mn='COMB'
        elif op==0x54: mn='LSRB'
        elif op==0x56: mn='RORB'
        elif op==0x57: mn='ASRB'
        elif op==0x58: mn='LSLB'
        elif op==0x59: mn='ROLB'
        elif op==0x5A: mn='DECB'
        elif op==0x5C: mn='INCB'
        elif op==0x5D: mn='TSTB'
        elif op==0x5F: mn='CLRB'; cm='B = 0'
        elif op==0x60: op_str=idx(); mn='NEG'
        elif op==0x63: op_str=idx(); mn='COM'
        elif op==0x64: op_str=idx(); mn='LSR'
        elif op==0x66: op_str=idx(); mn='ROR'
        elif op==0x67: op_str=idx(); mn='ASR'
        elif op==0x68: op_str=idx(); mn='LSL'
        elif op==0x69: op_str=idx(); mn='ROL'
        elif op==0x6A: op_str=idx(); mn='DEC'
        elif op==0x6C: op_str=idx(); mn='INC'
        elif op==0x6D: op_str=idx(); mn='TST'
        elif op==0x6E: op_str=idx(); mn='JMP'
        elif op==0x6F: op_str=idx(); mn='CLR'
        elif op==0x70: v=rw(); mn='NEG'; op_str=f'${v:04X}'
        elif op==0x73: v=rw(); mn='COM'; op_str=f'${v:04X}'
        elif op==0x74: v=rw(); mn='LSR'; op_str=f'${v:04X}'
        elif op==0x76: v=rw(); mn='ROR'; op_str=f'${v:04X}'
        elif op==0x77: v=rw(); mn='ASR'; op_str=f'${v:04X}'
        elif op==0x78: v=rw(); mn='LSL'; op_str=f'${v:04X}'
        elif op==0x79: v=rw(); mn='ROL'; op_str=f'${v:04X}'
        elif op==0x7A: v=rw(); mn='DEC'; op_str=f'${v:04X}'
        elif op==0x7C: v=rw(); mn='INC'; op_str=f'${v:04X}'
        elif op==0x7D: v=rw(); mn='TST'; op_str=f'${v:04X}'
        elif op==0x7E: v=rw(); mn='JMP'; op_str=f'${v:04X}'
        elif op==0x7F: v=rw(); mn='CLR'; op_str=f'${v:04X}'
        elif op==0x80: v=rb(); mn='SUBA'; op_str=f'#${v:02X}'
        elif op==0x81:
            v=rb(); mn='CMPA'; op_str=f'#${v:02X}'
            c2=self._char_ann(v); cm=f"compare A with {c2}" if c2 else ''
        elif op==0x82: v=rb(); mn='SBCA'; op_str=f'#${v:02X}'
        elif op==0x83: v=rw(); mn='SUBD'; op_str=f'#${v:04X}'
        elif op==0x84: v=rb(); mn='ANDA'; op_str=f'#${v:02X}'
        elif op==0x85: v=rb(); mn='BITA'; op_str=f'#${v:02X}'
        elif op==0x86:
            v=rb(); mn='LDA'; op_str=f'#${v:02X}'
            c2=self._char_ann(v); cm=f"A = {c2}" if c2 else ''
        elif op==0x88: v=rb(); mn='EORA'; op_str=f'#${v:02X}'
        elif op==0x89: v=rb(); mn='ADCA'; op_str=f'#${v:02X}'
        elif op==0x8A: v=rb(); mn='ORA';  op_str=f'#${v:02X}'
        elif op==0x8B: v=rb(); mn='ADDA'; op_str=f'#${v:02X}'
        elif op==0x8C: v=rw(); mn='CMPX'; op_str=f'#${v:04X}'
        elif op==0x8D:
            l,t=rel8(); mn='BSR'; op_str=l
            if t in lbs: cm=f"call {lbs[t]}"
        elif op==0x8E: v=rw(); mn='LDX';  op_str=f'#${v:04X}'
        elif op==0x90: v=rb(); mn='SUBA'; op_str=f'<${v:02X}'
        elif op==0x91: v=rb(); mn='CMPA'; op_str=f'<${v:02X}'
        elif op==0x92: v=rb(); mn='SBCA'; op_str=f'<${v:02X}'
        elif op==0x93: v=rb(); mn='SUBD'; op_str=f'<${v:02X}'
        elif op==0x94: v=rb(); mn='ANDA'; op_str=f'<${v:02X}'
        elif op==0x95: v=rb(); mn='BITA'; op_str=f'<${v:02X}'
        elif op==0x96: v=rb(); mn='LDA';  op_str=f'<${v:02X}'
        elif op==0x97: v=rb(); mn='STA';  op_str=f'<${v:02X}'
        elif op==0x98: v=rb(); mn='EORA'; op_str=f'<${v:02X}'
        elif op==0x99: v=rb(); mn='ADCA'; op_str=f'<${v:02X}'
        elif op==0x9A: v=rb(); mn='ORA';  op_str=f'<${v:02X}'
        elif op==0x9B: v=rb(); mn='ADDA'; op_str=f'<${v:02X}'
        elif op==0x9C: v=rb(); mn='CMPX'; op_str=f'<${v:02X}'
        elif op==0x9D: v=rb(); mn='JSR';  op_str=f'<${v:02X}'; cm='call via direct page'
        elif op==0x9E: v=rb(); mn='LDX';  op_str=f'<${v:02X}'
        elif op==0x9F: v=rb(); mn='STX';  op_str=f'<${v:02X}'
        elif op==0xA0: op_str=idx(); mn='SUBA'
        elif op==0xA1: op_str=idx(); mn='CMPA'
        elif op==0xA2: op_str=idx(); mn='SBCA'
        elif op==0xA3: op_str=idx(); mn='SUBD'
        elif op==0xA4: op_str=idx(); mn='ANDA'
        elif op==0xA5: op_str=idx(); mn='BITA'
        elif op==0xA6: op_str=idx(); mn='LDA'
        elif op==0xA7: op_str=idx(); mn='STA'
        elif op==0xA8: op_str=idx(); mn='EORA'
        elif op==0xA9: op_str=idx(); mn='ADCA'
        elif op==0xAA: op_str=idx(); mn='ORA'
        elif op==0xAB: op_str=idx(); mn='ADDA'
        elif op==0xAC: op_str=idx(); mn='CMPX'
        elif op==0xAD: op_str=idx(); mn='JSR'; cm='call via indexed pointer'
        elif op==0xAE: op_str=idx(); mn='LDX'
        elif op==0xAF: op_str=idx(); mn='STX'
        elif op==0xB0: v=rw(); mn='SUBA'; op_str=f'${v:04X}'
        elif op==0xB1: v=rw(); mn='CMPA'; op_str=f'${v:04X}'
        elif op==0xB2: v=rw(); mn='SBCA'; op_str=f'${v:04X}'
        elif op==0xB3: v=rw(); mn='SUBD'; op_str=f'${v:04X}'
        elif op==0xB4: v=rw(); mn='ANDA'; op_str=f'${v:04X}'
        elif op==0xB5: v=rw(); mn='BITA'; op_str=f'${v:04X}'
        elif op==0xB6: v=rw(); mn='LDA';  op_str=f'${v:04X}'
        elif op==0xB7: v=rw(); mn='STA';  op_str=f'${v:04X}'
        elif op==0xB8: v=rw(); mn='EORA'; op_str=f'${v:04X}'
        elif op==0xB9: v=rw(); mn='ADCA'; op_str=f'${v:04X}'
        elif op==0xBA: v=rw(); mn='ORA';  op_str=f'${v:04X}'
        elif op==0xBB: v=rw(); mn='ADDB'; op_str=f'${v:04X}'
        elif op==0xBC: v=rw(); mn='CMPX'; op_str=f'${v:04X}'
        elif op==0xBD:
            v=rw(); mn='JSR'; op_str=f'${v:04X}'
            lb=lbs.get(v,''); cm=f"call {lb}" if lb else ''
        elif op==0xBE: v=rw(); mn='LDX';  op_str=f'${v:04X}'
        elif op==0xBF: v=rw(); mn='STX';  op_str=f'${v:04X}'
        elif op==0xC0: v=rb(); mn='SUBB'; op_str=f'#${v:02X}'
        elif op==0xC1:
            v=rb(); mn='CMPB'; op_str=f'#${v:02X}'
            c2=self._char_ann(v); cm=f"compare B with {c2}" if c2 else ''
        elif op==0xC2: v=rb(); mn='SBCB'; op_str=f'#${v:02X}'
        elif op==0xC3: v=rw(); mn='ADDD'; op_str=f'#${v:04X}'
        elif op==0xC4: v=rb(); mn='ANDB'; op_str=f'#${v:02X}'
        elif op==0xC5: v=rb(); mn='BITB'; op_str=f'#${v:02X}'
        elif op==0xC6:
            v=rb(); mn='LDB'; op_str=f'#${v:02X}'
            ss=SS_CODES.get(v,''); c2=self._char_ann(v)
            if ss:   cm=f"B = {ss}  (GetStt/SetStt subcode)"
            elif c2: cm=f"B = {c2}"
        elif op==0xC8: v=rb(); mn='EORB'; op_str=f'#${v:02X}'
        elif op==0xC9: v=rb(); mn='ADCB'; op_str=f'#${v:02X}'
        elif op==0xCA: v=rb(); mn='ORB';  op_str=f'#${v:02X}'
        elif op==0xCB: v=rb(); mn='ADDB'; op_str=f'#${v:02X}'
        elif op==0xCC:
            v=rw(); mn='LDD'; op_str=f'#${v:04X}'
            hi=v>>8; lo=v&0xFF
            if hi==0x1B and lo in WIN_ESC:
                nm,desc,_=WIN_ESC[lo]; ch=chr(lo) if 32<=lo<127 else f'${lo:02X}'
                cm=f"D=ESC+'{ch}'  → {nm}: {desc}"
            elif hi==0x1B: cm=f"D=ESC+${lo:02X}"
        elif op==0xCE: v=rw(); mn='LDU'; op_str=f'#${v:04X}'
        elif op==0xD0: v=rb(); mn='SUBB'; op_str=f'<${v:02X}'
        elif op==0xD1: v=rb(); mn='CMPB'; op_str=f'<${v:02X}'
        elif op==0xD2: v=rb(); mn='SBCB'; op_str=f'<${v:02X}'
        elif op==0xD3: v=rb(); mn='ADDD'; op_str=f'<${v:02X}'
        elif op==0xD4: v=rb(); mn='ANDB'; op_str=f'<${v:02X}'
        elif op==0xD5: v=rb(); mn='BITB'; op_str=f'<${v:02X}'
        elif op==0xD6: v=rb(); mn='LDB';  op_str=f'<${v:02X}'
        elif op==0xD7: v=rb(); mn='STB';  op_str=f'<${v:02X}'
        elif op==0xD8: v=rb(); mn='EORB'; op_str=f'<${v:02X}'
        elif op==0xD9: v=rb(); mn='ADCB'; op_str=f'<${v:02X}'
        elif op==0xDA: v=rb(); mn='ORB';  op_str=f'<${v:02X}'
        elif op==0xDB: v=rb(); mn='ADDB'; op_str=f'<${v:02X}'
        elif op==0xDC: v=rb(); mn='LDD';  op_str=f'<${v:02X}'
        elif op==0xDD: v=rb(); mn='STD';  op_str=f'<${v:02X}'
        elif op==0xDE: v=rb(); mn='LDU';  op_str=f'<${v:02X}'
        elif op==0xDF: v=rb(); mn='STU';  op_str=f'<${v:02X}'
        elif op==0xE0: op_str=idx(); mn='SUBB'
        elif op==0xE1: op_str=idx(); mn='CMPB'
        elif op==0xE2: op_str=idx(); mn='SBCB'
        elif op==0xE3: op_str=idx(); mn='ADDD'
        elif op==0xE4: op_str=idx(); mn='ANDB'
        elif op==0xE5: op_str=idx(); mn='BITB'
        elif op==0xE6: op_str=idx(); mn='LDB'
        elif op==0xE7: op_str=idx(); mn='STB'
        elif op==0xE8: op_str=idx(); mn='EORB'
        elif op==0xE9: op_str=idx(); mn='ADCB'
        elif op==0xEA: op_str=idx(); mn='ORB'
        elif op==0xEB: op_str=idx(); mn='ADDB'
        elif op==0xEC: op_str=idx(); mn='LDD'
        elif op==0xED: op_str=idx(); mn='STD'
        elif op==0xEE: op_str=idx(); mn='LDU'
        elif op==0xEF: op_str=idx(); mn='STU'
        elif op==0xF0: v=rw(); mn='SUBB'; op_str=f'${v:04X}'
        elif op==0xF1: v=rw(); mn='CMPB'; op_str=f'${v:04X}'
        elif op==0xF2: v=rw(); mn='SBCB'; op_str=f'${v:04X}'
        elif op==0xF3: v=rw(); mn='ADDD'; op_str=f'${v:04X}'
        elif op==0xF4: v=rw(); mn='ANDB'; op_str=f'${v:04X}'
        elif op==0xF5: v=rw(); mn='BITB'; op_str=f'${v:04X}'
        elif op==0xF6: v=rw(); mn='LDB';  op_str=f'${v:04X}'
        elif op==0xF7: v=rw(); mn='STB';  op_str=f'${v:04X}'
        elif op==0xF8: v=rw(); mn='EORB'; op_str=f'${v:04X}'
        elif op==0xF9: v=rw(); mn='ADCB'; op_str=f'${v:04X}'
        elif op==0xFA: v=rw(); mn='ORB';  op_str=f'${v:04X}'
        elif op==0xFB: v=rw(); mn='ADDB'; op_str=f'${v:04X}'
        elif op==0xFC: v=rw(); mn='LDD';  op_str=f'${v:04X}'
        elif op==0xFD: v=rw(); mn='STD';  op_str=f'${v:04X}'
        elif op==0xFE: v=rw(); mn='LDU';  op_str=f'${v:04X}'
        elif op==0xFF: v=rw(); mn='STU';  op_str=f'${v:04X}'

        # If still unknown and cpu is 6309, try 6309-specific decoder
        if mn == '???' and getattr(self, '_cpu', '6809') == '6309':
            result = decode_6309(d, start, self.labels, self.project.bss)
            if result is not None:
                return result
        return mn, op_str.strip(), cm, bytes(d[start:pos]), pos

    # ── Data region emitter ───────────────────────────────────────────────

    def _emit_win_esc(self, i, end):
        """Emit one windowing ESC sequence as annotated FCB."""
        d = self.data
        if i+1 >= end: return ["         FCB    ESC"], 1
        nb = d[i+1]
        if nb not in WIN_ESC:
            return [f"         FCB    ESC,${nb:02X}"], 2
        nm, desc, nparams = WIN_ESC[nb]
        params = d[i+2:i+2+nparams]
        consumed = 2 + nparams
        if nparams == 0:
            return [f"         FCB    ESC,{nm:<10s}   ; {desc}"], 2
        if nb == 0x59 and nparams == 2:
            row=params[0]-0x20; col=params[1]-0x20
            return [f"         FCB    ESC,{nm},${params[0]:02X},${params[1]:02X}"
                    f"   ; CurXY(row={row},col={col})"], 4
        if nb in (0x32,0x33,0x34) and nparams == 1:
            return [f"         FCB    ESC,{nm},${params[0]:02X}         ; {desc} palette[{params[0]}]"], 3
        if nb == 0x25 and nparams == 4:
            cpx,cpy,szx,szy = params
            return [f"         FCB    ESC,{nm},${cpx:02X},${cpy:02X},${szx:02X},${szy:02X}"
                    f"  ; CPX={cpx} CPY={cpy} SZX={szx} SZY={szy}"], 6
        if nb == 0x22 and nparams == 7:
            svs,cpx,cpy,szx,szy,p1,p2 = params
            svsd = "save+restore" if svs else "no-save"
            return [
                f"         FCB    ESC,{nm}      ; {desc}",
                f"         FCB    ${svs:02X}               ; SVS={svsd}",
                f"         FCB    ${cpx:02X},${cpy:02X},${szx:02X},${szy:02X}  ; CPX={cpx} CPY={cpy} SZX={szx} SZY={szy}",
                f"         FCB    ${p1:02X},${p2:02X}          ; PRN1={p1} PRN2={p2}",
            ], 9
        # generic
        pb2 = ','.join(f'${x:02X}' for x in params)
        return [f"         FCB    ESC,{nm},{pb2}   ; {desc}"], consumed

    def emit_data(self, start, end, sub_labels=None, fmt='auto'):
        """
        Emit a data region as annotated FCB/FCC/FCS lines.
        fmt: 'auto' = SCF heuristics; 'fdb' = raw FDB pairs; 'raw' = plain FCB
        """
        out  = []
        d    = self.data
        lbs  = sub_labels or {}
        i    = start
        last_printable = False

        patches = self.project.patches if hasattr(self.project, 'patches') else {}

        while i < end:
            if i > start and i in lbs:
                out.append(""); out.append(f"{lbs[i]}")

            # Apply any patch insertions before this address
            if i in patches:
                patch = patches[i]
                cmt = f"  ; {patch['comment']}" if patch.get('comment') else ''
                args = ','.join(f"${b:02X}" for b in patch['bytes'])
                out.append(f"         FCB    {args}{cmt}")

            b = d[i]

            if fmt == 'iwrite':
                # Self-describing display message block:
                # First word is a self-referencing byte count → emit as label arithmetic.
                # Remaining bytes use auto heuristics (CurXY, FCC, FCS, etc.)
                if i == start:
                    end_lbl = self.labels.get(end, f'${end:04X}')
                    start_lbl = self.labels.get(start, f'${start:04X}')
                    out.append(f"         FDB    {end_lbl}-{start_lbl}"
                               f"   ; # bytes this message")
                    i += 2
                    last_printable = False; continue
                # Body — fall through to auto heuristics below
                fmt = 'auto'

            if fmt == 'fdb':
                if i+1 < end:
                    v = (d[i]<<8)|d[i+1]
                    out.append(f"         FDB    ${v:04X}")
                    i += 2
                else:
                    # Odd byte at end of fdb region -- emit as FCB
                    out.append(f"         FCB    ${d[i]:02X}")
                    i += 1
                last_printable = False; continue

            if fmt == 'raw':
                out.append(f"         FCB    ${b:02X}")
                i += 1; last_printable = False; continue

            # ── auto heuristics ───────────────────────────────────────
            # CRLF (only after printable)
            if b==0x0D and i+1<end and d[i+1]==0x0A and last_printable:
                out.append("         FDB    $0D0A             ; CRLF")
                i += 2; last_printable = False; continue

            # ESC windowing
            if b==0x1B and i+1<end and d[i+1] in WIN_ESC:
                lines, consumed = self._emit_win_esc(i, end)
                out.extend(lines); i += consumed; last_printable = False; continue

            # OS-9 CurXY
            if b==0x02 and i+2<end:
                rb2=d[i+1]; cb2=d[i+2]
                row=rb2-0x20; col=cb2-0x20
                out.append(f"         FCB    CurXY,${rb2:02X},${cb2:02X}     ; CurXY(row={row},col={col})")
                i += 3; last_printable = False; continue

            # Control byte
            if b < 0x20:
                j = i
                while j < end and d[j]==b and j-i<12: j += 1
                nm  = {0x00:'NUL',0x07:'BEL',0x08:'BS',0x0A:'LF',
                       0x0C:'FF',0x0D:'CR',0x1A:'SUB'}.get(b, f'${b:02X}')
                desc= SCF_CTRL.get(b, f'${b:02X}')
                run = j - i
                if run >= 3:
                    for k in range(0, run, 6):
                        g = min(6, run-k)
                        out.append(f"         FCB    {','.join([nm]*g)}  ; {nm}×{g}")
                else:
                    for _ in range(run):
                        out.append(f"         FCB    ${b:02X}               ; {desc}")
                i = j; last_printable = False; continue

            # Printable run → FCC (minimum 2 chars; single printable → FCB)
            # Also absorb a trailing hi-bit byte to form FCS if it extends
            # the run to at least 2 characters total.
            j = i; s = []
            while j < end and 0x20 <= d[j] < 0x7F:
                if d[j]==0x0D and j+1<end and d[j+1]==0x0A: break
                s.append(chr(d[j])); j += 1
            # Check for hi-bit terminator extending the run
            if j < end and d[j]&0x80 and 0x20 <= (d[j]&0x7F) < 0x7F:
                hi_ch = chr(d[j]&0x7F)
                if len(s) >= 2:   # minimum 2 plain + 1 hi-bit = 3 bytes total
                    # Emit entire string as single FCS (plain chars + hi-bit terminator)
                    txt = ''.join(s) + hi_ch
                    for k in range(0, len(txt), 72):
                        out.append(f"         FCS    \"{txt[k:k+72]}\"")
                    last_printable = True; i = j+1; continue
                # else fall through — hi-bit byte treated as FCB below
            if len(s) >= 2:
                txt = ''.join(s)
                for k in range(0, len(txt), 72):
                    out.append(f"         FCC    \"{txt[k:k+72]}\"")
                last_printable = True; i = j; continue
            elif len(s) == 1:
                # Single printable char — emit as FCB with its character shown
                b2 = d[i]
                out.append(f"         FCB    ${b2:02X}               ; \'{chr(b2)}\'")
                last_printable = True; i += 1; continue

            out.append(f"         FCB    ${b:02X}")
            last_printable = False; i += 1

        return out

    # ── Pass 2: render ────────────────────────────────────────────────────

    def render(self) -> str:
        """
        Span-based output walk.
        Returns complete annotated ASM as a string.
        """
        proj     = self.project
        d        = self.data
        hdr      = self.hdr
        lbs      = self.labels
        reg      = self.regions
        exec_off = self.exec_off
        crc_off  = self.crc_off
        mod_size = hdr['mod_size']
        name     = hdr['mod_name']
        out      = []
        footnote_used   = {}   # addr -> footnote_number
        footnote_detail = {}   # footnote_number -> [detail lines]

        # ── Pre-scan: register containing-instruction labels for forced_equs ──
        # Ensures the containing instruction gets an Insn_XXXX label so it
        # appears in code_pts and gets rendered. Without this, the bytes of
        # the containing instruction would fall in a gap.
        # Skip cases where the containing instruction start is itself inside
        # another rendered instruction (cascading overlap).
        for addr in proj.forced_equs:
            if addr >= exec_off and addr < crc_off:
                for istart, iend in sorted(self.insn_spans.items()):
                    if istart < addr <= iend:
                        # Only label if istart is not strictly inside another span
                        is_nested = any(
                            s < istart < e
                            for s, e in self.insn_spans.items()
                            if s != istart
                        )
                        if not is_nested and not lbs.get(istart):
                            lbs[istart] = f"Insn_{istart:04X}"
                        break

        # ── Pre-scan: find ??? bytes that are branch targets and register
        # containing-instruction labels BEFORE render walks forward ──────
        # Build set of addresses inside declared data_regions (skip those)
        data_region_addrs = set()
        for r in proj.data_regions:
            for a2 in range(r['start'], r['end']):
                data_region_addrs.add(a2)

        for addr, lbl in list(lbs.items()):
            if addr >= exec_off and addr < crc_off:
                if addr in data_region_addrs:
                    continue  # skip addresses inside declared data regions
                byte_at = d[addr]
                # Check if this address decodes as ??? (undefined opcode)
                try:
                    mn_test, _, _, _, _ = self.decode_one(addr)
                except Exception:
                    mn_test = '???'
                if mn_test == '???':
                    # Find containing instruction
                    for istart, iend in sorted(self.insn_spans.items()):
                        if istart < addr <= iend:
                            if not lbs.get(istart):
                                cont_lbl = f"Insn_{istart:04X}"
                                lbs[istart] = cont_lbl
                            break

        # ── File header ───────────────────────────────────────────────
        out.append(EQUATES_BLOCK)
        if proj.custom_equates:
            out.append("; ── Project-specific equates ──")
            out.extend(proj.custom_equates)
            out.append("")

        if proj.bss:
            out.append("; ── BSS Variable Equates ─────────────────────────────────────")
            for off in sorted(proj.bss.keys()):
                name_str = proj.bss[off]
                out.append(f"{name_str:<14}EQU    {off:<9}; BSS offset ${off:04X}")
            out.append("")

        out += [
            f"; {'='*62}",
            f"; Disassembly:  {proj.binary or os.path.basename('')}",
            f"; Module:       {name}",
            f"; Type:         {hdr['type_name']}  (${hdr['mod_type']:02X})",
            f"; Size:         ${mod_size:04X}  ({mod_size} bytes)",
            f"; Entry:        ${exec_off:04X}",
            f"; BSS:          ${hdr['bss_size']:04X}  ({hdr['bss_size']} bytes)",
            f"; CRC-24:       {('$%06X' % hdr['crc']) if hdr['crc'] else 'N/A'}",
        ]
        if proj.module_notes:
            out.append(";")
            for note in proj.module_notes:
                out.append(f"; {note}")
        if self.found_6309:
            out += [
                ";",
                "; ── PROCESSOR: Motorola 6309 required ──────────────────────────",
                "; This module uses 6309-specific instructions and registers.",
                "; It will NOT run on a stock CoCo 3 with a 6809 processor.",
                "; ────────────────────────────────────────────────────────────────",
            ]
        out += [
            f"; {'='*62}",
            "",
            "; ----- Module Header -----",
            "ModHeader",
            "         FDB    $87CD             ; OS-9 module sync bytes",
            "         FDB    ModEnd+3-$0000    ; module size (content + 3 CRC bytes)",
            "         FDB    ModName           ; name offset",
            f"         FCB    ${hdr['mod_type']:02X}               ; type: {hdr['type_name']}",
            f"         FCB    ${hdr['lang']:02X}               ; language",
            f"         FCB    ${hdr['attr']:02X}               ; attributes/parity",
            "         FDB    Init              ; execution entry",
            f"         FDB    ${hdr['bss_size']:04X}             ; BSS size",
            "",
            "; ----- Module Name -----",
            "ModName",
            f"         FCS    \"{name}\"",
            "",
        ]

        # ── Pre-exec data region ──────────────────────────────────────
        if exec_off > 0x13:
            out += [
                f"; {'='*62}",
                f"; Pre-exec data  (post-name)—${exec_off-1:04X}",
                f"; Everything here is DATA — no executable code.",
                f"; {'='*62}",
                "",
            ]
            # Start after the module name (name_off + len(name)), not at $0013
            # to avoid re-emitting the tail bytes of the hi-bit terminated name.
            name_data_start = self.hdr['name_off']
            # Advance past the hi-bit terminated name
            i = name_data_start
            while i < exec_off:
                b = self.data[i]; i += 1
                if b & 0x80: break
            pre_data_start = i  # first byte after module name
            pre_sub = sorted(
                [(a,l) for a,l in lbs.items() if pre_data_start <= a < exec_off])
            # Emit pre-exec data with xref comments before each labeled address.
            # Unlabeled bytes between labels are included in each labeled block.
            if not pre_sub:
                out.extend(self.emit_data(pre_data_start, exec_off, {}))
            else:
                # Emit any unlabeled bytes before first label
                first_lbl_addr = pre_sub[0][0]
                if first_lbl_addr > pre_data_start:
                    out.extend(self.emit_data(pre_data_start, first_lbl_addr, {}))
                # Build pre-exec format override map from data_regions
                pre_fmt_map = {}  # addr -> fmt string for sub-regions
                for r in proj.data_regions:
                    if r['start'] < exec_off:
                        pre_fmt_map[r['start']] = (r['end'], r.get('format','auto'),
                                                    r.get('comment',''))

                # Emit each labeled block with its xref comment
                for pi, (paddr, plbl) in enumerate(pre_sub):
                    pend = pre_sub[pi+1][0] if pi+1 < len(pre_sub) else exec_off
                    callers = self.xrefs.get(paddr, [])
                    out.append("")
                    out.append(f"{plbl}")
                    if callers:
                        caller_strs = []
                        for ca in sorted(callers):
                            cl = lbs.get(ca, f'${ca:04X}')
                            caller_strs.append(cl)
                        out.append(f"; Referenced by: {', '.join(caller_strs)}")
                    sub = {k:v for k,v in dict(pre_sub).items() if paddr < k < pend}
                    # Check if any sub-region within this span has a format override
                    cur = paddr
                    while cur < pend:
                        if cur in pre_fmt_map:
                            rend, rfmt, rcmt = pre_fmt_map[cur]
                            rend = min(rend, pend)
                            if cur > paddr:
                                out.extend(self.emit_data(paddr, cur, 
                                    {k:v for k,v in sub.items() if paddr <= k < cur}))
                            if rcmt:
                                out.append(f"; {rcmt}")
                            out.extend(self.emit_data(cur, rend,
                                {k:v for k,v in sub.items() if cur <= k < rend}, rfmt))
                            cur = rend
                            paddr = cur  # update start for remainder
                        else:
                            cur += 1
                    if paddr < pend:
                        _is_iwrite = (
                            paddr in self.data_hints
                            and self.data_hints[paddr].get('syscall') == 'I$Write'
                            and paddr + 1 < len(self.data)
                            and ((self.data[paddr]<<8)|self.data[paddr+1]) == (pend - paddr)
                        )
                        _pfmt = 'iwrite' if _is_iwrite else 'auto'
                        out.extend(self.emit_data(paddr, pend,
                            {k:v for k,v in sub.items() if paddr <= k < pend}, _pfmt))
            out.append("")

        # ── Code section: span-based walk ────────────────────────────
        out += [
            f"; {'='*62}",
            f"; Code section  ${exec_off:04X}—${crc_off-1:04X}  ({crc_off-exec_off} bytes)",
            f"; {'='*62}",
            "",
        ]

        # Build project data region map for span lookup
        proj_data = {}
        for r in proj.data_regions:
            proj_data[r['start']] = r

        # Ensure data_region starts have labels in lbs
        for r in proj.data_regions:
            rs = r['start']
            if exec_off <= rs < crc_off and rs not in lbs:
                lbl = r.get('label', '') or f'Dat_{rs:04X}'
                lbs[rs] = lbl
            # Also ensure KIND_DATA for data_region starts
            if rs not in reg:
                reg[rs] = KIND_DATA

        # Sorted label points in code section
        code_pts = sorted(
            [(a, lbs[a], reg.get(a, KIND_CODE))
             for a in lbs if exec_off <= a < crc_off]
        )
        code_pts.append((crc_off, 'ModEnd', KIND_CODE))

        prev_ret = False

        for i, (span_start, span_lbl, span_kind) in enumerate(code_pts[:-1]):
            span_end = code_pts[i+1][0]
            if span_start >= crc_off: break

            # block comment before this address
            for bcline in proj.block_comments.get(span_start, []):
                out.append(f"; {bcline}")

            # separator after return
            if span_lbl and prev_ret:
                out.append(""); out.append(f"; {'-'*62}")

            # ── DATA span ─────────────────────────────────────────────
            if span_kind == KIND_DATA:
                # Find applicable data_region (exact match or parent region)
                proj_r = proj_data.get(span_start, {})
                is_parent_region_start = bool(proj_r)
                if not proj_r:
                    for r in proj.data_regions:
                        if r['start'] <= span_start < r['end']:
                            proj_r = r
                            break

                fmt = proj_r.get('format', 'auto')
                # Apply syscall-derived format hint if no explicit project format
                if fmt == 'auto' and span_start in self.data_hints:
                    hint = self.data_hints[span_start]
                    if (hint.get('syscall') == 'I$Write'
                            and span_start + 1 < len(self.data)
                            and ((self.data[span_start]<<8)|self.data[span_start+1])
                                == (proj_r.get('end', span_start) - span_start)):
                        fmt = 'iwrite'

                # For fdb/raw regions: if this is the START of the declared region,
                # render the ENTIRE region at once to avoid sub-span alignment issues.
                # Sub-labels within the region are passed as 'sub' to emit_data.
                if is_parent_region_start and fmt in ('fdb', 'raw'):
                    region_end = proj_r['end']
                    out.append(""); out.append(f"{span_lbl}")
                    callers = self.xrefs.get(span_start, [])
                    if callers:
                        caller_strs = [lbs.get(ca, f'${ca:04X}') for ca in sorted(callers)]
                        out.append(f"; Referenced by: {', '.join(caller_strs)}")
                    if proj_r.get('comment'):
                        out.append(f"; {proj_r['comment']}")
                    out.append(f"; ── {region_end-span_start} bytes"
                               f"  (${span_start:04X}—${region_end-1:04X}) ──")
                    sub = {k:v for k,v in lbs.items()
                           if span_start < k < region_end}
                    out.extend(self.emit_data(span_start, region_end, sub, fmt))
                    prev_ret = False
                    # Skip all code_pts that fall within this region
                    # (handled by the outer loop's span_start check below)
                    # We use a flag to skip sub-spans
                    _skip_until = region_end
                    # We can't break the outer loop easily, so we'll track via span_start
                    continue

                # Check if this span is INSIDE an already-rendered parent region
                # (i.e., it's a sub-span of an fdb/raw region we already rendered above)
                inside_parent = False
                if not is_parent_region_start:
                    for r in proj.data_regions:
                        if (r['format'] in ('fdb', 'raw') and
                                r['start'] < span_start < r['end']):
                            inside_parent = True
                            break
                if inside_parent:
                    # Already rendered as part of parent region -- skip
                    prev_ret = False
                    continue

                out.append(""); out.append(f"{span_lbl}")
                callers = self.xrefs.get(span_start, [])
                if callers:
                    caller_strs = [lbs.get(ca, f'${ca:04X}') for ca in sorted(callers)]
                    out.append(f"; Referenced by: {', '.join(caller_strs)}")
                if proj_r.get('comment') and span_start == proj_r.get('start'):
                    out.append(f"; {proj_r['comment']}")
                out.append(f"; ── {span_end-span_start} bytes"
                           f"  (${span_start:04X}—${span_end-1:04X}) ──")
                sub = {k:v for k,v in lbs.items()
                       if span_start < k < span_end}
                # Apply syscall hint if no project format override
                span_fmt = fmt if fmt != 'auto' else (
                    'iwrite' if (
                        span_start in self.data_hints
                        and self.data_hints[span_start].get('syscall') == 'I$Write'
                        and span_start + 1 < len(self.data)
                        and ((self.data[span_start]<<8)|self.data[span_start+1]) == (span_end - span_start)
                    ) else 'auto')
                out.extend(self.emit_data(span_start, span_end, sub, span_fmt))
                prev_ret = False
                continue

            # ── CODE span ─────────────────────────────────────────────
            # Skip code spans that fall inside a declared fdb/raw data_region
            in_data_region = False
            for r in proj.data_regions:
                if r.get('format') in ('fdb','raw') and r['start'] <= span_start < r['end']:
                    in_data_region = True
                    break
            if in_data_region:
                prev_ret = False
                continue

            # (auto-detect of mid-instruction labels removed - handled by forced_equs)

            pos = span_start
            first = True

            while pos < span_end:
                lbl_here = lbs.get(pos, '')

                if lbl_here and not first:
                    if prev_ret: out.append(""); out.append(f"; {'-'*62}")
                    out.append("")

                first = False

                # block comment
                for bcline in proj.block_comments.get(pos, []):
                    out.append(f"; {bcline}")

                # Check if this address is a forced EQU (mid-instruction overlap)
                if pos in proj.forced_equs:
                    equ_comment = proj.forced_equs[pos]
                    byte_val = d[pos]
                    hx_forced = f"{byte_val:02X}"
                    # Find containing instruction
                    cont_lbl_f = None
                    offset_f = 0
                    for istart, iend in sorted(self.insn_spans.items()):
                        if istart < pos <= iend:
                            cont_lbl_f = lbs.get(istart, f"Insn_{istart:04X}")
                            offset_f = pos - istart
                            break
                    lbl_here_f = lbs.get(pos, '')
                    ls_f = f"{lbl_here_f}:" if lbl_here_f else ''
                    # Use direct address constant -- avoids lwasm forward-reference
                    # issues with label+N arithmetic (e.g. Insn_0B8C+1 can cause
                    # lwasm to emit an extra byte in the full build).
                    equ_expr_f = f"${pos:04X}"
                    if cont_lbl_f:
                        equ_comment_full = f"{cont_lbl_f}+{offset_f} -- {equ_comment}"
                    else:
                        equ_comment_full = equ_comment
                    out.append(f"${pos:04X}  {hx_forced:<18s}  {ls_f:<14s}"
                               f" EQU    {equ_expr_f:<16s}"
                               f" ; mid-instruction overlap: {equ_comment_full}")
                    # Advance pos to end of containing instruction.
                    # The containing instruction already emits all its bytes --
                    # we just skip past them to avoid double-decoding.
                    if cont_lbl_f:
                        cont_start_f = next((s for s,e2 in self.insn_spans.items() 
                                            if s < pos and e2 > pos), None)
                        if cont_start_f is not None:
                            pos = self.insn_spans[cont_start_f]
                        else:
                            pos += 1
                    else:
                        pos += 1
                    prev_ret = False
                    continue

                try:
                    mn, op_str, cm, raw, pos2 = self.decode_one(pos)
                except (IndexError, Exception) as e:
                    out.append(f"${pos:04X}  {d[pos]:02X}               ; decode error: {e}")
                    pos += 1; continue

                # project line comment overrides / augments engine comment
                proj_cm = proj.line_comments.get(pos, '')
                if proj_cm:
                    cm = proj_cm if not cm else f"{cm}  [{proj_cm}]"

                hx  = ' '.join(f'{b:02X}' for b in raw)
                ls  = f"{lbl_here}:" if lbl_here else ''
                ins = f"{mn} {op_str}".strip()
                cmt = f" ; {cm}" if cm else ''
                out.append(f"${pos:04X}  {hx:<18s}  {ls:<14s} {ins:<22s}{cmt}")

                # ── Undefined/illegal opcode: EQU offset from containing instruction ──
                # The byte falls inside the operand of the preceding instruction.
                # We emit an EQU pointing into that instruction using label+offset,
                # so branches to this address assemble with the correct target
                # and NO extra byte is generated. Binary will match original.
                if mn == '???':
                    byte_val = raw[0]

                    # Only apply EQU treatment if this byte is a branch target (has a label)
                    if not lbl_here:
                        # Not a branch target -- just emit as FCB with warning comment
                        out[-1] = (f"${pos:04X}  {hx:<18s}  {ls:<14s}"
                                   f" FCB    ${byte_val:02X}               "
                                   f" ; undefined opcode ${byte_val:02X} -- not a valid 6809 instruction")
                        pos = pos2
                        continue

                    # Auto-assign footnote number
                    used_nums = set(footnote_used.values())
                    next_num = 1
                    while next_num in used_nums:
                        next_num += 1
                    footnote_used[pos] = next_num
                    fn_num = next_num

                    # Find the containing instruction by scanning insn_spans backwards
                    containing_start = None
                    containing_end   = None
                    for istart, iend in sorted(self.insn_spans.items()):
                        if istart < pos <= iend:
                            containing_start = istart
                            containing_end   = iend
                            # do not break — take the last match
                    
                    if containing_start is not None:
                        offset_into = pos - containing_start
                        # Get or create a label for the containing instruction
                        cont_lbl = lbs.get(containing_start)
                        if not cont_lbl:
                            # Generate a label for the containing instruction
                            cont_lbl = f"Insn_{containing_start:04X}"
                            lbs[containing_start] = cont_lbl
                        # Use direct address -- avoids lwasm label+N arithmetic issues
                        equ_expr = f"${pos:04X}"
                        equ_expr_full = f"{cont_lbl}+{offset_into}"
                        inline_txt = (f"branch target {offset_into} byte(s) inside "
                                      f"{cont_lbl} -- see [*{fn_num}]")
                        # Replace the rendered instruction line with EQU form
                        out[-1] = (f"${pos:04X}  {hx:<18s}  {ls:<14s}"
                                   f" EQU    {equ_expr:<16s}"
                                   f" ; [*{fn_num}] {inline_txt}")
                        equ_label = lbl_here  # e.g. Sub_0C57
                        detail_extra = [
                            f"The EQU expression '{equ_label} EQU {equ_expr_full}' resolves",
                            f"to ${pos:04X} at assembly time. Branches to {equ_label}",
                            f"will target the correct address and the assembled binary",
                            f"WILL match the original at those branch sites.",
                        ]
                    else:
                        # Fallback: no containing instruction found
                        equ_expr = f"${pos:04X}"
                        inline_txt = f"undefined opcode at ${pos:04X} — see [*{fn_num}]"
                        out[-1] = (f"${pos:04X}  {hx:<18s}  {ls:<14s}"
                                   f" EQU    {equ_expr:<16s}"
                                   f" ; [*{fn_num}] {inline_txt}")
                        detail_extra = []

                    # Build footnote detail
                    proj_fn = proj.footnotes.get(fn_num, {})
                    detail = proj_fn.get('detail', [
                        f"${pos:04X} is referenced as a branch target but falls",
                        f"inside the operand of a preceding instruction ({cont_lbl if containing_start else 'unknown'}).",
                        f"Byte ${byte_val:02X} at ${pos:04X} is not a valid 6809 opcode.",
                        f"",
                        f"On 6809 / 6309-emulation mode: ${byte_val:02X} is a harmless undefined",
                        f"opcode — execution falls through to the next instruction.",
                        f"On 6309 native mode: ${byte_val:02X} may be interpreted as a 6309",
                        f"instruction consuming subsequent bytes — UNPREDICTABLE RESULTS.",
                        f"",
                    ] + detail_extra + [
                        f"",
                        f"Probable cause: the branch target address is off by one byte",
                        f"(a bug in the original code, or a deliberate overlapping-code trick).",
                    ])
                    footnote_detail[fn_num] = detail

                is_ret = (mn in ('RTS','RTI','LBRA','BRA') or
                          (mn=='PULS' and 'PC' in op_str) or
                          (mn=='PULU' and 'PC' in op_str))
                prev_ret = is_ret and not lbl_here
                pos = pos2

                if is_ret and pos < span_end:
                    nxt = min((a for a in lbs if pos<=a<span_end), default=span_end)
                    if nxt > pos:
                        pad = d[pos:nxt]
                        if pad:
                            args = ','.join(f'${b:02X}' for b in pad)
                            out.append(f"         FCB    {args}  ; unreachable padding")
                        pos = nxt; prev_ret = False

        out += [
            "",
            f"; {'='*62}",
            "; ModEnd — CRC-24 appended by fixmod (not in source)",
            f"; {'='*62}",
            "ModEnd",
            "ModSize  EQU    ModEnd+3-$0000    ; includes 3 CRC bytes"
        ]

        # ── Analyst footnotes ──────────────────────────────────────────────
        if footnote_detail:
            out += ["", f"; {'═'*62}", "; ANALYST NOTES", f"; {'═'*62}"]
            for fn_num in sorted(footnote_detail.keys()):
                out.append("")
                out.append(f"; [*{fn_num}] UNRESOLVABLE DISASSEMBLY CONDITION")
                out.append(f"; {'─'*62}")
                for line in footnote_detail[fn_num]:
                    out.append(f";      {line}" if line else ";")
            out += ["", f"; {'═'*62}"]

        return '\n'.join(out)

    def run(self):
        """Execute both passes."""
        self._cpu = self.project.cpu  # make cpu available to decode_one
        self.pass1()
        # render() is called separately



# ============================================================================
# 6309 Extension — Hitachi HD6309 additional instructions
# ============================================================================
# The 6309 is a strict superset of the 6809.  Every 6809 instruction is
# valid and identical on the 6309.  The 6309 adds:
#
#   New registers:
#     E, F   — 8-bit halves of W (W = E:F, 16-bit)
#     W      — 16-bit (E:F)
#     Q      — 32-bit (D:W = A:B:E:F)
#     V      — 16-bit index/scratch register
#     MD     — mode register (bit0 = native mode, bit1 = divide-by-zero trap)
#
#   New opcodes occupy previously-illegal slots:
#     $10 prefix: ADDR, ADCR, SUBR, SBCR, ANDR, ORR, EORR, CMPR (reg-reg)
#                 TFM  (block transfer: R+,R+  R-,R-  R+,R  R,R+)
#                 BITMD, LDMD
#     $11 prefix: BAND, BIAND, BOR, BIOR, BEOR, BIEOR, BLDX, BSTX (bit ops)
#                 MULD, DIVD, DIVQ
#     Direct page new: AIM, OIM, EIM, TIM (AND/OR/EOR/TST immediate-to-mem)
#     Inherent new: SEXW, PSHSW, PULSW, PSHUIW, PULUIW
#
# Native mode (LDMD #1) enables 6309-specific timing and some behavioral
# changes but does NOT change instruction encoding for 6809 instructions.
#
# COEXISTENCE: The engine detects 6309 instructions by cpu flag in the
# project.  On 6809 mode (default) these opcodes emit as '???'.
# On 6309 mode they decode to named mnemonics.
# ============================================================================

# 6309 register encoding for inter-register ops (TFR/EXG extension)
REG6309 = {
    0x00:'D', 0x01:'X', 0x02:'Y', 0x03:'U', 0x04:'S', 0x05:'PC',
    0x06:'W', 0x07:'V',
    0x08:'A', 0x09:'B', 0x0A:'CC', 0x0B:'DP', 0x0C:'0', 0x0D:'0',
    0x0E:'E', 0x0F:'F',
}

# TFM postbyte: source/dest register pair
TFM_REGS = {0:'D', 1:'X', 2:'Y', 3:'U', 4:'S'}
TFM_MODES = {
    0: ('+','+'),   # R+,R+
    1: ('-','-'),   # R-,R-
    2: ('+',''),    # R+,R
    3: ('','+'),    # R,R+
}


def decode_6309(data, pos, labels=None, bss_names=None):
    """
    Attempt to decode a 6309-specific instruction at pos.
    Called when the standard decoder would emit '???'.
    Returns (mnemonic, operand, comment, raw_bytes, new_pos)
    or None if not a recognized 6309 instruction.
    """
    d = data
    op = d[pos]; start = pos; pos += 1
    mn = '???'; op_str = ''; cm = ''

    def rb(): 
        nonlocal pos; v=d[pos]; pos+=1; return v
    def rw(): 
        nonlocal pos; v=(d[pos]<<8)|d[pos+1]; pos+=2; return v

    # ── Inherent 6309-only ops ─────────────────────────────────────────────
    if op == 0x14: mn='SEXW';   cm='sign-extend W (16-bit) into Q (32-bit)'
    elif op == 0x1E:
        # On 6809: EXG. On 6309: extended EXG supports W,V,E,F registers
        pb=rb(); s=REG6309.get((pb>>4)&0xF,'?'); d2=REG6309.get(pb&0xF,'?')
        mn='EXG'; op_str=f'{s},{d2}'
    elif op == 0x1F:
        pb=rb(); s=REG6309.get((pb>>4)&0xF,'?'); d2=REG6309.get(pb&0xF,'?')
        mn='TFR'; op_str=f'{s},{d2}'

    # ── Direct-page bit ops: AIM/OIM/EIM/TIM ──────────────────────────────
    # Format: opcode  imm  dp_addr
    elif op == 0x02: v=rb(); a=rb(); mn='AIM'; op_str=f'#${v:02X},<${a:02X}'; cm='AND immediate to direct'
    elif op == 0x05: v=rb(); a=rb(); mn='EIM'; op_str=f'#${v:02X},<${a:02X}'; cm='EOR immediate to direct'
    elif op == 0x0B: v=rb(); a=rb(); mn='TIM'; op_str=f'#${v:02X},<${a:02X}'; cm='TST immediate to direct'
    elif op == 0x01: v=rb(); a=rb(); mn='OIM'; op_str=f'#${v:02X},<${a:02X}'; cm='OR  immediate to direct'

    # ── $10 page — 6309 additions ─────────────────────────────────────────
    elif op == 0x10:
        op2 = rb()

        # Register-to-register arithmetic
        REG_REG = {
            0x30:'ADDR', 0x31:'ADCR', 0x32:'SUBR', 0x33:'SBCR',
            0x34:'ANDR', 0x35:'ORR',  0x36:'EORR', 0x37:'CMPR',
        }
        if op2 in REG_REG:
            pb=rb(); s=REG6309.get((pb>>4)&0xF,'?'); d2=REG6309.get(pb&0xF,'?')
            mn=REG_REG[op2]; op_str=f'{s},{d2}'; cm='register-to-register'

        # TFM — block transfer
        elif op2 == 0x38:
            pb=rb()
            src=TFM_REGS.get((pb>>4)&0xF,'?'); dst=TFM_REGS.get(pb&0xF,'?')
            sm,dm=TFM_MODES[0]; mn='TFM'; op_str=f'{src}{sm},{dst}{dm}'
            cm='block transfer R+,R+'
        elif op2 == 0x39:
            pb=rb()
            src=TFM_REGS.get((pb>>4)&0xF,'?'); dst=TFM_REGS.get(pb&0xF,'?')
            mn='TFM'; op_str=f'{src}-,{dst}-'; cm='block transfer R-,R-'
        elif op2 == 0x3A:
            pb=rb()
            src=TFM_REGS.get((pb>>4)&0xF,'?'); dst=TFM_REGS.get(pb&0xF,'?')
            mn='TFM'; op_str=f'{src}+,{dst}'; cm='block transfer R+,R'
        elif op2 == 0x3B:
            pb=rb()
            src=TFM_REGS.get((pb>>4)&0xF,'?'); dst=TFM_REGS.get(pb&0xF,'?')
            mn='TFM'; op_str=f'{src},{dst}+'; cm='block transfer R,R+'

        # BITMD / LDMD
        elif op2 == 0x3C: v=rb(); mn='BITMD'; op_str=f'#${v:02X}'; cm='test MD register bits'
        elif op2 == 0x3D:
            v=rb(); mn='LDMD'; op_str=f'#${v:02X}'
            cm='load mode: bit0=native bit1=div-trap'
            if v & 0x01: cm += ' [NATIVE MODE ON]'
        # W register loads/stores — extended forms
        elif op2 == 0x80: v=rw(); mn='SUBW';  op_str=f'#${v:04X}'
        elif op2 == 0x81: v=rw(); mn='CMPW';  op_str=f'#${v:04X}'
        elif op2 == 0x82: v=rw(); mn='SBCD';  op_str=f'#${v:04X}'
        elif op2 == 0x84: v=rw(); mn='ANDW';  op_str=f'#${v:04X}'  # ANDD
        elif op2 == 0x85: v=rw(); mn='BITD';  op_str=f'#${v:04X}'
        elif op2 == 0x86: v=rw(); mn='LDW';   op_str=f'#${v:04X}'
        elif op2 == 0x88: v=rw(); mn='EORW';  op_str=f'#${v:04X}'  # EORD
        elif op2 == 0x89: v=rw(); mn='ADCW';  op_str=f'#${v:04X}'  # ADCD
        elif op2 == 0x8A: v=rw(); mn='ORW';   op_str=f'#${v:04X}'  # ORD
        elif op2 == 0x8B: v=rw(); mn='ADDW';  op_str=f'#${v:04X}'
        elif op2 == 0xC6: v=rb(); mn='LDE';   op_str=f'#${v:02X}'; cm='E = imm'
        elif op2 == 0xD6: v=rb(); mn='LDE';   op_str=f'<${v:02X}'
        elif op2 == 0x86: v=rw(); mn='LDW';   op_str=f'#${v:04X}'; cm='W = imm'

        # Stack ops for W
        elif op2 == 0x38 and False: pass  # handled above
        elif op2 == 0x3C: pass  # handled above

        # PSHSW / PULSW / PSHUIW / PULUIW
        else:
            pos = start + 1  # reset — not a 6309 op we know
            return None

    # ── $11 page — 6309 additions ─────────────────────────────────────────
    elif op == 0x11:
        op2 = rb()

        # MULD / DIVD / DIVQ
        if op2 == 0x8F: v=rw(); mn='MULD'; op_str=f'#${v:04X}'; cm='Q = D × operand (32-bit result)'
        elif op2 == 0x9F: v=rb(); mn='MULD'; op_str=f'<${v:02X}'
        elif op2 == 0x88: v=rb(); mn='DIVD'; op_str=f'#${v:02X}'; cm='D = D ÷ imm8; remainder in B'
        elif op2 == 0x98: v=rb(); mn='DIVD'; op_str=f'<${v:02X}'
        elif op2 == 0x8B: v=rw(); mn='DIVQ'; op_str=f'#${v:04X}'; cm='W:D = Q ÷ imm16'
        elif op2 == 0x9B: v=rb(); mn='DIVQ'; op_str=f'<${v:02X}'

        # Bit transfer ops: BAND BIAND BOR BIOR BEOR BIEOR BLDX BSTX
        # Format: opcode  postbyte(dst_reg:dst_bit:src_bit)  dp_addr
        elif op2 in (0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39):
            names = {0x30:'BAND',0x31:'BIAND',0x32:'BOR',0x33:'BIOR',
                     0x34:'BEOR',0x35:'BIEOR',0x36:'BLDX',0x37:'BSTX'}
            if op2 in names:
                pb=rb(); a=rb()
                dst_reg = {0:'CC',1:'A',2:'B'}  .get((pb>>6)&3,'?')
                dst_bit = (pb>>3)&7
                src_bit =  pb    &7
                mn=names[op2]; op_str=f'{dst_reg},{dst_bit},<${a:02X},{src_bit}'
                cm=f'bit {src_bit} of ${a:02X} → bit {dst_bit} of {dst_reg}'
            else:
                return None
        else:
            pos = start + 1
            return None

    # ── E and F register ops (new direct/extended/indexed forms) ──────────
    # $10 $86 = LDE imm already handled above
    # Some assemblers use different encodings — cover the indexed forms
    elif op == 0x10 and False:
        pass  # handled in the block above

    else:
        return None  # not a 6309 instruction

    raw = bytes(data[start:pos])
    return mn, op_str.strip(), cm, raw, pos

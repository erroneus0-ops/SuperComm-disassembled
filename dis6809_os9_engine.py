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
KIND_SUB  = 'SUB'   # BSR/LBSR/JSR target — subroutine
KIND_LOC  = 'LOC'   # BRA/LBRA/Bcc/LBcc target — branch location

class _OverlapHandled(Exception):
    """Sentinel: mid-instruction overlap was handled, skip normal decode path."""
    pass

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
    0x00:"NUL",0x01:"SOH",0x02:"STX",0x03:"ETX",0x04:"EOT",
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

def crc24(data):
    """Compute OS-9 CRC-24 over a byte sequence. Returns 6-char uppercase hex string."""
    crc = 0xFFFFFF
    for b in data:
        crc ^= (b << 16)
        for _ in range(8):
            crc <<= 1
            if crc & 0x1000000:
                crc ^= 0x800063
    return f'{crc & 0xFFFFFF:06X}'

def binary_crc(path):
    """Compute a unique fingerprint of a binary file for change detection.
    Uses SHA-256 truncated to 16 hex chars — sufficient for mismatch detection."""
    import hashlib
    return hashlib.sha256(open(path, 'rb').read()).hexdigest()[:16].upper()


class Project:
    """
    All binary-specific knowledge for a disassembly project.
    Loaded from a JSON file; editable by hand between runs.
    """

    def __init__(self):
        self.binary       = None      # path to binary file
        self.binary_crc   = None      # CRC-24 hex string of binary at project creation
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
        self.emit_equates = True      # False = suppress built-in EQU block (use external defs)
        self.defs_file    = None      # if set, emit 'use <defs_file>' instead of EQU block
        self.footnotes    = {}        # int -> {inline, detail:[lines]}
        self.patches      = {}        # int_addr -> [bytes_to_insert_before_addr]
        self.forced_equs  = {}        # int_addr -> comment (emit as EQU, not instruction)
        self.substitutions= {}        # int_addr -> {replace_lines, with_lines}
        self.routines     = []        # [{name, start, end}] routine boundaries

    @classmethod
    def from_json(cls, path):
        """Load project from JSON file."""
        p = cls()
        with open(path) as f:
            d = json.load(f)

        p.binary        = d.get('binary', '')
        p.binary_crc    = d.get('binary_crc', None)
        p.cpu           = d.get('cpu', '6809')  # '6809' or '6309'
        p.output        = d.get('output', None)
        p.module_notes  = d.get('module_notes', [])
        p.custom_equates= d.get('custom_equates', [])
        p.emit_equates  = d.get('emit_equates', True)
        p.defs_file     = d.get('defs_file', None)

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
            if 'start' not in r: continue
            fmt = r.get('format', 'auto')
            epl = r.get('entries_per_line', None)
            if epl and fmt in ('fdb', 'hexdump'):
                fmt = f'{fmt}:{epl}'
            p.data_regions.append({
                'start':   int(r['start'], 16),
                'end':     int(r['end'], 16) if 'end' in r else None,
                'end_label': r.get('end_label', False),
                'label':   r.get('label', f"Dat_{r['start']}"),
                'comment': r.get('comment', ''),
                'format':  fmt,
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

        # substitutions: {"HHHH": {replace_lines:[...], with:[...]}}
        p.substitutions = {}
        for k, v in d.get('substitutions', {}).items():
            p.substitutions[int(k, 16)] = {
                'replace_lines': v.get('replace_lines', []),
                'with_lines':    v.get('with', []),
            }

        # routines: [{name, start, end}]
        p.routines = []
        for r in d.get('routines', []):
            p.routines.append({
                'name':  r['name'],
                'start': int(r['start'], 16),
                'end':   int(r['end'],   16),
            })

        return p

    def to_json(self, path):
        """Save project to JSON file."""
        d = {
            'binary':      self.binary,
            'binary_crc':  self.binary_crc,
            'cpu':         self.cpu,
            'output':  self.output,
            'entry':   f'{self.entry:04X}' if self.entry else None,
            'module_notes':   self.module_notes,
            'custom_equates': self.custom_equates,
            'emit_equates':   self.emit_equates,
            'defs_file':      self.defs_file,
            'labels':         {f'{k:04X}': v for k,v in sorted(self.labels.items())},
            'bss':            {str(k): v for k,v in sorted(self.bss.items())},
            'data_regions':   [
                {'start': f'{r["start"]:04X}', 'end': f'{r["end"]:04X}',
                 'label': r['label'], 'comment': r['comment'],
                 'format': r.get('format','auto'),
                 'end_label': r.get('end_label', False)}
                for r in self.data_regions
            ],
            'line_comments':  {f'{k:04X}': v
                               for k,v in sorted(self.line_comments.items())},
            'block_comments': {f'{k:04X}': v
                               for k,v in sorted(self.block_comments.items())},
            'substitutions':  {f'{k:04X}': {'replace_lines': v['replace_lines'],
                                             'with': v['with_lines']}
                               for k,v in sorted(self.substitutions.items())},
            'routines':       [{'name': r['name'],
                                'start': f'{r["start"]:04X}',
                                'end':   f'{r["end"]:04X}'}
                               for r in self.routines],
            'footnotes':      {str(k): v
                               for k,v in sorted(self.footnotes.items())
                               if hasattr(self, 'footnotes')},
            'forced_equs':    {f'{k:04X}': v
                               for k,v in sorted(self.forced_equs.items())},
            'patches':        {f'{k:04X}': {'insert': [f'${b:02X}' for b in v['bytes']],
                                            'comment': v.get('comment','')}
                               for k,v in sorted(self.patches.items())},
        }
        with open(path, 'w') as f:
            json.dump(d, f, indent=2)

    @classmethod
    def scaffold(cls, binary_path, output_path=None):
        """Create a minimal project scaffold for a new binary."""
        p = cls()
        p.binary = binary_path
        p.output = output_path or binary_path + '_proj.asm'
        p.module_notes = ["Add notes about this module here."]
        p.cpu = '6809'  # change to '6309' for Hitachi HD6309 binaries
        # Compute and store binary CRC for future mismatch detection
        if os.path.exists(binary_path):
            p.binary_crc = binary_crc(binary_path)
        return p


# ── Engine: generalized disassembler ─────────────────────────────────────────

def _count_data_bytes(lines):
    """Count how many binary bytes a list of FCB/FCC/FDB/FCS assembly lines represent."""
    total = 0
    for line in lines:
        s = line.strip()
        if not s or s.startswith(';'):
            continue
        if ';' in s:
            s = s[:s.index(';')].strip()
        upper = s.upper()
        if upper.startswith('FCB'):
            args = s[3:].strip()
            total += len([a for a in args.split(',') if a.strip()])
        elif upper.startswith('FDB'):
            args = s[3:].strip()
            total += 2 * len([a for a in args.split(',') if a.strip()])
        elif upper.startswith('FCC') or upper.startswith('FCS'):
            m = re.search(r'["\'](.+?)["\']', s)
            if m:
                total += len(m.group(1))
        elif upper.startswith('RMB'):
            try:
                total += int(s[3:].strip())
            except ValueError:
                pass
    return total


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

        # ── Build forced_data from declared data regions (before tracing) ──
        forced_data = set()
        for r in self.project.data_regions:
            if r.get('end') is not None:
                for addr in range(r['start'], r['end']):
                    forced_data.add(addr)

        def add(addr, kind):
            # If a code branch targets a declared data region, ignore it
            if kind in (KIND_CODE, KIND_SUB, KIND_LOC) and addr in forced_data:
                return
            if addr not in refs: refs[addr] = set()
            refs[addr].add(kind)

        # Seed: entry point + any project labels that are code
        add(exec_off, KIND_CODE)
        for addr, name in self.project.labels.items():
            if exec_off <= addr < crc_off:
                # Project labels in code section are assumed subroutines
                add(addr, KIND_SUB)

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

                # ── branches / calls → SUB or LOC ────────────────────
                if op in range(0x20, 0x30):          # short branches
                    off = s8(d[pos]); pos += 1
                    t = pos + off
                    add(t, KIND_SUB if op == 0x8D else KIND_LOC)
                    worklist.append(t)
                    if op == 0x20: stop = True       # BRA unconditional
                elif op == 0x8D:                     # BSR
                    off = s8(d[pos]); pos += 1
                    t = pos + off; add(t, KIND_SUB); worklist.append(t)
                elif op == 0x17:                     # LBSR
                    off = s16((d[pos]<<8)|d[pos+1]); pos += 2
                    t = pos + off; add(t, KIND_SUB); worklist.append(t)
                elif op == 0x16:                     # LBRA
                    off = s16((d[pos]<<8)|d[pos+1]); pos += 2
                    t = pos + off; add(t, KIND_LOC); worklist.append(t)
                    stop = True
                elif op == 0x7E:                     # JMP ext
                    t = (d[pos]<<8)|d[pos+1]; pos += 2
                    add(t, KIND_LOC); worklist.append(t); stop = True
                elif op == 0xBD:                     # JSR ext
                    t = (d[pos]<<8)|d[pos+1]; pos += 2
                    add(t, KIND_SUB); worklist.append(t)
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
                        t = pos + off; add(t, KIND_LOC); worklist.append(t)
                        if op2 == 0x16: stop = True
                    elif op2 == 0x16:  # 6309 LBRA
                        off = s16((d[pos]<<8)|d[pos+1]); pos += 2
                        t = pos + off; add(t, KIND_LOC); worklist.append(t); stop = True
                    elif op2 == 0x17:  # 6309 LBSR
                        off = s16((d[pos]<<8)|d[pos+1]); pos += 2
                        t = pos + off; add(t, KIND_SUB); worklist.append(t)
                    elif op2 == 0x20:  # LBRA variant
                        off = s16((d[pos]<<8)|d[pos+1]); pos += 2
                        t = pos + off; add(t, KIND_LOC); worklist.append(t); stop = True
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
                        if op == 0xAD:   # JSR indexed
                            add(t, KIND_SUB); worklist.append(t)
                        elif op == 0x6E: # JMP indexed
                            add(t, KIND_LOC); worklist.append(t)
                        else:
                            add(t, KIND_DATA)
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
        # forced_data already built before tracing — just force region starts as DATA
        for r in self.project.data_regions:
            add(r['start'], KIND_DATA)

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
                # Forced data region overrides everything
                if addr in forced_data:
                    regions[addr] = KIND_DATA
                    labels[addr]  = f"Dat_{addr:04X}"
                elif KIND_SUB in kinds:
                    # BSR/JSR target — subroutine
                    regions[addr] = KIND_CODE
                    labels[addr]  = f"Sub_{addr:04X}"
                elif KIND_LOC in kinds:
                    # Branch target — location label
                    regions[addr] = KIND_CODE
                    labels[addr]  = f"Loc_{addr:04X}"
                elif KIND_CODE in kinds:
                    # Generic code (entry point, project label, etc.)
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
        n_code = sum(1 for k in regions.values() if k in (KIND_CODE, KIND_SUB, KIND_LOC))
        print(f"; Pass 1: {len(labels)} labels  "
              f"({n_code} code  {n_data} data in code section)",
              file=sys.stderr)

    # ── Pass 2: instruction decoder ───────────────────────────────────────

    def _char_ann(self, v):
        if 32<=v<127: return f"'{chr(v)}'"
        return {0x0D:'CR',0x0A:'LF',0x1B:'ESC',0x00:'NUL',
                0x11:'XON',0x13:'XOFF',
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
                14:'E',15:'F'}

        def dp(v):
            """Format a direct page operand, substituting BSS name if known."""
            bn = self.project.bss.get(v, '')
            return f'<{bn}' if bn else f'<${v:02X}'

        op = rb()

        # ── Page 2 prefix ($10) ───────────────────────────────────────────
        if op == 0x10:
            op2 = rb()
            # Long branches
            LB = {0x16:'LBRA',0x17:'LBSR',0x20:'LBRA',
                  0x21:'LBRN',0x22:'LBHI',0x23:'LBLS',0x24:'LBCC',0x25:'LBCS',
                  0x26:'LBNE',0x27:'LBEQ',0x28:'LBVC',0x29:'LBVS',0x2A:'LBPL',
                  0x2B:'LBMI',0x2C:'LBGE',0x2D:'LBLT',0x2E:'LBGT',0x2F:'LBLE'}
            if op2 in LB:
                l,t = rel16(); mn = LB[op2]; op_str = l
            elif op2 == 0x3F:
                sc=rb(); nm,conv=OS9_SYSCALLS.get(sc,(f'${sc:02X}',''))
                mn='OS9'; op_str=nm; cm=conv
            else:
                # Page 2 table: {op2: (mnemonic, operand_type)}
                P2 = {
                    0x83:('CMPD','imm16'), 0x8C:('CMPY','imm16'), 0x8E:('LDY','imm16'),
                    0xCE:('LDS', 'imm16'),
                    0x93:('CMPD','dir'),   0x9C:('CMPY','dir'),   0x9E:('LDY','dir'),
                    0x9F:('STY', 'dir'),   0xDE:('LDS', 'dir'),   0xDF:('STS','dir'),
                    0xA3:('CMPD','idx'),   0xAC:('CMPY','idx'),   0xAE:('LDY','idx'),
                    0xAF:('STY', 'idx'),   0xEE:('LDS', 'idx'),   0xEF:('STS','idx'),
                    0xB3:('CMPD','ext'),   0xBC:('CMPY','ext'),   0xBE:('LDY','ext'),
                    0xBF:('STY', 'ext'),   0xFE:('LDS', 'ext'),   0xFF:('STS','ext'),
                    # 6309 page 1 register ops
                    0x30:('ADDR','reg2'),  0x31:('ADCR','reg2'),  0x32:('SUBR','reg2'),
                    0x33:('SBCR','reg2'),  0x34:('ANDR','reg2'),  0x35:('ORR', 'reg2'),
                    0x36:('EORR','reg2'),  0x37:('CMPR','reg2'),
                    0x38:('PSHSW','inh'), 0x39:('PULSW','inh'),
                    0x3A:('PSHUW','inh'), 0x3B:('PULUW','inh'),
                    0x3D:('MULD','reg2'), 0x3E:('DIVD','reg2'),  0x3F:('DIVQ','reg2'),
                    # 6309 bit ops and others handled below
                }
                if op2 in P2:
                    mn2, otype = P2[op2]
                    mn = mn2
                    if otype == 'imm16': v=rw(); op_str=f'#${v:04X}'
                    elif otype == 'imm8': v=rb(); op_str=f'#${v:02X}'
                    elif otype == 'dir':  v=rb(); op_str=dp(v)
                    elif otype == 'ext':  v=rw(); op_str=f'${v:04X}'
                    elif otype == 'idx':  op_str=idx()
                    elif otype == 'inh':  pass
                    elif otype == 'reg2':
                        pb=rb(); s2=IREG16.get((pb>>4)&0xF,'?'); d2=IREG16.get(pb&0xF,'?')
                        op_str=f'{s2},{d2}'
                    if any(r in mn for r in ('ADDR','ADCR','SUBR','SBCR','ANDR','ORR','EORR','CMPR',
                                             'PSHSW','PULSW','PSHUW','PULUW','MULD','DIVD','DIVQ')):
                        self.found_6309 = True
                # 6309 bit manipulation / misc
                elif op2 in (0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B):
                    _6309_b = {0x00:'BAND',0x01:'BIAND',0x02:'BOR',0x03:'BIOR',
                               0x04:'BEOR',0x05:'BIEOR',0x06:'LDBT',0x07:'STBT'}
                    if op2 in _6309_b:
                        pb=rb(); v=rb(); v2=rb()
                        mn=_6309_b[op2]; op_str=f'${pb:02X},${v:02X},${v2:02X}'; self.found_6309=True
                    else:
                        _nm={0x08:'PSHSW',0x09:'PULSW',0x0A:'PSHUW',0x0B:'PULUW'}
                        mn=_nm.get(op2,f'10{op2:02X}?'); self.found_6309=True
                elif op2 == 0x3C:
                    v=rb(); mn='BITMD'; op_str=f'#${v:02X}'; cm='6309: test MD register bits'; self.found_6309=True
                elif op2 == 0x3D:
                    v=rb(); mn='LDMD';  op_str=f'#${v:02X}'; cm='6309: load MD register'; self.found_6309=True
                else:
                    mn='FCB'; op_str=f'$10,${op2:02X}'; cm=f'unknown opcode $10{op2:02X}'

        # ── Page 3 prefix ($11) ───────────────────────────────────────────
        elif op == 0x11:
            op2 = rb()
            if op2 == 0x3F:
                sc=rb(); nm,conv=OS9_SYSCALLS.get(sc,(f'${sc:02X}',''))
                mn='OS9'; op_str=nm; cm=conv
            else:
                P3 = {
                    0x83:('CMPU','imm16'), 0x8C:('CMPS','imm16'),
                    0x93:('CMPU','dir'),   0x9C:('CMPS','dir'),
                    0xA3:('CMPU','idx'),   0xAC:('CMPS','idx'),
                    0xB3:('CMPU','ext'),   0xBC:('CMPS','ext'),
                    0x38:('BITMD','imm8'), 0x39:('LDMD','imm8'),
                    # 6309 TFM block moves
                    0x38:('TFM', 'tfm'),  0x39:('TFM', 'tfm'),
                    0x3A:('TFM', 'tfm'),  0x3B:('TFM', 'tfm'),
                }
                if op2 in P3:
                    mn2, otype = P3[op2]
                    mn = mn2
                    if otype == 'imm16': v=rw(); op_str=f'#${v:04X}'
                    elif otype == 'imm8': v=rb(); op_str=f'#${v:02X}'
                    elif otype == 'dir':  v=rb(); op_str=dp(v)
                    elif otype == 'ext':  v=rw(); op_str=f'${v:04X}'
                    elif otype == 'idx':  op_str=idx()
                    elif otype == 'tfm':
                        pb=rb()
                        _tfm_mode={0x38:'+,+',0x39:'-,-',0x3A:'+,0',0x3B:'0,+'}
                        r1=IREG16.get((pb>>4)&0xF,'?'); r2=IREG16.get(pb&0xF,'?')
                        sfx=_tfm_mode.get(op2,'')
                        op_str=f'{r1}{sfx[0]},{r2}{sfx[2]}' if sfx else f'{r1},{r2}'
                        self.found_6309=True
                    if mn in ('BITMD','LDMD','TFM'): self.found_6309=True
                else:
                    mn='FCB'; op_str=f'$11,${op2:02X}'; cm=f'unknown opcode $11{op2:02X}'

        # ── Primary opcode table ──────────────────────────────────────────
        else:
            # Special-cased opcodes (context-sensitive comments, etc.)
            # Format: op -> (mnemonic, operand_type, comment)
            # operand types: inh, imm8, imm16, dir, ext, idx, rel8, rel16,
            #                lea, pshs, pshu, exg, tfr, bsr, lbsr, jsr_dir,
            #                jsr_ext, jsr_idx, lda, ldb, ldd, cmpa, cmpb,
            #                orcc, andcc, lbra, lbsr_l

            # Table-driven: most instructions
            _T = {
                # $00-$0F direct page
                0x00:('NEG', 'dir',  ''), 0x03:('COM', 'dir', ''),
                0x04:('LSR', 'dir',  ''), 0x06:('ROR', 'dir', ''),
                0x07:('ASR', 'dir',  ''), 0x08:('LSL', 'dir', ''),
                0x09:('ROL', 'dir',  ''), 0x0A:('DEC', 'dir', ''),
                0x0C:('INC', 'dir',  ''), 0x0D:('TST', 'dir', ''),
                0x0E:('JMP', 'dir',  ''), 0x0F:('CLR', 'dir', ''),
                # Misc single-byte
                0x12:('NOP',  'inh', ''), 0x13:('SYNC','inh','wait for interrupt'),
                0x19:('DAA',  'inh', ''), 0x1D:('SEX', 'inh','sign-extend B into A'),
                0x39:('RTS',  'inh', 'return from subroutine'),
                0x3A:('ABX',  'inh', ''), 0x3B:('RTI', 'inh','return from interrupt'),
                0x3D:('MUL',  'inh', 'D = A×B unsigned'), 0x3F:('SWI','inh',''),
                # Accumulator A
                0x40:('NEGA','inh',''), 0x43:('COMA','inh',''), 0x44:('LSRA','inh',''),
                0x46:('RORA','inh',''), 0x47:('ASRA','inh',''), 0x48:('LSLA','inh',''),
                0x49:('ROLA','inh',''), 0x4A:('DECA','inh',''), 0x4C:('INCA','inh',''),
                0x4D:('TSTA','inh',''), 0x4F:('CLRA','inh','A = 0'),
                # Accumulator B
                0x50:('NEGB','inh',''), 0x53:('COMB','inh',''), 0x54:('LSRB','inh',''),
                0x56:('RORB','inh',''), 0x57:('ASRB','inh',''), 0x58:('LSLB','inh',''),
                0x59:('ROLB','inh',''), 0x5A:('DECB','inh',''), 0x5C:('INCB','inh',''),
                0x5D:('TSTB','inh',''), 0x5F:('CLRB','inh','B = 0'),
                # Indexed ($60-$6F)
                0x60:('NEG','idx',''), 0x63:('COM','idx',''), 0x64:('LSR','idx',''),
                0x66:('ROR','idx',''), 0x67:('ASR','idx',''), 0x68:('LSL','idx',''),
                0x69:('ROL','idx',''), 0x6A:('DEC','idx',''), 0x6C:('INC','idx',''),
                0x6D:('TST','idx',''), 0x6E:('JMP','idx',''), 0x6F:('CLR','idx',''),
                # Extended ($70-$7F)
                0x70:('NEG','ext',''), 0x73:('COM','ext',''), 0x74:('LSR','ext',''),
                0x76:('ROR','ext',''), 0x77:('ASR','ext',''), 0x78:('LSL','ext',''),
                0x79:('ROL','ext',''), 0x7A:('DEC','ext',''), 0x7C:('INC','ext',''),
                0x7D:('TST','ext',''), 0x7E:('JMP','ext',''), 0x7F:('CLR','ext',''),
                # Immediate ($80-$8F)
                0x80:('SUBA','imm8', ''),  0x82:('SBCA','imm8',''),
                0x83:('SUBD','imm16',''),  0x84:('ANDA','imm8', ''),
                0x85:('BITA','imm8', ''),  0x88:('EORA','imm8', ''),
                0x89:('ADCA','imm8', ''),  0x8A:('ORA', 'imm8', ''),
                0x8B:('ADDA','imm8', ''),  0x8C:('CMPX','imm16',''),
                0x8E:('LDX', 'imm16',''),
                # Direct ($90-$9F)
                0x90:('SUBA','dir',''), 0x91:('CMPA','dir',''), 0x92:('SBCA','dir',''),
                0x93:('SUBD','dir',''), 0x94:('ANDA','dir',''), 0x95:('BITA','dir',''),
                0x96:('LDA', 'dir',''), 0x97:('STA', 'dir',''), 0x98:('EORA','dir',''),
                0x99:('ADCA','dir',''), 0x9A:('ORA', 'dir',''), 0x9B:('ADDA','dir',''),
                0x9C:('CMPX','dir',''), 0x9E:('LDX', 'dir',''), 0x9F:('STX', 'dir',''),
                # Indexed ($A0-$AF)
                0xA0:('SUBA','idx',''), 0xA1:('CMPA','idx',''), 0xA2:('SBCA','idx',''),
                0xA3:('SUBD','idx',''), 0xA4:('ANDA','idx',''), 0xA5:('BITA','idx',''),
                0xA6:('LDA', 'idx',''), 0xA7:('STA', 'idx',''), 0xA8:('EORA','idx',''),
                0xA9:('ADCA','idx',''), 0xAA:('ORA', 'idx',''), 0xAB:('ADDA','idx',''),
                0xAC:('CMPX','idx',''), 0xAE:('LDX', 'idx',''), 0xAF:('STX', 'idx',''),
                # Extended ($B0-$BF)
                0xB0:('SUBA','ext',''), 0xB1:('CMPA','ext',''), 0xB2:('SBCA','ext',''),
                0xB3:('SUBD','ext',''), 0xB4:('ANDA','ext',''), 0xB5:('BITA','ext',''),
                0xB6:('LDA', 'ext',''), 0xB7:('STA', 'ext',''), 0xB8:('EORA','ext',''),
                0xB9:('ADCA','ext',''), 0xBA:('ORA', 'ext',''), 0xBB:('ADDA','ext',''),
                0xBC:('CMPX','ext',''), 0xBE:('LDX', 'ext',''), 0xBF:('STX', 'ext',''),
                # Immediate ($C0-$CF)
                0xC0:('SUBB','imm8', ''), 0xC2:('SBCB','imm8',''),
                0xC3:('ADDD','imm16',''), 0xC4:('ANDB','imm8',''),
                0xC5:('BITB','imm8', ''), 0xC8:('EORB','imm8',''),
                0xC9:('ADCB','imm8', ''), 0xCA:('ORB', 'imm8',''),
                0xCB:('ADDB','imm8', ''), 0xCE:('LDU', 'imm16',''),
                # Direct ($D0-$DF)
                0xD0:('SUBB','dir',''), 0xD1:('CMPB','dir',''), 0xD2:('SBCB','dir',''),
                0xD3:('ADDD','dir',''), 0xD4:('ANDB','dir',''), 0xD5:('BITB','dir',''),
                0xD6:('LDB', 'dir',''), 0xD7:('STB', 'dir',''), 0xD8:('EORB','dir',''),
                0xD9:('ADCB','dir',''), 0xDA:('ORB', 'dir',''), 0xDB:('ADDB','dir',''),
                0xDC:('LDD', 'dir',''), 0xDD:('STD', 'dir',''), 0xDE:('LDU', 'dir',''),
                0xDF:('STU', 'dir',''),
                # Indexed ($E0-$EF)
                0xE0:('SUBB','idx',''), 0xE1:('CMPB','idx',''), 0xE2:('SBCB','idx',''),
                0xE3:('ADDD','idx',''), 0xE4:('ANDB','idx',''), 0xE5:('BITB','idx',''),
                0xE6:('LDB', 'idx',''), 0xE7:('STB', 'idx',''), 0xE8:('EORB','idx',''),
                0xE9:('ADCB','idx',''), 0xEA:('ORB', 'idx',''), 0xEB:('ADDB','idx',''),
                0xEC:('LDD', 'idx',''), 0xED:('STD', 'idx',''), 0xEE:('LDU', 'idx',''),
                0xEF:('STU', 'idx',''),
                # Extended ($F0-$FF)
                0xF0:('SUBB','ext',''), 0xF1:('CMPB','ext',''), 0xF2:('SBCB','ext',''),
                0xF3:('ADDD','ext',''), 0xF4:('ANDB','ext',''), 0xF5:('BITB','ext',''),
                0xF6:('LDB', 'ext',''), 0xF7:('STB', 'ext',''), 0xF8:('EORB','ext',''),
                0xF9:('ADCB','ext',''), 0xFA:('ORB', 'ext',''), 0xFB:('ADDB','ext',''),
                0xFC:('LDD', 'ext',''), 0xFD:('STD', 'ext',''), 0xFE:('LDU', 'ext',''),
                0xFF:('STU', 'ext',''),
            }

            if op in _T:
                mn, otype, cm = _T[op]
                if   otype == 'inh':   pass
                elif otype == 'imm8':  v=rb();  op_str=f'#${v:02X}'
                elif otype == 'imm16': v=rw();  op_str=f'#${v:04X}'
                elif otype == 'dir':   v=rb();  op_str=dp(v)
                elif otype == 'ext':   v=rw();  op_str=f'${v:04X}'
                elif otype == 'idx':   op_str=idx()

            # ── Special cases with context-sensitive comments ─────────────
            elif op == 0x81:
                v=rb(); mn='CMPA'; op_str=f'#${v:02X}'
                c2=self._char_ann(v); cm=f"compare A with {c2}" if c2 else ''
            elif op == 0x86:
                v=rb(); mn='LDA'; op_str=f'#${v:02X}'
                c2=self._char_ann(v); cm=f"A = {c2}" if c2 else ''
            elif op == 0x8D:
                l,t=rel8(); mn='BSR'; op_str=l
                if t in lbs: cm=f"call {lbs[t]}"
            elif op == 0xC1:
                v=rb(); mn='CMPB'; op_str=f'#${v:02X}'
                c2=self._char_ann(v); cm=f"compare B with {c2}" if c2 else ''
            elif op == 0xC6:
                v=rb(); mn='LDB'; op_str=f'#${v:02X}'
                ss=SS_CODES.get(v,''); c2=self._char_ann(v)
                if ss:   cm=f"B = {ss}  (GetStt/SetStt subcode)"
                elif c2: cm=f"B = {c2}"
            elif op == 0xCC:
                v=rw(); mn='LDD'; op_str=f'#${v:04X}'
                hi=v>>8; lo=v&0xFF
                if hi==0x1B and lo in WIN_ESC:
                    nm2,desc,_=WIN_ESC[lo]; ch=chr(lo) if 32<=lo<127 else f'${lo:02X}'
                    cm=f"D=ESC+'{ch}'  → {nm2}: {desc}"
                elif hi==0x1B: cm=f"D=ESC+${lo:02X}"
            elif op == 0x16:
                l,t=rel16(); mn='LBRA'; op_str=l
            elif op == 0x17:
                l,t=rel16(); mn='LBSR'; op_str=l
                if t in lbs: cm=f"call {lbs[t]}"
            elif op == 0x1A:
                v=rb(); mn='ORCC';  op_str=f'#${v:02X}'; cm=f"set CC: {self._cc_str(v)}"
            elif op == 0x1C:
                v=rb(); mn='ANDCC'; op_str=f'#${v:02X}'; cm=f"clr CC: {self._cc_str(~v&0xFF)}"
            elif op == 0x1E:
                pb=rb(); s2=IREG16.get((pb>>4)&0xF,'?'); d2=IREG16.get(pb&0xF,'?')
                if '?' in (s2, d2):
                    mn='FCB'; op_str=f'${op:02X},${pb:02X}'; cm=f'EXG with unknown register code ${pb:02X}'
                else:
                    mn='EXG'; op_str=f'{s2},{d2}'
                    if any(r in (s2,d2) for r in ('W','V','E','F')): self.found_6309=True
            elif op == 0x1F:
                pb=rb(); s2=IREG16.get((pb>>4)&0xF,'?'); d2=IREG16.get(pb&0xF,'?')
                if '?' in (s2, d2):
                    mn='FCB'; op_str=f'${op:02X},${pb:02X}'; cm=f'TFR with unknown register code ${pb:02X}'
                else:
                    mn='TFR'; op_str=f'{s2},{d2}'
                    if any(r in (s2,d2) for r in ('W','V','E','F')): self.found_6309=True
            elif op == 0x20: l,t=rel8(); mn='BRA'; op_str=l
            elif op == 0x21: l,t=rel8(); mn='BRN'; op_str=l
            elif op == 0x22: l,t=rel8(); mn='BHI'; op_str=l
            elif op == 0x23: l,t=rel8(); mn='BLS'; op_str=l
            elif op == 0x24: l,t=rel8(); mn='BCC'; op_str=l; cm='C=0 (BHS)'
            elif op == 0x25: l,t=rel8(); mn='BCS'; op_str=l; cm='C=1 (BLO)'
            elif op == 0x26: l,t=rel8(); mn='BNE'; op_str=l
            elif op == 0x27: l,t=rel8(); mn='BEQ'; op_str=l
            elif op == 0x28: l,t=rel8(); mn='BVC'; op_str=l
            elif op == 0x29: l,t=rel8(); mn='BVS'; op_str=l
            elif op == 0x2A: l,t=rel8(); mn='BPL'; op_str=l
            elif op == 0x2B: l,t=rel8(); mn='BMI'; op_str=l
            elif op == 0x2C: l,t=rel8(); mn='BGE'; op_str=l
            elif op == 0x2D: l,t=rel8(); mn='BLT'; op_str=l
            elif op == 0x2E: l,t=rel8(); mn='BGT'; op_str=l
            elif op == 0x2F: l,t=rel8(); mn='BLE'; op_str=l
            elif op == 0x30:
                s2,tgt=lea(); mn='LEAX'; op_str=s2
                if tgt and tgt in lbs: cm=f"X → {lbs[tgt]}"
            elif op == 0x31:
                s2,tgt=lea(); mn='LEAY'; op_str=s2
                if tgt and tgt in lbs: cm=f"Y → {lbs[tgt]}"
            elif op == 0x32:
                s2,tgt=lea(); mn='LEAS'; op_str=s2
            elif op == 0x33:
                s2,tgt=lea(); mn='LEAU'; op_str=s2
                if tgt and tgt in lbs: cm=f"U → {lbs[tgt]}"
            elif op == 0x34: pb=rb(); mn='PSHS'; op_str=self._push_regs(pb,True)
            elif op == 0x35:
                pb=rb(); mn='PULS'; op_str=self._push_regs(pb,True)
                if pb&0x80: cm='return from subroutine  (PULS PC = RTS)'
            elif op == 0x36: pb=rb(); mn='PSHU'; op_str=self._push_regs(pb,False)
            elif op == 0x37: pb=rb(); mn='PULU'; op_str=self._push_regs(pb,False)
            elif op == 0x3C: v=rb(); mn='CWAI'; op_str=f'#${v:02X}'
            elif op == 0x9D:
                v=rb(); mn='JSR'; op_str=dp(v); cm='call via direct page'
            elif op == 0xAD:
                op_str=idx(); mn='JSR'; cm='call via indexed pointer'
            elif op == 0xBD:
                v=rw(); mn='JSR'; op_str=f'${v:04X}'
                lb=lbs.get(v,''); cm=f"call {lb}" if lb else ''
            elif op == 0xBB:
                v=rw(); mn='ADDA'; op_str=f'${v:04X}'   # note: was ADDB in old code — bug fixed
            else:
                # Unknown — will try 6309 decoder below
                pass

        if mn == '???' and getattr(self, '_cpu', '6809') == '6309':
            result = decode_6309(d, start, self.labels, self.project.bss)
            if result is not None:
                return result
        if mn == '???':
            pos = start + 1  # consume just the opcode byte
            mn='FCB'; op_str=f'${d[start]:02X}'; cm=f'undefined opcode ${d[start]:02X} -- not a valid 6809 instruction'
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

            # ── Substitution: analyst-supplied replacement for these bytes ──
            subs = self.project.substitutions if hasattr(self.project, 'substitutions') else {}
            if i in subs:
                sub = subs[i]
                # Emit the analyst's replacement lines verbatim
                for wline in sub.get('with_lines', []):
                    out.append(wline)
                # Advance past the bytes covered by the replace block
                # Count bytes from the replace_lines
                replace_bytes = _count_data_bytes(sub.get('replace_lines', []))
                i += max(replace_bytes, 1)
                last_printable = False
                continue

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

            if fmt == 'fdb' or fmt.startswith('fdb:'):
                # Parse entries per line: 'fdb' = 1, 'fdb:8' = 8
                try:
                    epl = int(fmt.split(':')[1]) if ':' in fmt else 1
                except (IndexError, ValueError):
                    epl = 1
                if i+1 < end:
                    v = (d[i]<<8)|d[i+1]
                    # Collect entries_per_line values then emit as one line
                    entries = []
                    while i+1 < end and len(entries) < epl:
                        entries.append(f"${(d[i]<<8)|d[i+1]:04X}")
                        i += 2
                    out.append(f"         FDB    {','.join(entries)}")
                else:
                    # Odd byte at end of fdb region -- emit as plain FCB
                    out.append(f"         FCB    ${d[i]:02X}")
                    i += 1
                last_printable = False; continue

            if fmt == 'raw':
                out.append(f"         FCB    ${b:02X}")
                i += 1; last_printable = False; continue

            if fmt == 'hexdump' or fmt.startswith('hexdump:'):
                # hexdump format: N FDBs per line (default 8 = 16 bytes)
                # with ASCII comment column. FCB for odd trailing byte.
                try:
                    fdbs_per_line = int(fmt.split(':')[1]) if ':' in fmt else 8
                except (IndexError, ValueError):
                    fdbs_per_line = 8
                bytes_per_line = fdbs_per_line * 2
                # Collect one full line worth of bytes
                line_bytes = []
                while i < end and len(line_bytes) < bytes_per_line:
                    line_bytes.append(d[i])
                    i += 1
                # Build FDB entries (pairs), FCB for odd trailing byte
                entries = []
                j = 0
                while j + 1 <= len(line_bytes):
                    if j + 1 < len(line_bytes):
                        entries.append(f"${(line_bytes[j]<<8)|line_bytes[j+1]:04X}")
                        j += 2
                    else:
                        entries.append(f"${line_bytes[j]:02X}")  # odd byte as FCB below
                        j += 1
                # Check if last entry is an odd byte
                odd_byte = None
                if len(line_bytes) % 2 != 0:
                    odd_byte = line_bytes[-1]
                    fdb_entries = entries[:-1]
                else:
                    fdb_entries = entries
                # Build ASCII comment
                ascii_chars = ''.join(
                    chr(b) if 0x20 <= b < 0x7F else '.'
                    for b in line_bytes
                )
                if fdb_entries:
                    out.append(f"         FDB    {','.join(fdb_entries)}   ; {ascii_chars}")
                if odd_byte is not None:
                    out.append(f"         FCB    ${odd_byte:02X}   ; odd byte")
                last_printable = False; continue

            if fmt == 'text':
                # text format: emit FCC for printable runs, FCB for control bytes
                # Collect a run of printable ASCII bytes
                if 0x20 <= b <= 0x7E:
                    # Gather printable run
                    run_start = i
                    run = []
                    while i < end and 0x20 <= d[i] <= 0x7E:
                        run.append(chr(d[i]))
                        i += 1
                    text = ''.join(run)
                    # Escape quotes in the string
                    if '"' in text:
                        # Split on double quotes, emit as separate FCC/FCB
                        parts = text.split('"')
                        for j, part in enumerate(parts):
                            if part:
                                out.append(f'         FCC    "{part}"')
                            if j < len(parts) - 1:
                                out.append(f'         FCB    $22               ; "')
                    else:
                        out.append(f'         FCC    "{text}"')
                    last_printable = True; continue
                else:
                    # Control/non-printable byte
                    cm = {0x00:'NUL', 0x07:'BEL', 0x08:'BS', 0x09:'TAB',
                          0x0A:'LF',  0x0C:'FF',  0x0D:'CR', 0x1B:'ESC',
                          0x80:'hi-bit set'}.get(b, '')
                    cmt = f' ; {cm}' if cm else ''
                    out.append(f"         FCB    ${b:02X}{cmt}")
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

            # OS-9 CurXY — in data regions only (auto or writeblock format)
            if b==0x02 and i+2<end and fmt in ('auto', 'writeblock'):
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
            if r['end'] is not None:
                for a2 in range(r['start'], r['end']) if r['end'] is not None else []:
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
        if proj.defs_file:
            out.append(f"         use     {proj.defs_file}")
            out.append("")
        elif proj.emit_equates:
            out.append(EQUATES_BLOCK)
        if proj.custom_equates:
            out.append("; ── Project-specific equates ──")
            out.extend(proj.custom_equates)
            out.append("")

        if proj.bss:
            out.append("; ── BSS Variable Equates ─────────────────────────────────────")
            sorted_bss = sorted(proj.bss.keys())
            for i, off in enumerate(sorted_bss):
                name_str = proj.bss[off]
                # Determine size from gap to next named offset
                if i + 1 < len(sorted_bss):
                    gap = sorted_bss[i+1] - off
                    size_cmt = f"{gap} byte{'s' if gap != 1 else ''}"
                else:
                    size_cmt = "?"
                out.append(f"{name_str:<14}EQU    ${off:02X}      ; {size_cmt}")
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
            "         FDB    ModCRC-ModHeader   ; module size (content + 3 CRC bytes)",
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
                pre_fmt_map = {}  # addr -> (end, fmt, comment, end_label, label)
                for r in proj.data_regions:
                    if r['start'] < exec_off:
                        # end can be None — we'll use pend (natural boundary) instead
                        pre_fmt_map[r['start']] = (r.get('end'), r.get('format','auto'),
                                                    r.get('comment',''),
                                                    r.get('end_label', False),
                                                    r.get('label', ''))

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
                            rend, rfmt, rcmt, r_end_label, r_label = pre_fmt_map[cur]
                            rend = min(rend, pend) if rend is not None else pend
                            if cur > paddr:
                                out.extend(self.emit_data(paddr, cur, 
                                    {k:v for k,v in sub.items() if paddr <= k < cur}))
                            if rcmt:
                                for cline in rcmt.split('\n'):
                                    out.append(f"; {cline}")
                            out.extend(self.emit_data(cur, rend,
                                {k:v for k,v in sub.items() if cur <= k < rend}, rfmt))
                            # Emit end_label if declared for this region
                            if r_end_label:
                                end_lbl = r_label or f'Dat_{cur:04X}'
                                out.append(f"{end_lbl}end")
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
                        if r['end'] is not None and r['start'] <= span_start < r['end']:
                            proj_r = r
                            break

                fmt = proj_r.get('format', 'auto')
                # Apply syscall-derived format hint if no explicit project format
                if fmt == 'auto' and span_start in self.data_hints:
                    hint = self.data_hints[span_start]
                    if (hint.get('syscall') == 'I$Write'
                            and proj_r.get('end') is not None
                            and span_start + 1 < len(self.data)
                            and ((self.data[span_start]<<8)|self.data[span_start+1])
                                == (proj_r.get('end', span_start) - span_start)):
                        fmt = 'iwrite'

                # For fdb/raw regions: if this is the START of the declared region,
                # render the ENTIRE region at once to avoid sub-span alignment issues.
                # Sub-labels within the region are passed as 'sub' to emit_data.
                if is_parent_region_start and fmt in ('fdb', 'raw', 'text', 'auto', 'hexdump', 'writeblock'):
                    region_end = proj_r.get('end')
                    out.append(""); out.append(f"{span_lbl}")
                    callers = self.xrefs.get(span_start, [])
                    if callers:
                        caller_strs = [lbs.get(ca, f'${ca:04X}') for ca in sorted(callers)]
                        out.append(f"; Referenced by: {', '.join(caller_strs)}")
                    if proj_r.get('comment'):
                        out.append(f"; {proj_r['comment']}")
                    out.append(f"; ── {region_end-span_start} (${region_end-span_start:04X}) bytes  (${span_start:04X}—${region_end-1:04X}) ──")
                    sub = {k:v for k,v in lbs.items()
                           if span_start < k < region_end}
                    out.extend(self.emit_data(span_start, region_end, sub, fmt))
                    # Emit end label if declared
                    if proj_r.get('end_label'):
                        end_lbl = proj_r.get('label', f'Dat_{span_start:04X}')
                        out.append(f"{end_lbl}end")
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
                                r['end'] is not None and r['start'] < span_start < r['end']):
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
                out.append(f"; ── {span_end-span_start} (${span_end-span_start:04X}) bytes  (${span_start:04X}—${span_end-1:04X}) ──")
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
                if r.get('format') in ('fdb','raw') and r['end'] is not None and r['start'] <= span_start < r['end']:
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

                # block comment — only emit if not already emitted at span level
                if pos != span_start:
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
                    # ── Check for mid-instruction overlap before decoding ──
                    # Only if the byte at pos is undefined on 6809 (would decode
                    # as '???') OR is already in proj.forced_equs.
                    # This avoids falsely treating valid code as overlaps.
                    if lbl_here:
                        test_mn, _, _, test_raw, _ = self.decode_one(pos)
                        is_undefined = (test_mn in ('???', 'FCB') and len(test_raw) == 1)
                        in_forced = pos in proj.forced_equs
                        if is_undefined and not in_forced:
                            for istart, iend in sorted(self.insn_spans.items()):
                                if istart < pos < iend:
                                    byte_val = d[pos]
                                    hx = f'{byte_val:02X}'
                                    ls = f'{lbl_here}:'
                                    used_nums = set(footnote_used.values())
                                    next_num = 1
                                    while next_num in used_nums: next_num += 1
                                    footnote_used[pos] = next_num
                                    fn_num = next_num
                                    cont_lbl = lbs.get(istart, f'Insn_{istart:04X}')
                                    if not lbs.get(istart):
                                        lbs[istart] = cont_lbl
                                    offset_into = pos - istart
                                    equ_expr = f'${pos:04X}'
                                    equ_cmt = (f'[*{fn_num}] branch target {offset_into} '
                                               f'byte(s) inside {cont_lbl} -- see [*{fn_num}]')
                                    out.append(f'${pos:04X}  {hx}                  '
                                               f'{ls:<20} EQU    {equ_expr}            '
                                               f'; {equ_cmt}')
                                    if pos not in proj.forced_equs:
                                        proj.forced_equs[pos] = (
                                            f'mid-instruction overlap: {cont_lbl}+{offset_into}')
                                    pos += 1
                                    prev_ret = False
                                    raise _OverlapHandled()
                    mn, op_str, cm, raw, pos2 = self.decode_one(pos)
                except _OverlapHandled:
                    continue
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
                        # Attempt to disassemble gap as code rather than padding
                        gap_pos = pos
                        out.append("")
                        while gap_pos < nxt:
                            # Check for forced overlap (mid-instruction label)
                            if gap_pos in proj.forced_equs:
                                equ_comment = proj.forced_equs[gap_pos]
                                containing = None
                                for a2 in lbs:
                                    if a2 < gap_pos:
                                        mn_t,_,_,raw_t,_ = self.decode_one(a2)
                                        if a2 + len(raw_t) > gap_pos:
                                            containing = lbs[a2]; break
                                equ_expr = f"{lbs[gap_pos]} EQU {containing}+{gap_pos - list(lbs.keys())[list(lbs.values()).index(containing)]}" if containing and lbs.get(gap_pos) else f"${gap_pos:04X}"
                                lbl = lbs.get(gap_pos, f"Loc_{gap_pos:04X}")
                                fn_idx = len(proj.footnotes) + 1
                                out.append(f"${gap_pos:04X}  {d[gap_pos]:02X}                  {lbl}:      EQU    ${gap_pos:04X}")
                                gap_pos += 1
                                continue
                            res = self.decode_one(gap_pos)
                            if res is None:
                                # Truly undecipherable — emit as FCB
                                out.append(f"         FCB    ${d[gap_pos]:02X}"
                                           f"                ; undefined opcode ${d[gap_pos]:02X}"
                                           f" -- not a valid 6809 instruction")
                                gap_pos += 1
                            else:
                                gmn, gop, gcm, graw, gnxt = res
                                glbl = lbs.get(gap_pos, '')
                                glbl_str = f"{glbl}:" if glbl else ''
                                gcmt = f'   ; {gcm}' if gcm else ''
                                hex_bytes = ' '.join(f'{b:02X}' for b in graw)
                                out.append(
                                    f"${gap_pos:04X}  {hex_bytes:<20}"
                                    f"  {glbl_str:<20} {gmn} {gop}{gcmt}"
                                )
                                gap_pos = gnxt
                        pos = nxt; prev_ret = False

        out += [
            "",
            f"; {'='*62}",
            "; ModEnd — CRC-24 appended by fixmod (not in source)",
            f"; {'='*62}",
            "ModEnd",
            "; CRC-24 (3 bytes) appended here by fixmod",
            "         FCB    $00,$00,$00        ; CRC placeholder — overwritten by fixmod",
            "ModCRC",
            "ModSize  EQU    ModCRC-ModHeader   ; module size including 3 CRC bytes"
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
        elif op2 == 0xD6: v=rb(); mn='LDE';   op_str=dp(v)
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
        elif op2 == 0x9F: v=rb(); mn='MULD'; op_str=dp(v)
        elif op2 == 0x88: v=rb(); mn='DIVD'; op_str=f'#${v:02X}'; cm='D = D ÷ imm8; remainder in B'
        elif op2 == 0x98: v=rb(); mn='DIVD'; op_str=dp(v)
        elif op2 == 0x8B: v=rw(); mn='DIVQ'; op_str=f'#${v:04X}'; cm='W:D = Q ÷ imm16'
        elif op2 == 0x9B: v=rb(); mn='DIVQ'; op_str=dp(v)

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


# ── CLI entry point ───────────────────────────────────────────────────────────

def _import_project(old_proj, old_json_path, new_json_path, actual_crc):
    """
    Create a new project JSON for a different binary, importing analyst
    work from old_proj. Binary-specific fields are not carried over.
    """
    new = Project.scaffold(old_proj.binary, old_proj.output)
    new.binary_crc    = actual_crc

    # Fields that carry over cleanly
    new.cpu            = old_proj.cpu
    new.module_notes   = list(old_proj.module_notes)
    new.custom_equates = list(old_proj.custom_equates)
    new.labels         = dict(old_proj.labels)
    new.bss            = dict(old_proj.bss)
    new.line_comments  = dict(old_proj.line_comments)
    new.block_comments = dict(old_proj.block_comments)
    new.data_regions   = list(old_proj.data_regions)
    new.routines       = list(old_proj.routines)

    # Substitutions carry over with a warning
    if old_proj.substitutions:
        new.substitutions = dict(old_proj.substitutions)
        print(f"  WARNING: {len(old_proj.substitutions)} substitution(s) imported.")
        print(f"           These reference specific binary bytes — verify they")
        print(f"           still apply to the new binary before assembling.")

    # forced_equs and patches do NOT carry over
    if old_proj.forced_equs:
        print(f"  NOTE: {len(old_proj.forced_equs)} forced_equ(s) NOT imported "
              f"(binary corruption workarounds)")
    if old_proj.patches:
        print(f"  NOTE: {len(old_proj.patches)} patch(es) NOT imported "
              f"(binary-specific)")

    import shutil
    backup = old_json_path + '.bak'
    shutil.copy2(old_json_path, backup)
    print(f"  Old JSON backed up: {backup}")

    new.to_json(new_json_path)
    print(f"  New JSON created:   {new_json_path}")
    return new


def _print_anomaly_report(eng, source):
    """
    Print an anomaly report covering:
    1. Unreferenced labels — labels with no xref (no 'Referenced by')
    2. Code overlaps — forced_equs entries (branch targets mid-instruction)
    3. Mid-data references — labels inside declared data regions
    """
    exec_off = eng.exec_off
    crc_off  = eng.crc_off
    labels   = eng.labels
    regions  = eng.regions
    xrefs    = eng.xrefs
    proj     = eng.project

    print(f"\n{'='*62}")
    print(f"ANOMALY REPORT: {source}")
    print(f"{'='*62}\n")

    # ── 1. Unreferenced labels ────────────────────────────────────────────
    # Labels in pre-exec OR data regions in code section with no xref entry
    # Build set of addresses covered by declared data regions
    # to filter out sub-labels within known regions
    declared_region_addrs = set()
    for r in proj.data_regions:
        if r.get('start') is not None and r.get('end') is not None:
            for a in range(r['start'], r['end']) if r['end'] is not None else []:
                declared_region_addrs.add(a)

    unreferenced = []
    for addr, lbl in sorted(labels.items()):
        if addr < 0 or addr >= crc_off:
            continue  # skip invalid addresses
        if addr == exec_off:
            continue  # Init is always unreferenced in xrefs
        if addr in proj.labels:
            continue  # analyst-named labels are intentional
        if addr in declared_region_addrs and addr != min(declared_region_addrs):
            continue  # sub-label inside a declared region — expected
        if regions.get(addr) == KIND_DATA:
            if addr not in xrefs or not xrefs[addr]:
                unreferenced.append((addr, lbl))

    if unreferenced:
        print(f"UNREFERENCED LABELS ({len(unreferenced)}):")
        print(f"  These labels have no 'Referenced by' entry.")
        print(f"  May indicate mid-data references from non-LEA instructions,")
        print(f"  computed addresses, or data values misread as pointers.\n")
        for addr, lbl in unreferenced:
            region = 'pre-exec' if addr < exec_off else 'code section'
            print(f"  ${addr:04X}  {lbl:<20}  ({region})")
        print()
    else:
        print("UNREFERENCED LABELS: none\n")

    # Build branch caller map for forced_equs
    # xrefs only captures LEA instructions — need to scan branches too
    branch_callers = {}
    d = eng.data
    pos = exec_off

    def _bs8(v):  return v - 256 if v >= 128 else v
    def _bs16(v): return v - 65536 if v >= 32768 else v

    while pos < crc_off - 3:
        op = d[pos]
        t = None
        adv = 1
        if op in range(0x20, 0x30):
            t = pos + 2 + _bs8(d[pos+1]); adv = 2
        elif op in (0x16, 0x17):
            t = pos + 3 + _bs16((d[pos+1]<<8)|d[pos+2]); adv = 3
        elif op == 0x10:
            op2 = d[pos+1]
            if op2 in range(0x21, 0x30) or op2 in range(0x81, 0x90):
                t = pos + 4 + _bs16((d[pos+2]<<8)|d[pos+3]); adv = 4
            else: adv = 1
        if t is not None:
            if t not in branch_callers: branch_callers[t] = []
            branch_callers[t].append(pos)
        pos += adv

    # ── 2. Code overlaps (forced_equs) ───────────────────────────────────
    forced = eng.project.forced_equs
    if forced:
        print(f"CODE OVERLAPS / FORCED EQUS ({len(forced)}):")
        print(f"  Branch targets that land inside an existing instruction.")
        print(f"  'No callers' may indicate a false positive from data values.\n")
        for addr in sorted(forced.keys()):
            lbl  = labels.get(addr, f'${addr:04X}')
            note = forced[addr] if isinstance(forced[addr], str) else ''
            callers = branch_callers.get(addr, [])
            caller_str = ', '.join(labels.get(c, f'${c:04X}') for c in callers)
            flag = '*** REAL OVERLAP ***' if callers else '(no callers — suspected false positive)'
            print(f"  ${addr:04X}  {lbl:<20}  {flag}")
            if callers:
                print(f"         callers: {caller_str}")
            if note:
                print(f"         {note}")
            print()
    else:
        print("CODE OVERLAPS: none\n")

    # ── 3. Mid-data references ───────────────────────────────────────────
    # Labels that fall inside a known data span (between two other data labels)
    # i.e. the label address is > start of a data block but < the next label
    pre_exec_labels = sorted(
        [(a, l) for a, l in labels.items() if a < exec_off],
        key=lambda x: x[0]
    )
    mid_data = []
    for i, (addr, lbl) in enumerate(pre_exec_labels):
        if addr in xrefs and xrefs[addr]:
            continue  # has a proper reference
        if addr in [a for a,_ in pre_exec_labels if a == addr]:
            # Check if this address falls inside a string/data run
            # by checking if adjacent bytes are printable ASCII
            d = eng.data
            prev_byte = d[addr-1] if addr > 0 else 0
            if 0x20 <= prev_byte < 0x7F:
                mid_data.append((addr, lbl))

    if mid_data:
        print(f"SUSPECTED MID-DATA REFERENCES ({len(mid_data)}):")
        print(f"  Labels that appear to fall inside continuous data blocks.\n")
        for addr, lbl in mid_data:
            d = eng.data
            context = ''.join(
                chr(b) if 0x20 <= b < 0x7F else '.'
                for b in d[max(0,addr-8):addr+8]
            )
            print(f"  ${addr:04X}  {lbl:<20}  context: ...{context}...")
        print()
    else:
        print("SUSPECTED MID-DATA REFERENCES: none\n")

    print(f"{'='*62}\n")



# ── Markup quick reference ────────────────────────────────────────────────────

MARKUP_QUICK_REF = """
; ══════════════════════════════════════════════════════════════
; MARKUP QUICK REFERENCE  (markup.py directives)
; ══════════════════════════════════════════════════════════════
;
; Run:  python markup.py proj.asm [proj.json]
; Then: python dis6809_os9_engine.py --source bin --proj proj.json -n
;
; ── Labeling ──────────────────────────────────────────────────
;
; /label/ Name
;     Name the next address in the listing.
;     Example:
;         /label/ Sub_ReadDir
;         $0126  96 00    LDA <$00
;
; /bss/ $XX Name
;     Declare a BSS variable at direct page offset $XX.
;     Example:
;         /bss/ $00 BSS.DirPath
;         /bss/ $7A BSS.DotChar
;
; ── Data regions ──────────────────────────────────────────────
;
; /region/ $start $end [format] [label] [endlabel]
;     Declare a data region. Format: auto text fdb hexdump raw writeblock
;     endlabel — emit a NameEnd label at the region boundary.
;     Example:
;         /region/ $052C $06A7 text endlabel
;         /region/ $047D $052C text Dat_047D
;
; /format/ fmt
;     Set format for the preceding data label's region.
;     Example:
;         Dat_046E
;         /format/ text
;
; /end-label/
;     Mark end of a data region at the next address.
;     Example:
;         /end-label/
;         $06A7  5A    Sub_06A7: DECB
;
; ── Comments ──────────────────────────────────────────────────
;
; /; comment text/
;     Inline comment appended to the instruction on this line.
;     Example:
;         $00E9  A6 80    LDA ,X+    /; loop copying path to buffer/
;
; /comment/ [$addr]
; comment line 1
; comment line 2
; /end-comment/
;     Block comment inserted before the target address.
;     Optional $addr targets a specific address directly.
;     Without $addr, targets the next $XXXX line.
;     Example:
;         /comment/ $0519
;         This FCC line is a format template updated in place.
;         /end-comment/
;
; /remove-comment/
; comment line to remove
; /end-remove-comment/
;     Remove a block comment matching the given content from the JSON.
;     Prefix '; ' on each line is stripped before matching.
;     Example:
;         /remove-comment/
;         ; This comment is no longer needed.
;         /end-remove-comment/
;
; ── Substitutions ─────────────────────────────────────────────
;
; /replace/
; <original disassembler lines>
; /with/
; <replacement source lines>
; /end-replace/
;     Replace disassembler output with analyst-supplied source.
;     WARNING: byte counts must match. Instruction substitutions
;     trigger a confirmation prompt — mismatch breaks byte-perfect.
;     Example:
;         /replace/
;                  FCB    $0A               ; LF
;                  FCC    "Dir"
;         /with/
;                  FCB    C$LF
;                  FCS    /Dir/
;         /end-replace/
;
; ── Routines ──────────────────────────────────────────────────
;
; /routine/ Name
; ...code...
; /end-routine/ Name
;     Mark a routine boundary for structural annotation.
;
; ══════════════════════════════════════════════════════════════
"""

def main():
    import argparse, sys, os

    parser = argparse.ArgumentParser(
        prog='dis6809_os9_engine.py',
        description='OS-9 6809/6309 disassembler',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  First run (creates new project JSON):
    python dis6809_os9_engine.py --source supercomm22 --proj supercomm22_proj.json

  Subsequent runs:
    python dis6809_os9_engine.py --source supercomm22 --proj supercomm22_proj.json

  Stats only:
    python dis6809_os9_engine.py --source supercomm22 --proj supercomm22_proj.json --stats
""")

    parser.add_argument('--source', metavar='BINARY',
        help='Path to the OS-9 binary to disassemble')
    parser.add_argument('--proj',   metavar='JSON',
        help='Path to the project JSON file')
    parser.add_argument('--stats',  action='store_true',
        help='Show pass-1 classification stats only, no output written')
    parser.add_argument('--update-labels', action='store_true',
        help='Merge auto-generated labels into the project JSON '
             '(preserves existing names, adds only new ones)')
    parser.add_argument('--report', action='store_true',
        help='Print anomaly report: unreferenced labels, overlaps, '
             'mid-data references')
    parser.add_argument('--markup', action='store_true',
        help='Append markup quick reference to the end of the output listing')
    parser.add_argument('-n', action='store_true', dest='no_confirm',
        help='Non-interactive mode — skip confirmation prompts')
    args = parser.parse_args()

    # ── --source is always required ───────────────────────────────────────
    if not args.source:
        parser.print_usage()
        print("error: --source BINARY is required")
        sys.exit(1)

    source = args.source
    if not os.path.exists(source):
        print(f"ERROR: binary not found: {source!r}")
        sys.exit(1)

    actual_crc = binary_crc(source)

    # ── Resolve --proj ────────────────────────────────────────────────────
    if args.proj:
        json_path = args.proj

        if not os.path.exists(json_path):
            # --proj given but file doesn't exist → confirm before creating
            print(f"  Project file not found: {json_path}")
            if not args.no_confirm:
                try:
                    answer = input("  Create new project JSON? [y/N]: ").strip().lower()
                except (EOFError, KeyboardInterrupt):
                    answer = ''
                if answer != 'y':
                    print("  Aborted.")
                    sys.exit(0)
            stem = json_path
            for suffix in ('_proj.json', '.json'):
                if stem.endswith(suffix):
                    stem = stem[:-len(suffix)]
                    break
            proj = Project.scaffold(source, stem + '_proj.asm')
            proj.to_json(json_path)
            print(f"  Created:    {json_path}")
            print(f"  Binary:     {source}")
            print(f"  Binary CRC: {proj.binary_crc}")
            print(f"  Output:     {proj.output}")
            print()

        else:
            # --proj exists → load and verify CRC
            proj = Project.from_json(json_path)

            # Update binary path to match --source (analyst may have moved files)
            proj.binary = source

            if proj.binary_crc is None:
                # Old JSON without CRC — record it silently
                proj.binary_crc = actual_crc
                proj.to_json(json_path)

            elif proj.binary_crc.upper() != actual_crc.upper():
                print()
                print("  WARNING: Binary CRC mismatch")
                print(f"    --source {source}")
                print(f"      Current CRC:  {actual_crc.upper()}")
                print(f"    --proj   {json_path}")
                print(f"      Recorded CRC: {proj.binary_crc.upper()}")
                print()
                print("  Did you specify the wrong files?")
                print("  If this is intentional, enter a name for the new project")
                print("  JSON file that will be created for this binary.")
                print("  Press Enter to quit.")
                print()

                try:
                    new_name = input("  New JSON filename: ").strip()
                except (EOFError, KeyboardInterrupt):
                    new_name = ''

                if not new_name:
                    print("  Aborted.")
                    sys.exit(0)

                if not new_name.endswith('.json'):
                    new_name += '.json'

                # Warn if target already exists
                if os.path.exists(new_name):
                    print()
                    print(f"  WARNING: {new_name} already exists.")
                    if not args.no_confirm:
                        try:
                            answer = input("  Overwrite it? [y/N]: ").strip().lower()
                        except (EOFError, KeyboardInterrupt):
                            answer = ''
                        if answer != 'y':
                            print("  Aborted.")
                            sys.exit(0)
                    else:
                        print("  Aborted. (-n set, will not overwrite existing file)")
                        sys.exit(1)

                print()
                proj = _import_project(proj, json_path, new_name, actual_crc)
                json_path = new_name
                print()
                print("  Analyst work imported. To disassemble run:")
                print()
                print(f"    python dis6809_os9_engine.py --source {source} --proj {new_name}")
                print()
                sys.exit(0)

    else:
        # --proj not given
        # Check if an inferrable JSON exists — if so, tell the analyst
        stem = os.path.splitext(source)[0]
        inferred = stem + '_proj.json'

        if os.path.exists(inferred):
            print()
            print(f"  --proj not specified.")
            print(f"  Found an existing project file: {inferred}")
            print(f"  If that is the correct project, run:")
            print()
            print(f"    python dis6809_os9_engine.py --source {source} --proj {inferred}")
            print()
            sys.exit(1)

        else:
            # No JSON anywhere — prompt for a name or use default with -n
            if args.no_confirm:
                new_name = inferred
                print(f"  Creating default project: {new_name}")
            else:
                print(f"  --proj not specified and no project file found.")
                print(f"  Enter a name for the new project JSON file,")
                print(f"  or press Enter to use the default ({inferred}):")
                print()
                try:
                    new_name = input("  Project JSON name: ").strip()
                except (EOFError, KeyboardInterrupt):
                    new_name = ''
                if not new_name:
                    new_name = inferred
            if not new_name.endswith('.json'):
                new_name += '.json'

            json_path = new_name
            stem = json_path
            for suffix in ('_proj.json', '.json'):
                if stem.endswith(suffix):
                    stem = stem[:-len(suffix)]
                    break

            proj = Project.scaffold(source, stem + '_proj.asm')
            proj.to_json(json_path)
            print()
            print(f"  Created: {json_path}")
            print(f"  Binary CRC: {proj.binary_crc}")
            print()

    # ── Run engine ────────────────────────────────────────────────────────
    eng = Engine(proj)
    eng.load(open(source, 'rb').read())
    eng.run()

    # ── --stats ───────────────────────────────────────────────────────────
    if args.stats:
        exec_off = eng.exec_off
        n_code = sum(1 for k in eng.regions.values() if k in (KIND_CODE, KIND_SUB, KIND_LOC))
        n_data = sum(1 for a,k in eng.regions.items()
                     if k == KIND_DATA and a >= exec_off)
        n_pre  = sum(1 for a,k in eng.regions.items()
                     if k == KIND_DATA and a < exec_off)
        print(f"; Pass 1: {len(eng.labels)} labels  "
              f"({n_code} code  {n_data} data in code section)")
        print(f"Binary:         {source}")
        print(f"Module:         {eng.hdr['mod_name']}")
        print(f"Entry:          ${exec_off:04X}")
        print(f"Total labels:   {len(eng.labels)}")
        print(f"  Code:         {n_code}")
        print(f"  Data (code):  {n_data}")
        print(f"  Data (pre):   {n_pre}")
        return

    # ── --update-labels ───────────────────────────────────────────────────
    if args.update_labels:
        added = 0
        for addr, lbl in eng.labels.items():
            if addr not in proj.labels:
                proj.labels[addr] = lbl
                added += 1
        proj.to_json(json_path)
        print(f"Added {added} labels to {json_path}")
        return

    # ── --report ──────────────────────────────────────────────────────────
    if args.report:
        _print_anomaly_report(eng, source)
        return

    # ── Render and write ──────────────────────────────────────────────────
    asm = eng.render()
    if args.markup:
        asm = asm + MARKUP_QUICK_REF
    out_path = proj.output or (stem + '_proj.asm')
    with open(out_path, 'w', encoding='utf-8') as f:
        f.write(asm)
    print(f"Written: {out_path}  ({len(asm.splitlines())} lines)",
          file=sys.stderr)


if __name__ == '__main__':
    main()

#!/usr/bin/env python3
"""
hexview.py — interactive hex file viewer for Windows terminal

Usage: python hexview.py <filename>

Keys:
  Up / Down      scroll one line
  PgUp / PgDn   scroll one page
  Home / End     jump to first / last line
  Q or Esc       quit
"""

import sys
import os
import msvcrt

BYTES_PER_LINE = 16


# ── Windows ANSI support ─────────────────────────────────────────────────────

def enable_ansi():
    """Enable ANSI escape processing on the Windows console."""
    try:
        import ctypes
        k32    = ctypes.windll.kernel32
        handle = k32.GetStdHandle(-11)          # STD_OUTPUT_HANDLE
        mode   = ctypes.c_ulong()
        k32.GetConsoleMode(handle, ctypes.byref(mode))
        k32.SetConsoleMode(handle, mode.value | 0x0004)  # ENABLE_VIRTUAL_TERMINAL_PROCESSING
    except Exception:
        pass


# ── Terminal geometry ─────────────────────────────────────────────────────────

def term_size():
    try:
        s = os.get_terminal_size()
        return s.columns, s.lines
    except Exception:
        return 80, 25


# ── Hex line formatting ───────────────────────────────────────────────────────

def hex_line(offset, chunk):
    """
    Format one line of hex dump.

    Example (16 bytes):
        00003F00  86 00 20 06 86 01 20 02  86 02 A7 8D 00 03 39 00  |.. ... .......9.|

    Partial lines (end of file) are padded to maintain column alignment.
    ASCII column: printable 0x20-0x7E shown as-is; everything else as '.'.
    """
    left  = chunk[:8]
    right = chunk[8:16]

    left_hex  = ' '.join(f'{b:02X}' for b in left)
    right_hex = ' '.join(f'{b:02X}' for b in right)

    # Each half is up to 8 bytes: "XX XX XX XX XX XX XX XX" = 23 chars
    left_hex  = left_hex.ljust(23)
    right_hex = right_hex.ljust(23)

    asc = ''.join(chr(b) if 0x20 <= b <= 0x7E else '.' for b in chunk)
    asc = asc.ljust(16)

    return f'{offset:08X}  {left_hex}  {right_hex}  |{asc}|'
    # Total width: 8 + 2 + 23 + 2 + 23 + 2 + 1 + 16 + 1 = 78 columns


# ── Title bar ────────────────────────────────────────────────────────────────

def title_bar(filename, top_line, data_len, cols):
    """
    Build the inverse-video title line.
    Left side:  ' HEXVIEW  <filename>'
    Right side: '<offset> / <total>  <pct>%  Q:quit '
    Padded to fill the terminal width.
    """
    total_lines = max(1, (data_len + BYTES_PER_LINE - 1) // BYTES_PER_LINE)
    cur_offset  = top_line * BYTES_PER_LINE
    pct         = min(100, cur_offset * 100 // max(1, data_len - 1))

    left  = f' HEXVIEW  \u2014  {os.path.basename(filename)}'
    right = f' {cur_offset:08X} / {data_len:08X}  {pct:3d}%  Q:quit '

    # Truncate filename portion if terminal is narrow
    gap   = cols - len(right)
    left  = left[:gap] if len(left) > gap else left
    bar   = left.ljust(gap) + right

    return bar[:cols]


# ── Screen draw ───────────────────────────────────────────────────────────────

def draw(data, top_line, filename, cols, rows):
    """
    Redraw the entire screen without clearing (overwrites in place to avoid flicker).
    Row 1 (ANSI 1-based): title bar in inverse video.
    Rows 2..rows: hex content lines.
    """
    content_rows = rows - 1
    out = []

    # ── Title bar ──────────────────────────────────────────────────────────
    out.append('\033[1;1H')         # cursor to row 1, col 1
    out.append('\033[7m')           # inverse video
    out.append(title_bar(filename, top_line, len(data), cols))
    out.append('\033[0m')           # reset attributes

    # ── Content lines ──────────────────────────────────────────────────────
    for i in range(content_rows):
        row       = i + 2           # ANSI row (1-based)
        line_num  = top_line + i
        offset    = line_num * BYTES_PER_LINE

        out.append(f'\033[{row};1H')   # position cursor

        if offset < len(data):
            chunk = data[offset:offset + BYTES_PER_LINE]
            line  = hex_line(offset, chunk)
            # Pad or truncate to cols-1 (leave last column clear to avoid wrap)
            out.append(line.ljust(cols - 1)[:cols - 1])
        else:
            out.append(' ' * (cols - 1))    # blank out lines past end-of-file

    sys.stdout.write(''.join(out))
    sys.stdout.flush()


# ── Keyboard input ────────────────────────────────────────────────────────────

def get_key():
    """
    Read one keypress from the Windows console.
    Extended keys (arrows, PgUp, etc.) arrive as two bytes: 0x00 or 0xE0 + scan code.
    Returns a string token: 'UP', 'DOWN', 'PAGEUP', 'PAGEDOWN', 'HOME', 'END', 'QUIT'.
    """
    b = msvcrt.getch()
    if b in (b'\x00', b'\xe0'):
        b2 = msvcrt.getch()
        return {
            b'H': 'UP',
            b'P': 'DOWN',
            b'I': 'PAGEUP',
            b'Q': 'PAGEDOWN',
            b'G': 'HOME',
            b'O': 'END',
        }.get(b2, 'UNKNOWN')
    if b in (b'\x1b', b'q', b'Q'):
        return 'QUIT'
    return 'OTHER'


# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(0)

    filename = sys.argv[1]

    try:
        with open(filename, 'rb') as f:
            data = f.read()
    except FileNotFoundError:
        print(f'hexview: file not found: {filename}')
        sys.exit(1)
    except OSError as e:
        print(f'hexview: {e}')
        sys.exit(1)

    if not data:
        print(f'hexview: {filename}: empty file')
        sys.exit(0)

    enable_ansi()

    # Hide cursor; don't clear the screen — we'll overwrite every cell.
    sys.stdout.write('\033[?25l')
    sys.stdout.flush()

    cols, rows      = term_size()
    total_lines     = (len(data) + BYTES_PER_LINE - 1) // BYTES_PER_LINE
    top_line        = 0

    try:
        draw(data, top_line, filename, cols, rows)

        while True:
            cols, rows   = term_size()              # re-check on each keypress
            content_rows = rows - 1
            max_top      = max(0, total_lines - content_rows)

            key = get_key()

            if   key == 'QUIT':
                break
            elif key == 'UP':
                top_line = max(0, top_line - 1)
            elif key == 'DOWN':
                top_line = min(max_top, top_line + 1)
            elif key == 'PAGEUP':
                top_line = max(0, top_line - content_rows)
            elif key == 'PAGEDOWN':
                top_line = min(max_top, top_line + content_rows)
            elif key == 'HOME':
                top_line = 0
            elif key == 'END':
                top_line = max_top
            else:
                continue                            # unknown key — no redraw needed

            draw(data, top_line, filename, cols, rows)

    finally:
        # Restore cursor; move to a clean line below the content.
        sys.stdout.write(f'\033[?25h\033[0m\033[{rows};1H\n')
        sys.stdout.flush()


if __name__ == '__main__':
    main()

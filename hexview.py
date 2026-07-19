#!/usr/bin/env python3
"""
hexview.py — interactive hex file viewer, cross-platform

Usage: python hexview.py <filename>

Keys:
  Up / Down      scroll one line
  PgUp / PgDn   scroll one page
  Home / End     jump to first / last line
  Q or Esc       quit

Platforms: Windows, Linux, macOS
"""

import sys
import os
import readchar

BYTES_PER_LINE = 16


# ── Windows ANSI support ──────────────────────────────────────────────────────

def enable_ansi():
    """Enable ANSI escape processing on the Windows console. No-op on other platforms."""
    if sys.platform != 'win32':
        return
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

    left_hex  = left_hex.ljust(23)
    right_hex = right_hex.ljust(23)

    asc = ''.join(chr(b) if 0x20 <= b <= 0x7E else '.' for b in chunk)
    asc = asc.ljust(16)

    return f'{offset:08X}  {left_hex}  {right_hex}  |{asc}|'


# ── Title bar ────────────────────────────────────────────────────────────────

def title_bar(filename, top_line, data_len, cols):
    total_lines = max(1, (data_len + BYTES_PER_LINE - 1) // BYTES_PER_LINE)
    cur_offset  = top_line * BYTES_PER_LINE
    pct         = min(100, cur_offset * 100 // max(1, data_len - 1))

    left  = f' HEXVIEW  \u2014  {os.path.basename(filename)}'
    right = f' {cur_offset:08X} / {data_len:08X}  {pct:3d}%  Q:quit '

    gap   = cols - len(right)
    left  = left[:gap] if len(left) > gap else left
    bar   = left.ljust(gap) + right

    return bar[:cols]


# ── Screen draw ───────────────────────────────────────────────────────────────

def draw(data, top_line, filename, cols, rows):
    content_rows = rows - 1
    out = []

    out.append('\033[1;1H')
    out.append('\033[7m')
    out.append(title_bar(filename, top_line, len(data), cols))
    out.append('\033[0m')

    for i in range(content_rows):
        row      = i + 2
        line_num = top_line + i
        offset   = line_num * BYTES_PER_LINE

        out.append(f'\033[{row};1H')

        if offset < len(data):
            chunk = data[offset:offset + BYTES_PER_LINE]
            line  = hex_line(offset, chunk)
            out.append(line.ljust(cols - 1)[:cols - 1])
        else:
            out.append(' ' * (cols - 1))

    sys.stdout.write(''.join(out))
    sys.stdout.flush()


# ── Keyboard input -- cross-platform via readchar ───────────────────────────

def get_key():
    k = readchar.readkey()
    if k in (readchar.key.UP,):                          return 'UP'
    if k in (readchar.key.DOWN,):                        return 'DOWN'
    if k in (readchar.key.PAGE_UP,):                     return 'PAGEUP'
    if k in (readchar.key.PAGE_DOWN,):                   return 'PAGEDOWN'
    if k in (readchar.key.HOME,):                        return 'HOME'
    if k in (readchar.key.END,):                         return 'END'
    if k in (readchar.key.ESC, 'q', 'Q'):                return 'QUIT'
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

    cols, rows  = term_size()
    total_lines = (len(data) + BYTES_PER_LINE - 1) // BYTES_PER_LINE
    top_line    = 0

    # Hide cursor; clear screen once to push prior content into scrollback
    sys.stdout.write('\033[?25l\033[2J')
    sys.stdout.flush()

    try:
        draw(data, top_line, filename, cols, rows)

        while True:
            cols, rows   = term_size()
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
                continue

            draw(data, top_line, filename, cols, rows)

    finally:
        # Restore cursor; move to clean line
        sys.stdout.write(f'\033[?25h\033[0m\033[{rows};1H\n')
        sys.stdout.flush()


if __name__ == '__main__':
    main()

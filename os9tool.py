#!/usr/bin/env python3
"""
os9tool.py - Pure Python OS-9 RBF disk image tool
Supports: dir, copy with wildcards, tree, list, find
Usage:
  python3 os9tool.py dir   IMAGE[,path] [-e]
  python3 os9tool.py copy  IMAGE,srcpath[wildcard] destdir
  python3 os9tool.py tree  IMAGE[,path] [-a] [filter]
  python3 os9tool.py list  IMAGE[,path] [-r] [-p] [filter]
  python3 os9tool.py find  IMAGE[,path] pattern

list: always recursive, always full paths. -r and -p accepted for familiarity.
find: same as list with a filter pattern.
"""
import sys
import os
import struct
import fnmatch

# OS-9 RBF constants
SECTOR_SIZE = 256
DD_TOT   = 0x00  # total sectors (3 bytes)
DD_TKS   = 0x03  # track size in sectors
DD_MAP   = 0x04  # sectors used for allocation map (2 bytes)
DD_BIT   = 0x06  # sectors/cluster (2 bytes)
DD_DIR   = 0x08  # LSN of root dir FD (3 bytes)
DD_OWN   = 0x0B  # owner id (2 bytes)
DD_NAM   = 0x1F  # volume name (null terminated, hi-bit on last char)

FD_ATT   = 0x00  # attributes
FD_OWN   = 0x01  # owner
FD_DAT   = 0x03  # last modified date
FD_LNK   = 0x08  # link count
FD_SIZ   = 0x09  # file size (4 bytes)
FD_SEG   = 0x10  # segment list starts here

# Directory entry: 32 bytes, first 3 = LSN of FD, last 29 = name (hi-bit on last char)
DIRENT_SIZE = 32
# NitrOS-9 EOU directory entry layout: 29 bytes name + 3 bytes LSN
# (reversed from classic OS-9 which is 3 bytes LSN + 29 bytes name)
DIRENT_NAME_LEN = 29
DIRENT_LSN_OFF  = 29

def read_sector(img, lsn):
    img.seek(lsn * SECTOR_SIZE)
    data = img.read(SECTOR_SIZE)
    if len(data) < SECTOR_SIZE:
        data = data + bytes(SECTOR_SIZE - len(data))
    return data

def lsn3(data, offset):
    """Read 3-byte big-endian LSN"""
    return (data[offset] << 16) | (data[offset+1] << 8) | data[offset+2]

def os9name(raw):
    """Convert OS-9 hi-bit terminated name to string"""
    result = []
    for b in raw:
        if b == 0x00 and not result:
            continue  # skip leading null bytes
        result.append(chr(b & 0x7F))
        if b & 0x80:
            break
    return ''.join(result).strip('\x00')

def read_fd_segments(img, fd_lsn):
    """Read file descriptor and return list of (lsn, count) segment tuples"""
    fd = read_sector(img, fd_lsn)
    size = struct.unpack('>I', fd[FD_SIZ:FD_SIZ+4])[0]
    segments = []
    off = FD_SEG
    while off + 5 <= SECTOR_SIZE:
        seg_lsn = lsn3(fd, off)
        seg_cnt = struct.unpack('>H', fd[off+3:off+5])[0]
        if seg_lsn == 0 and seg_cnt == 0:
            break
        segments.append((seg_lsn, seg_cnt))
        off += 5
    return size, segments

def read_file_data(img, fd_lsn):
    """Read entire file content given its FD LSN"""
    size, segments = read_fd_segments(img, fd_lsn)
    # Sanity cap — no directory or file we care about exceeds 512KB
    if size > 512 * 1024:
        return b''
    img_size = get_image_size(img)
    data = bytearray()
    for seg_lsn, seg_cnt in segments:
        # Sanity check segment
        if seg_lsn == 0 or seg_cnt == 0 or seg_cnt > 4096:
            break
        if seg_lsn * SECTOR_SIZE >= img_size:
            break
        for s in range(seg_cnt):
            data += read_sector(img, seg_lsn + s)
            if len(data) >= size:
                break
        if len(data) >= size:
            break
    return bytes(data[:size])

def read_dir_entries(img, fd_lsn):
    """Yield (name, fd_lsn) for each valid entry in a directory"""
    img_size = get_image_size(img)
    data = read_file_data(img, fd_lsn)
    for i in range(0, len(data), DIRENT_SIZE):
        entry = data[i:i+DIRENT_SIZE]
        if len(entry) < DIRENT_SIZE:
            break
        entry_lsn = lsn3(entry, DIRENT_LSN_OFF)
        if entry_lsn == 0:
            continue
        if entry_lsn * SECTOR_SIZE >= img_size:
            continue
        name = os9name(entry[0:DIRENT_NAME_LEN])
        if not name or set(name) <= {'.'}:
            continue
        yield name, entry_lsn

def get_image_size(img):
    pos = img.tell()
    img.seek(0, 2)
    size = img.tell()
    img.seek(pos)
    return size

def is_directory(img, fd_lsn):
    if fd_lsn == 0 or fd_lsn * SECTOR_SIZE >= get_image_size(img):
        return False
    fd = read_sector(img, fd_lsn)
    return bool(fd[FD_ATT] & 0x80)

def navigate_path(img, root_fd_lsn, path):
    """Navigate to a path, return fd_lsn or None"""
    parts = [p for p in path.strip('/').split('/') if p]
    current_lsn = root_fd_lsn
    for part in parts:
        found = False
        for name, fd_lsn in read_dir_entries(img, current_lsn):
            if name.lower() == part.lower():
                current_lsn = fd_lsn
                found = True
                break
        if not found:
            return None
    return current_lsn

def parse_imgpath(imgpath):
    """Split 'image.vhd,some/path' into (imagefile, path)"""
    if ',' in imgpath:
        img_file, path = imgpath.split(',', 1)
    else:
        img_file = imgpath
        path = ''
    return img_file, path

def cmd_dir(imgpath, extended=False):
    img_file, path = parse_imgpath(imgpath)
    with open(img_file, 'rb') as img:
        dd = read_sector(img, 0)
        root_lsn = lsn3(dd, DD_DIR)
        target_lsn = navigate_path(img, root_lsn, path) if path else root_lsn
        if target_lsn is None:
            print(f"dir: path not found: {path}", file=sys.stderr)
            return
        if not is_directory(img, target_lsn):
            print(f"dir: not a directory: {path}", file=sys.stderr)
            return
        entries = sorted(read_dir_entries(img, target_lsn), key=lambda x: x[0].lower())
        if extended:
            print(f"{'Name':<20} {'LSN':>6} {'Size':>8} {'Dir':>4}")
            print('-' * 42)
            for name, fd_lsn in entries:
                fd = read_sector(img, fd_lsn)
                size = struct.unpack('>I', fd[FD_SIZ:FD_SIZ+4])[0]
                isdir = 'DIR' if fd[FD_ATT] & 0x80 else ''
                print(f"{name:<20} {fd_lsn:>6} {size:>8} {isdir:>4}")
        else:
            cols = 5
            col_w = 16
            names = [name for name, _ in entries]
            for i, name in enumerate(names):
                end = '\n' if (i+1) % cols == 0 or i == len(names)-1 else ''
                print(f"{name:<{col_w}}", end=end)
            if names and len(names) % cols != 0:
                print()

def cmd_copy(src_imgpath, dest):
    img_file, src_path = parse_imgpath(src_imgpath)
    
    # Determine if wildcard
    basename = src_path.split('/')[-1] if '/' in src_path else src_path
    dirpart  = '/'.join(src_path.split('/')[:-1]) if '/' in src_path else ''
    
    has_wildcard = '*' in basename or '?' in basename
    
    if not os.path.isdir(dest):
        os.makedirs(dest, exist_ok=True)
    
    with open(img_file, 'rb') as img:
        dd = read_sector(img, 0)
        root_lsn = lsn3(dd, DD_DIR)
        
        if has_wildcard:
            dir_lsn = navigate_path(img, root_lsn, dirpart) if dirpart else root_lsn
            if dir_lsn is None:
                print(f"copy: directory not found: {dirpart}", file=sys.stderr)
                return
            matched = 0
            for name, fd_lsn in read_dir_entries(img, dir_lsn):
                if fnmatch.fnmatch(name.lower(), basename.lower()):
                    if is_directory(img, fd_lsn):
                        continue
                    data = read_file_data(img, fd_lsn)
                    out_path = os.path.join(dest, name)
                    with open(out_path, 'wb') as f:
                        f.write(data)
                    print(f"copy: {src_imgpath.split(',')[0]},{(dirpart+'/' if dirpart else '')}{name} -> {out_path}")
                    matched += 1
            if matched == 0:
                print(f"copy: no files matched '{basename}'", file=sys.stderr)
        else:
            fd_lsn = navigate_path(img, root_lsn, src_path)
            if fd_lsn is None:
                print(f"copy: not found: {src_path}", file=sys.stderr)
                return
            if is_directory(img, fd_lsn):
                print(f"copy: {src_path} is a directory", file=sys.stderr)
                return
            data = read_file_data(img, fd_lsn)
            name = src_path.split('/')[-1]
            out_path = os.path.join(dest, name) if os.path.isdir(dest) else dest
            with open(out_path, 'wb') as f:
                f.write(data)
            print(f"copy: {src_path} -> {out_path}")

def _list_recurse(img, dir_lsn, path_prefix, visited=None, search=None):
    if visited is None:
        visited = set()
    if dir_lsn in visited:
        return
    visited.add(dir_lsn)
    try:
        entries = sorted(read_dir_entries(img, dir_lsn), key=lambda x: x[0].lower())
    except Exception:
        return
    for name, fd_lsn in entries:
        if not name or fd_lsn in visited:
            continue
        isdir = is_directory(img, fd_lsn)
        full_path = path_prefix + name + ('/' if isdir else '')
        if search is None or search.lower() in full_path.lower():
            print(full_path)
        if isdir:
            _list_recurse(img, fd_lsn, path_prefix + name + '/', visited, search)

def cmd_list(imgpath, search=None):
    """List all paths as full pathnames"""
    img_file, path = parse_imgpath(imgpath)
    with open(img_file, 'rb') as img:
        dd = read_sector(img, 0)
        root_lsn = lsn3(dd, DD_DIR)
        start_lsn = navigate_path(img, root_lsn, path) if path else root_lsn
        if start_lsn is None:
            print(f"list: path not found: {path}", file=sys.stderr)
            return
        prefix = (path.rstrip('/') + '/') if path else ''
        _list_recurse(img, start_lsn, prefix, search=search)

def cmd_tree(imgpath, ascii_mode=False, search=None):
    """Recursive directory tree"""
    img_file, path = parse_imgpath(imgpath)
    with open(img_file, 'rb') as img:
        dd = read_sector(img, 0)
        root_lsn = lsn3(dd, DD_DIR)
        start_lsn = navigate_path(img, root_lsn, path) if path else root_lsn
        if start_lsn is None:
            print(f"tree: path not found: {path}", file=sys.stderr)
            return
        if search is None:
            print(imgpath)
        _tree_recurse(img, start_lsn, '', ascii_mode=ascii_mode, search=search)

def _tree_recurse(img, dir_lsn, prefix, visited=None, ascii_mode=False, search=None):
    if visited is None:
        visited = set()
    if dir_lsn in visited:
        return
    visited.add(dir_lsn)
    try:
        entries = sorted(read_dir_entries(img, dir_lsn), key=lambda x: x[0].lower())
    except Exception:
        return
    if ascii_mode:
        end_conn, mid_conn, end_ext, mid_ext = '+-- ', '+-- ', '    ', '|   '
    else:
        end_conn, mid_conn, end_ext, mid_ext = '+-- ', '+-- ', '    ', '|   '
    for i, (name, fd_lsn) in enumerate(entries):
        if not name or fd_lsn in visited:
            continue
        is_last = (i == len(entries) - 1)
        connector = end_conn if is_last else mid_conn
        isdir = is_directory(img, fd_lsn)
        line = f"{prefix}{connector}{name}{'/' if isdir else ''}"
        if search is None or search.lower() in line.lower():
            print(line)
        if isdir:
            extension = end_ext if is_last else mid_ext
            _tree_recurse(img, fd_lsn, prefix + extension, visited, ascii_mode, search)

def usage():
    print(__doc__)
    sys.exit(1)

if __name__ == '__main__':
    if len(sys.argv) < 3:
        usage()
    cmd = sys.argv[1].lower()
    if cmd == 'dir':
        extended = '-e' in sys.argv
        imgpath = next(a for a in sys.argv[2:] if not a.startswith('-'))
        cmd_dir(imgpath, extended)
    elif cmd == 'copy':
        if len(sys.argv) < 4:
            usage()
        cmd_copy(sys.argv[2], sys.argv[3])
    elif cmd == 'tree':
        ascii_mode = '--ascii' in sys.argv or '-a' in sys.argv
        search = None
        for a in sys.argv[3:]:
            if not a.startswith('-'):
                search = a
                break
        imgpath = next(a for a in sys.argv[2:] if not a.startswith('-'))
        cmd_tree(imgpath, ascii_mode=ascii_mode, search=search)
    elif cmd == 'find':
        if len(sys.argv) < 4:
            print("Usage: find IMAGE[,path] pattern")
            sys.exit(1)
        imgpath = sys.argv[2]
        search = sys.argv[3]
        cmd_list(imgpath, search=search)
    elif cmd == 'list':
        # Flags -r (recursive) and -p (full path) accepted but ignored
        # — list is always recursive with full paths
        flags = [a for a in sys.argv[3:] if a.startswith('-')]
        args  = [a for a in sys.argv[2:] if not a.startswith('-')]
        imgpath = args[0] if args else usage()
        search  = args[1] if len(args) > 1 else None
        cmd_list(imgpath, search=search)
    else:
        usage()

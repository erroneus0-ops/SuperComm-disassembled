#!/usr/bin/env python3
"""
update_xroar.py -- Update local XRoar WASM files from manually downloaded copies.

Ciaran's server blocks automated downloads, so the workflow is:
  1. Visit https://www.6809.org.uk/xroar/online/ in your browser
  2. Open DevTools -> Network tab -> reload the page
  3. Right-click each file and "Save as" to a download folder:
       xroar.js, xroar.wasm, xroar-wasm.css, software.js, index.html
  4. Run this script pointing at that folder:
       python update_xroar.py C:\\Users\\Daniel\\Downloads\\xroar_new

Files updated automatically (safe to overwrite):
    xroar.wasm      -- always update together with xroar.js
    xroar.js        -- always update together with xroar.wasm
    xroar-wasm.css  -- XRoar CSS (we don't import this but keep it)
    software.js     -- online software catalog

Files NOT overwritten automatically:
    index.html      -- we have significant local modifications.
                       Downloaded as index.html.upstream and diffed.

Usage:
    python update_xroar.py <download_folder>
    python update_xroar.py <download_folder> --dry-run
"""

import sys
import hashlib
import difflib
import shutil
from pathlib import Path

LOCAL_DIR = Path(__file__).parent / 'wasm'

AUTO_UPDATE = [
    'xroar.js',
    'xroar.wasm',
    'xroar-wasm.css',
    'software.js',
]

def md5(data):
    return hashlib.md5(data).hexdigest()

def check_and_update(src, dst, dry_run=False):
    if not src.exists():
        print(f'  {src.name}: not found in download folder -- skipping')
        return False

    new_data = src.read_bytes()
    old_data = dst.read_bytes() if dst.exists() else None
    old_hash = md5(old_data) if old_data else None
    new_hash = md5(new_data)

    if old_hash == new_hash:
        print(f'  {src.name}: up to date')
        return False

    size_change = ''
    if old_data:
        diff = len(new_data) - len(old_data)
        size_change = f'  ({diff:+,} bytes)'

    if dry_run:
        print(f'  {src.name}: WOULD UPDATE{size_change}')
        return True

    shutil.copy2(src, dst)
    print(f'  {src.name}: updated{size_change}')
    return True

def handle_index_html(src_dir, dry_run=False):
    src           = src_dir / 'index.html'
    upstream_prev = LOCAL_DIR / 'index.html.upstream'

    print(f'\nChecking index.html (upstream only -- our version not touched):')

    if not src.exists():
        print(f'  index.html not found in download folder -- skipping')
        print(f'  (save index.html from browser to see upstream diff)')
        return

    new_data = src.read_bytes()
    new_hash = md5(new_data)
    old_hash = md5(upstream_prev.read_bytes()) if upstream_prev.exists() else None

    if old_hash == new_hash:
        print(f'  index.html.upstream: up to date (no upstream changes)')
        return

    if dry_run:
        print(f'  index.html.upstream: WOULD UPDATE')
        return

    if upstream_prev.exists():
        old_text = upstream_prev.read_text(encoding='utf-8', errors='replace').splitlines()
        new_text = new_data.decode('utf-8', errors='replace').splitlines()

        diff = list(difflib.unified_diff(
            old_text, new_text,
            fromfile='index.html.upstream (previous)',
            tofile='index.html.upstream (new)',
            lineterm=''
        ))

        if diff:
            diff_file = LOCAL_DIR / 'index.html.upstream.diff'
            diff_file.write_text('\n'.join(diff), encoding='utf-8')
            print(f'  Ciaran changed {len(diff)} lines in index.html.')
            print(f'  Diff written to: {diff_file.name}')
            print(f'  Review and manually apply relevant changes to index.html.')

            print('\n  First 40 diff lines:')
            print('  ' + '-' * 60)
            for line in diff[:40]:
                print(f'  {line}')
            if len(diff) > 40:
                print(f'  ... ({len(diff) - 40} more lines -- see diff file)')
            print('  ' + '-' * 60)
        else:
            print(f'  index.html.upstream: no meaningful changes')
    else:
        print(f'  index.html.upstream: saved (first time -- no previous to diff against)')

    shutil.copy2(src, upstream_prev)
    print(f'  index.html.upstream updated.')

def main():
    dry_run = '--dry-run' in sys.argv
    args    = [a for a in sys.argv[1:] if not a.startswith('--')]

    if not args:
        print(__doc__)
        sys.exit(0)

    src_dir = Path(args[0])
    if not src_dir.is_dir():
        print(f'ERROR: not a directory: {src_dir}')
        sys.exit(1)

    if dry_run:
        print('DRY RUN -- no files will be written\n')

    print(f'Source:      {src_dir}')
    print(f'Destination: {LOCAL_DIR}\n')

    print('Checking auto-update files:')
    updated = []
    for filename in AUTO_UPDATE:
        if check_and_update(src_dir / filename, LOCAL_DIR / filename, dry_run):
            updated.append(filename)

    wasm_updated = 'xroar.wasm' in updated
    js_updated   = 'xroar.js'   in updated
    if wasm_updated != js_updated:
        print('\nWARNING: xroar.wasm and xroar.js should always be updated together.')
        print('One changed but not the other -- verify both are from the same build.')

    handle_index_html(src_dir, dry_run)

    print('\nDone.')

if __name__ == '__main__':
    main()

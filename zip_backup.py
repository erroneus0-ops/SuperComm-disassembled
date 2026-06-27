#!/usr/bin/env python3
"""
zip_backup.py -- Smart backup with incremental zip-file filtering.

Rules:
  Non-zip files:   always included.
  .zip files:      only included if newer than the most recent backup,
                   OR if running a full backup (--full flag).

Usage:
    python zip_backup.py              incremental backup (default)
    python zip_backup.py --full       full backup, include all files
    python zip_backup.py --dry-run    show what would be included, no zip created

Configuration (edit below):
    SOURCE_DIR   directory to back up
    BACKUP_DIR   where backup zips are saved
    MAX_BACKUPS  how many backups to keep (oldest deleted beyond this)
    PREFIX       backup filename prefix
    LOG_FILE     path to log file (set to None to disable)
"""

import os
import sys
import zipfile
import logging
from pathlib import Path
from datetime import datetime

# ── Configuration ─────────────────────────────────────────────────────────────

SOURCE_DIR  = Path(r'D:\git\supercomm')
BACKUP_DIR  = Path(r'D:\git_backups')
MAX_BACKUPS = 20
PREFIX      = 'supercomm_'
LOG_FILE    = Path(r'D:\git\git_pull_log.txt')   # appends to same log as git pull
                                                   # set to None to disable

# ── Setup ──────────────────────────────────────────────────────────────────────

def setup_logging():
    handlers = [logging.StreamHandler()]
    if LOG_FILE:
        handlers.append(logging.FileHandler(LOG_FILE, encoding='utf-8'))
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s  %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S',
        handlers=handlers
    )

# ── Helpers ────────────────────────────────────────────────────────────────────

def last_backup_time():
    """Return mtime of the most recent backup file, or None if no backups exist."""
    zips = sorted(
        BACKUP_DIR.glob(f'{PREFIX}*.zip'),
        key=lambda p: p.stat().st_mtime,
        reverse=True
    )
    if zips:
        return zips[0].stat().st_mtime
    return None

def should_include(path, last_backup_mtime, full):
    """
    Decide whether to include a file in this backup.

    Non-zip files: always yes.
    .zip files:    yes if full backup, or if newer than last backup.
    """
    if path.suffix.lower() != '.zip':
        return True, 'included'
    if full:
        return True, 'included (full)'
    if last_backup_mtime is None:
        return True, 'included (first backup)'
    if path.stat().st_mtime > last_backup_mtime:
        return True, 'included (new zip)'
    return False, 'skipped (zip, unchanged)'

def rotate_backups():
    """Delete oldest backups beyond MAX_BACKUPS."""
    zips = sorted(
        BACKUP_DIR.glob(f'{PREFIX}*.zip'),
        key=lambda p: p.stat().st_mtime,
        reverse=True
    )
    to_delete = zips[MAX_BACKUPS:]
    for z in to_delete:
        logging.info(f'  removing old backup: {z.name}')
        z.unlink()
    return len(to_delete)

# ── Main ───────────────────────────────────────────────────────────────────────

def main():
    setup_logging()

    full    = '--full'    in sys.argv
    dry_run = '--dry-run' in sys.argv

    mode = 'FULL' if full else 'INCREMENTAL'
    logging.info(f'--- zip_backup starting ({mode}{", DRY RUN" if dry_run else ""}) ---')

    BACKUP_DIR.mkdir(parents=True, exist_ok=True)

    last_mtime = last_backup_time()
    if last_mtime:
        last_dt = datetime.fromtimestamp(last_mtime).strftime('%Y-%m-%d %H:%M:%S')
        logging.info(f'  last backup: {last_dt}')
    else:
        logging.info(f'  last backup: none (first run)')

    # Collect files
    included = []
    skipped  = []
    for file in SOURCE_DIR.rglob('*'):
        if not file.is_file():
            continue
        # Skip the .git directory entirely -- history lives on GitHub
        if '.git' in file.parts:
            continue
        inc, reason = should_include(file, last_mtime, full)
        if inc:
            included.append(file)
        else:
            skipped.append(file)

    logging.info(f'  files to include: {len(included)}  skipped: {len(skipped)}')

    if dry_run:
        logging.info('  dry run -- files that would be included:')
        for f in included:
            logging.info(f'    {f.relative_to(SOURCE_DIR.parent)}')
        logging.info('--- dry run complete ---')
        return

    if not included:
        logging.info('  nothing to back up.')
        logging.info('--- zip_backup done ---')
        return

    # Create zip
    stamp    = datetime.now().strftime('%Y%m%d_%H%M')
    zip_path = BACKUP_DIR / f'{PREFIX}{stamp}.zip'

    with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as zf:
        for file in included:
            arcname = file.relative_to(SOURCE_DIR.parent)
            zf.write(file, arcname)

    size_kb = zip_path.stat().st_size // 1024
    logging.info(f'  created: {zip_path.name}  ({size_kb:,} KB,  {len(included)} files)')

    # Rotate
    deleted = rotate_backups()
    if deleted:
        logging.info(f'  rotated: removed {deleted} old backup(s), kept {MAX_BACKUPS}')

    logging.info('--- zip_backup done ---')


if __name__ == '__main__':
    main()

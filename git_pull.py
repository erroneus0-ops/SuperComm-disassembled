#!/usr/bin/env python3
"""
git_pull.py -- Pull latest changes from GitHub.

Read-only operation. No authentication required for public repositories.
Logs to the shared git operations log file.

Usage:
    python git_pull.py

Configuration (edit below):
    REPO_DIR   local repository path
    GIT_EXE    full path to git executable (required -- not in system PATH)
    LOG_FILE   path to log file (set to None to disable)
"""

import subprocess
import logging
from pathlib import Path
from datetime import datetime

# ── Configuration ──────────────────────────────────────────────────────────────

REPO_DIR = Path(r'C:\DATA\supercomm')
GIT_EXE  = Path(r'C:\Program Files\Git\cmd\git.exe')
LOG_FILE = Path(r'C:\DATA\git_backup\git_pull_log.txt')

# ── Setup ──────────────────────────────────────────────────────────────────────

def setup_logging():
    handlers = [logging.StreamHandler()]
    if LOG_FILE:
        handlers.append(logging.FileHandler(LOG_FILE, encoding='utf-8'))
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s  %(message)s',
        datefmt='%d%b%Y %H:%M:%S',
        handlers=handlers
    )

# ── Main ───────────────────────────────────────────────────────────────────────

def main():
    setup_logging()

    now = datetime.now()
    logging.info(f'--- git pull starting ---')

    if not GIT_EXE.exists():
        logging.error(f'Git not found: {GIT_EXE}')
        return 1

    if not REPO_DIR.exists():
        logging.error(f'Repo not found: {REPO_DIR}')
        return 1

    result = subprocess.run(
        [str(GIT_EXE), '-C', str(REPO_DIR), 'pull', '--no-rebase'],
        capture_output=True,
        text=True
    )

    if result.stdout.strip():
        for line in result.stdout.strip().splitlines():
            logging.info(f'  {line}')

    if result.returncode == 0:
        logging.info('--- git pull done ---')
    else:
        if result.stderr.strip():
            for line in result.stderr.strip().splitlines():
                logging.error(f'  {line}')
        logging.error(f'--- git pull failed (exit {result.returncode}) ---')

    return result.returncode

if __name__ == '__main__':
    exit(main())

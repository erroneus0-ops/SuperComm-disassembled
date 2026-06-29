#!/usr/bin/env python3
"""
setup_tasks.py -- Install scripts and create Windows Scheduled Tasks via XML.

What this does:
  1. Copies operational Python scripts from the repo to the scripts folder.
  2. Prompts for the Windows user password (interactive, not stored in code).
  3. Verifies the password by running a simple schtasks query.
  4. Generates Task Scheduler XML for each job.
  5. Imports each task with: schtasks /create /xml /f

Tasks created:
  git pull          -- Daily 09:00, repeat every 8h for 1 day
  git backup daily  -- Daily 05:30, incremental (no --full)
  git backup weekly -- Weekly Sunday 05:30, full (--full)

Usage:
  python setup_tasks.py

Requirements:
  - Run from an elevated command prompt (Administrator) if UAC is enabled.
  - C:\\Users\\dhauck\\AppData\\Local\\Python\\bin\\python.exe must exist.
  - C:\\Program Files\\Git\\cmd\\git.exe must exist.
"""

import os
import sys
import shutil
import getpass
import subprocess
import tempfile
from pathlib import Path
from datetime import datetime

# ── Configuration ──────────────────────────────────────────────────────────────

REPO_DIR    = Path(r'C:\DATA\supercomm')
SCRIPTS_DIR = Path(r'C:\Users\dhauck\AppData\Local\scripts')
PYTHON_EXE  = Path(r'C:\Users\dhauck\AppData\Local\Python\bin\python.exe')
GIT_EXE     = Path(r'C:\Program Files\Git\cmd\git.exe')
LOG_FILE    = Path(r'C:\DATA\git_backup\git_pull_log.txt')
BACKUP_DIR  = Path(r'C:\DATA\git_backup')
GIT_DIR     = Path(r'C:\DATA\supercomm')

WINDOWS_USER = 'FINANCE\\dhauck'   # domain\user or just username

# Scripts to copy from repo to scripts folder
SCRIPTS_TO_COPY = [
    'git_pull.py',
    'zip_backup.py',
]

# ── Task definitions ────────────────────────────────────────────────────────────

def task_xml(name, description, program, arguments, user, password,
             trigger_xml):
    """Generate a Task Scheduler XML definition."""
    now = datetime.now()
    date_str = f"{now.year:04d}-{now.month:02d}-{now.day:02d}T{now.hour:02d}:{now.minute:02d}:{now.second:02d}"

    return f"""<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo>
    <Date>{date_str}</Date>
    <Description>{description}</Description>
  </RegistrationInfo>
  <Triggers>
{trigger_xml}
  </Triggers>
  <Principals>
    <Principal id="Author">
      <UserId>{user}</UserId>
      <LogonType>Password</LogonType>
      <RunLevel>LeastPrivilege</RunLevel>
    </Principal>
  </Principals>
  <Settings>
    <MultipleInstancesPolicy>IgnoreNew</MultipleInstancesPolicy>
    <DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
    <StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
    <AllowHardTerminate>true</AllowHardTerminate>
    <StartWhenAvailable>true</StartWhenAvailable>
    <RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
    <IdleSettings>
      <StopOnIdleEnd>false</StopOnIdleEnd>
      <RestartOnIdle>false</RestartOnIdle>
    </IdleSettings>
    <AllowStartOnDemand>true</AllowStartOnDemand>
    <Enabled>true</Enabled>
    <Hidden>false</Hidden>
    <RunOnlyIfIdle>false</RunOnlyIfIdle>
    <WakeToRun>false</WakeToRun>
    <ExecutionTimeLimit>PT3H</ExecutionTimeLimit>
    <Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
    <Exec>
      <Command>{program}</Command>
      <Arguments>{arguments}</Arguments>
    </Exec>
  </Actions>
</Task>"""


TASKS = [
    {
        'name':        'git pull',
        'description': 'Pull latest changes from GitHub every 8 hours',
        'program':     str(PYTHON_EXE),
        'arguments':   f'"{SCRIPTS_DIR / "git_pull.py"}"',
        'trigger':     """\
    <CalendarTrigger>
      <StartBoundary>2026-06-27T09:00:00</StartBoundary>
      <Enabled>true</Enabled>
      <ScheduleByDay>
        <DaysInterval>1</DaysInterval>
      </ScheduleByDay>
      <Repetition>
        <Interval>PT8H</Interval>
        <Duration>P1D</Duration>
        <StopAtDurationEnd>false</StopAtDurationEnd>
      </Repetition>
    </CalendarTrigger>""",
    },
    {
        'name':        'git backup daily',
        'description': 'Daily incremental backup of D:\\git (excludes .git folder)',
        'program':     str(PYTHON_EXE),
        'arguments':   f'"{SCRIPTS_DIR / "zip_backup.py"}"',
        'trigger':     """\
    <CalendarTrigger>
      <StartBoundary>2026-06-28T05:30:00</StartBoundary>
      <Enabled>true</Enabled>
      <ScheduleByDay>
        <DaysInterval>1</DaysInterval>
      </ScheduleByDay>
    </CalendarTrigger>""",
    },
    {
        'name':        'git backup weekly full',
        'description': 'Weekly full backup of D:\\git including .git history',
        'program':     str(PYTHON_EXE),
        'arguments':   f'"{SCRIPTS_DIR / "zip_backup.py"}" --full',
        'trigger':     """\
    <CalendarTrigger>
      <StartBoundary>2026-06-29T05:30:00</StartBoundary>
      <Enabled>true</Enabled>
      <ScheduleByDay>
        <DaysInterval>7</DaysInterval>
      </ScheduleByDay>
    </CalendarTrigger>""",
    },
]

# ── Helpers ────────────────────────────────────────────────────────────────────

def banner(msg):
    print(f'\n{"="*60}')
    print(f'  {msg}')
    print(f'{"="*60}')

def check(condition, msg):
    if not condition:
        print(f'\nERROR: {msg}')
        sys.exit(1)

def verify_password(user, password):
    """
    Verify password by using schtasks to query existing tasks.
    A correct password returns exit code 0.
    """
    print('  Verifying password...')
    result = subprocess.run(
        ['schtasks', '/query', '/fo', 'list'],
        capture_output=True,
        env={**os.environ, 'SCHTASKS_USER': user, 'SCHTASKS_PASS': password}
    )
    # schtasks /query doesn't take user/pass args -- use net use instead
    # Try: net use \\localhost with credentials (reliable local auth test)
    result = subprocess.run(
        ['net', 'use', r'\\localhost\IPC$', f'/user:{user}', password, '/persistent:no'],
        capture_output=True, text=True
    )
    # Clean up the connection regardless
    subprocess.run(['net', 'use', r'\\localhost\IPC$', '/delete', '/yes'],
                   capture_output=True)

    if result.returncode == 0:
        print('  Password verified.')
        return True
    else:
        print(f'  Password verification failed: {result.stderr.strip()}')
        return False

def import_task(name, xml_content, password):
    """Write XML to temp file and import with schtasks."""
    tmp = tempfile.NamedTemporaryFile(
        mode='w', suffix='.xml', encoding='utf-16', delete=False
    )
    try:
        tmp.write(xml_content)
        tmp.close()

        result = subprocess.run(
            ['schtasks', '/create', '/xml', tmp.name,
             '/tn', name, '/f',
             '/ru', WINDOWS_USER, '/rp', password],
            capture_output=True, text=True
        )

        if result.returncode == 0:
            print(f'  OK: {name}')
        else:
            print(f'  FAILED: {name}')
            print(f'    {result.stderr.strip()}')
        return result.returncode == 0
    finally:
        os.unlink(tmp.name)

# ── Main ───────────────────────────────────────────────────────────────────────

def main():
    banner('SuperComm Scheduled Task Setup')

    # Preflight checks
    check(PYTHON_EXE.exists(), f'Python not found: {PYTHON_EXE}')
    check(GIT_EXE.exists(),    f'Git not found: {GIT_EXE}')
    check(REPO_DIR.exists(),   f'Repo not found: {REPO_DIR}')

    # Step 1: Copy scripts
    banner('Step 1: Copy scripts to scripts folder')
    SCRIPTS_DIR.mkdir(parents=True, exist_ok=True)

    for script in SCRIPTS_TO_COPY:
        src = REPO_DIR / script
        dst = SCRIPTS_DIR / script
        check(src.exists(), f'Script not found in repo: {src}')
        shutil.copy2(src, dst)
        print(f'  Copied: {script}')
        print(f'    from: {src}')
        print(f'      to: {dst}')

    # Step 2: Get and verify password
    banner('Step 2: Windows credentials')
    print(f'  User: {WINDOWS_USER}')
    print()

    for attempt in range(3):
        password = getpass.getpass('  Password: ')
        if verify_password(WINDOWS_USER, password):
            break
        print(f'  Try {attempt + 2} of 3...' if attempt < 2 else '')
    else:
        print('\nERROR: Password verification failed 3 times. Aborting.')
        sys.exit(1)

    # Step 3: Create tasks
    banner('Step 3: Creating scheduled tasks')

    results = []
    for task in TASKS:
        xml = task_xml(
            name        = task['name'],
            description = task['description'],
            program     = task['program'],
            arguments   = task['arguments'],
            user        = WINDOWS_USER,
            password    = password,
            trigger_xml = task['trigger'],
        )
        ok = import_task(task['name'], xml, password)
        results.append((task['name'], ok))

    # Clear password from memory
    password = None

    # Summary
    banner('Summary')
    all_ok = True
    for name, ok in results:
        status = 'OK     ' if ok else 'FAILED '
        print(f'  {status} {name}')
        if not ok:
            all_ok = False

    print()
    if all_ok:
        print('  All tasks created successfully.')
        print('  Verify in Task Scheduler or: schtasks /query /fo list /tn "git pull"')
    else:
        print('  Some tasks failed. Check errors above.')

    print()

if __name__ == '__main__':
    main()

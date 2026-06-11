@echo off
cd /d C:\DATA\supercomm
echo.
echo Current status:
git status
echo.
set /p MSG="Commit message (Enter for default 'WIP: session updates'): "
if "%MSG%"=="" set MSG=WIP: session updates
git pull --no-rebase
git add -A
git commit -m "%MSG%"
git push
echo.
echo Done.
pause

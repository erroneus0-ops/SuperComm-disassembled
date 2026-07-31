@echo off
REM push_images.bat -- lightweight, dedicated push for screenshots/ only.
REM
REM Separate from git_update.bat on purpose: this is meant to be fast and
REM narrow -- snap a screenshot, drop it in screenshots/, run this, done.
REM It only ever touches the screenshots/ folder and the generated index,
REM never anything else in the repo, so it can't accidentally pick up
REM unrelated in-progress changes the way a full git_update.bat run might.
REM
REM Screenshots (and similar dropped-in files) are a real communication
REM channel between Daniel and Claude, not just a side workflow -- this
REM script exists to make that channel as low-friction as possible.

echo Regenerating screenshot index...
python make_screenshot_index.py
if errorlevel 1 (
    echo make_screenshot_index.py failed -- aborting, nothing pushed.
    exit /b 1
)

echo.
echo Staging screenshots/ only...
git add screenshots/

git diff --staged --quiet
if not errorlevel 1 (
    echo Nothing new in screenshots/ -- nothing to push.
    exit /b 0
)

echo.
echo Committing...
git commit -m "screenshots: push new image(s)"
if errorlevel 1 (
    echo Commit failed -- check git status manually.
    exit /b 1
)

echo.
echo Pulling with rebase (autostash) before push, in case anything else changed...
git pull --rebase --autostash
if errorlevel 1 (
    echo Pull --rebase failed -- resolve manually before pushing.
    echo git status:
    git status
    exit /b 1
)

echo.
echo Pushing...
git push
if errorlevel 1 (
    echo Push failed -- check git status/remote manually.
    exit /b 1
)

echo.
echo Done -- new screenshot(s) pushed.

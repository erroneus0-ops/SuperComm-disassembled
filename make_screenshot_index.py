"""
make_screenshot_index.py
Generates screenshots/index.html listing all images in the screenshots folder.
Run from the repo root before committing.
"""
import os
import datetime

SCREENSHOTS_DIR = os.path.join(os.path.dirname(__file__), 'screenshots')
IMAGE_EXTS = ('.png', '.jpg', '.jpeg', '.gif')

files = sorted([
    f for f in os.listdir(SCREENSHOTS_DIR)
    if f.lower().endswith(IMAGE_EXTS)
])

rows = ''.join(
    f'<li><a href="{f}">{f}</a></li>\n'
    for f in files
)

updated = datetime.datetime.now().strftime('%Y-%m-%d %H:%M')

html = f'''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Screenshots</title>
  <style>
    body {{ font-family: "Courier New", monospace; background: #1a1a1a; color: #e0e0e0; padding: 1.5rem; max-width: 800px; margin: 0 auto; }}
    h2 {{ color: #f0c060; margin-bottom: 0.25rem; }}
    p {{ color: #888; font-size: 0.85rem; margin-bottom: 1rem; }}
    ul {{ list-style: none; padding: 0; }}
    li {{ margin: 0.3rem 0; }}
    a {{ color: #5b9bd5; text-decoration: none; }}
    a:hover {{ text-decoration: underline; }}
  </style>
</head>
<body>
  <h2>Screenshots</h2>
  <p>Updated: {updated} &mdash; {len(files)} file(s)</p>
  <ul>
{rows}  </ul>
</body>
</html>'''

out_path = os.path.join(SCREENSHOTS_DIR, 'index.html')
with open(out_path, 'w') as f:
    f.write(html)

print(f'screenshots/index.html updated -- {len(files)} file(s):', flush=True)
for f in files:
    print(f'  {f}', flush=True)
if not files:
    print('  (no image files found)', flush=True)

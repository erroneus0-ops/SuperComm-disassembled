import markdown
import os

# Paths
input_file = 'fill_screen.md'
output_file = 'fill_screen_updated.html'

# Read Markdown
with open(input_file, 'r', encoding='utf-8') as f:
    md_text = f.read()

# Convert to HTML
html_body = markdown.markdown(md_text, extensions=['fenced_code', 'tables', 'toc'])

# HTML Template with AUTO-SWITCHING GitHub Styling
full_html = f"""<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Fill Screen Exercise</title>
    <!-- This CSS automatically switches between Light and Dark based on your OS setting -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.2.0/github-markdown.min.css">
    <style>
        body {{
            box-sizing: border-box;
            min-width: 200px;
            max-width: 980px;
            margin: 0 auto;
            padding: 45px;
        }}
        @media (max-width: 767px) {{
            .markdown-body {{
                padding: 15px;
            }}
        }}
        /* Ensure code blocks scroll nicely */
        pre {{
            overflow-x: auto; 
        }}
    </style>
</head>
<body class="markdown-body">
    {html_body}
</body>
</html>
"""

# Write HTML
with open(output_file, 'w', encoding='utf-8') as f:
    f.write(full_html)

print(f"Successfully converted {input_file} to {output_file}")
print("Theme will now auto-detect your system settings!")   
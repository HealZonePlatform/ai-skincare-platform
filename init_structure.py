import os
from pathlib import Path

root = Path.cwd()
for path, dirs, files in os.walk(root):
    level = path.replace(str(root), '').count(os.sep)
    indent = '│   ' * (level - 1) + '├── ' * (min(level, 1))
    print(f'{indent}{os.path.basename(path)}/')
    sub_indent = '│   ' * level + '├── '
    for f in sorted(files):
        size = Path(path) / f
        print(f'{sub_indent}{f}  ({size.stat().st_size} bytes)')
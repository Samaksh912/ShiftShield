import os
import re

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    if 'AppColors.' not in content:
        return

    # Replace AppColors. with context.colors.
    content = content.replace('AppColors.', 'context.colors.')

    # Simple hack to remove 'const ' from lines that now have context.colors.
    # It's better than nothing, but might need manual fixup.
    lines = content.split('\n')
    for i, line in enumerate(lines):
        if 'context.colors.' in line and 'const ' in line:
            lines[i] = re.sub(r'\bconst\s+', '', line)
    
    content = '\n'.join(lines)

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

def main():
    features_dir = os.path.join('lib', 'features')
    for root, _, files in os.walk(features_dir):
        for file in files:
            if file.endswith('.dart'):
                process_file(os.path.join(root, file))

if __name__ == '__main__':
    main()

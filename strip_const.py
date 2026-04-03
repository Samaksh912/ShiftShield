import os

def main():
    features_dir = os.path.join('lib', 'features')
    for root, _, files in os.walk(features_dir):
        for file in files:
            if file.endswith('.dart'):
                filepath = os.path.join(root, file)
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()

                # Just forcefully remove all `const ` that might be causing issues.
                # Actually, only removing `const ` before widgets that usually have context.colors
                # But it's safer to just replace all `const ` because `dart fix --apply` restores the valid ones!
                if 'context.colors' in content:
                    content = content.replace('const ', '')
                    with open(filepath, 'w', encoding='utf-8') as f:
                        f.write(content)

if __name__ == '__main__':
    main()

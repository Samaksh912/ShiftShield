import subprocess
import os
import re

def run_analyze():
    print("Running flutter analyze...")
    result = subprocess.run(["flutter", "analyze", "--machine"], capture_output=True, text=True, shell=True)
    return result.stdout.splitlines()

def fix_errors():
    max_iterations = 3
    for iteration in range(max_iterations):
        print(f"Iteration {iteration+1}")
        lines = run_analyze()
        
        file_modifications = {}
        issues_found = 0
        
        for line in lines:
            if not ('|' in line and (line.startswith('error') or line.startswith('warning') or line.startswith('info'))):
                continue
                
            parts = line.split('|')
            if len(parts) >= 8:
                severity = parts[0]
                error_code = parts[2].lower()
                filepath = parts[3]
                line_idx = int(parts[4]) - 1
                
                # Check for const related errors
                if error_code in ['invalid_constant', 'non_constant_default_value', 'const_initialized_with_non_constant_value']:
                    issues_found += 1
                    if filepath not in file_modifications:
                        with open(filepath, 'r', encoding='utf-8') as f:
                            file_modifications[filepath] = f.readlines()
                    
                    file_lines = file_modifications[filepath]
                    # Work backwards to find 'const'
                    for i in range(line_idx, max(-1, line_idx - 10), -1):
                        if i < len(file_lines):
                            if 'const ' in file_lines[i]:
                                # Replace the last occurrence of 'const '
                                # Using rsplit to replace only the last one
                                parts = file_lines[i].rsplit('const ', 1)
                                file_lines[i] = ''.join(parts)
                                break
                                
                elif error_code == 'instance_access_to_static_member' or error_code == 'static_access_to_instance_member':
                    # Sometimes `context.colors.onSurface` still appears as `AppColors.onSurface` due to failed replace?
                    # Or worse, we didn't import the file correctly.
                    issues_found += 1
                    if filepath not in file_modifications:
                        with open(filepath, 'r', encoding='utf-8') as f:
                            file_modifications[filepath] = f.readlines()
                    
                    # Ensure AppColors is replaced with context.colors
                    flines = file_modifications[filepath]
                    if 'AppColors.' in flines[line_idx]:
                        flines[line_idx] = flines[line_idx].replace('AppColors.', 'context.colors.')

        if issues_found == 0:
            print("No fixable const errors found!")
            break
            
        print(f"Fixing {issues_found} issues...")
        for filepath, f_lines in file_modifications.items():
            with open(filepath, 'w', encoding='utf-8') as f:
                f.writelines(f_lines)
                
if __name__ == '__main__':
    fix_errors()

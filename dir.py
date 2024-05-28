import os

def print_directory_structure(startpath, prefix=''):
    """Prints the directory structure in a nested ASCII form starting from startpath."""
    # Obtain the items in the directory, sorted by name
    entries = sorted(os.listdir(startpath))
    
    # Filter to ignore special files/folders and virtual environments
    ignore_list = ['.git', '.svn', 'venv', 'env', '.venv', 'dbt-env']
    entries = [e for e in entries if not e.startswith('.') and e not in ignore_list]

    # Filter to get directories only
    directories = [e for e in entries if os.path.isdir(os.path.join(startpath, e))]
    # Filter to get files only
    files = [e for e in entries if os.path.isfile(os.path.join(startpath, e))]
    
    # Count the total entries and prepare the pointers
    entries_len = len(directories) + len(files)
    pointers = ['├── ' for _ in range(entries_len)]
    if entries_len:
        pointers[-1] = '└── '
    
    # Print directories with recursive call
    for i, dirname in enumerate(directories):
        print(f"{prefix}{pointers[i]}{dirname}")
        # Recursively print the subdirectory structure
        new_prefix = prefix + ('│   ' if pointers[i] == '├── ' else '    ')
        print_directory_structure(os.path.join(startpath, dirname), new_prefix)

    # Print files
    for i, filename in enumerate(files, start=len(directories)):
        print(f"{prefix}{pointers[i]}{filename}")

# Default directory to the current working directory or a specified path
def main(directory=None):
    if directory is None:
        directory = os.getcwd()  # Default to the current working directory if not specified
    print(f"Directory structure for {directory}:")
    print_directory_structure(directory)

if __name__ == "__main__":
    import sys
    # Check if a path is provided as a command line argument
    path = sys.argv[1] if len(sys.argv) > 1 else None
    main(path)
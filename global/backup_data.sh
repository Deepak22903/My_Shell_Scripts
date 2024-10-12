
#!/bin/fish

# Prompt user for source and backup directories, using zoxide for navigation
read -P "Enter the source directory (or use zoxide shortcuts): " source_dir
z $source_dir
set source_dir (pwd)

read -P "Enter the backup directory (or use zoxide shortcuts): " backup_dir
z $backup_dir
set backup_dir (pwd)

# Exclude patterns
set excludes ".git" "env" "__pycache__" "node_modules" "*.log"

# Build the exclusion arguments
set exclude_args
for exclude in $excludes
    set exclude_args $exclude_args "--exclude=$exclude"
end

# Perform the backup using rsync to handle exclusions and avoid unnecessary copying
rsync -av $exclude_args $source_dir/ $backup_dir/

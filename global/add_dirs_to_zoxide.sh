
#!/bin/bash

# Check if zoxide is installed
if ! command -v zoxide &> /dev/null
then
    echo "zoxide could not be found. Please install it first."
    exit 1
fi

# Add all directories inside the current directory to zoxide
for dir in */; do
    if [ -d "$dir" ]; then
        zoxide add "$dir"
        echo "Added $dir to zoxide."
    fi
done

echo "All directories have been added to zoxide!"

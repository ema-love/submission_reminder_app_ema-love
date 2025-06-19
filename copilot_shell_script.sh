#!/bin/bash

echo "=== Submission Reminder App - Assignment Updater ==="
echo

# Function to find the submission reminder directory
find_app_directory() {
    # Look for directories matching the pattern submission_reminder_*
    local app_dirs=(submission_reminder_*)
    
    if [ ${#app_dirs[@]} -eq 0 ] || [ ! -d "${app_dirs[0]}" ]; then
        echo "Error: No submission reminder application directory found!"
        echo "Please run create_environment.sh first to set up the application."
        exit 1
    fi
    
    # If multiple directories exist, use the first one
    if [ ${#app_dirs[@]} -gt 1 ]; then
        echo "Warning: Multiple submission reminder directories found. Using: ${app_dirs[0]}"
    fi
    
    echo "${app_dirs[0]}"
}

# Find the application directory
app_dir=$(find_app_directory)
config_file="$app_dir/config/config.env"

# Check if config file exists
if [ ! -f "$config_file" ]; then
    echo "Error: Configuration file not found at $config_file"
    echo "Please ensure the application is properly set up."
    exit 1
fi

# Display current assignment
echo "Current configuration:"
echo "----------------------"
cat "$config_file"
echo

# Prompt user for new assignment name
read -p "Enter the new assignment name: " new_assignment

# Validate input
if [ -z "$new_assignment" ]; then
    echo "Error: Assignment name cannot be empty!"
    exit 1
fi

# Backup the original config file
cp "$config_file" "$config_file.backup"
echo "Backup created: $config_file.backup"

# Update the ASSIGNMENT value in config.env using sed
sed -i "s/^ASSIGNMENT=.*/ASSIGNMENT=\"$new_assignment\"/" "$config_file"

# Verify the change was made
if [ $? -eq 0 ]; then
    echo "Assignment updated successfully!"
    echo
    echo "New configuration:"
    echo "------------------"
    cat "$config_file"
    echo
else
    echo "Error: Failed to update assignment in config file"
    # Restore backup if update failed
    mv "$config_file.backup" "$config_file"
    exit 1
fi

# Ask user if they want to run the application now
echo -n "Do you want to run the application with the new assignment? (y/n): "
read -r run_app

if [[ "$run_app" =~ ^[Yy]$ ]]; then
    echo
    echo "=== Running Application with New Assignment ==="
    echo "Changing to application directory: $app_dir"
    
    # Change to app directory and run startup script
    cd "$app_dir" || {
        echo "Error: Could not change to application directory"
        exit 1
    }
    
    # Check if startup.sh exists and is executable
    if [ ! -f "./startup.sh" ]; then
        echo "Error: startup.sh not found in application directory"
        exit 1
    fi
    
    if [ ! -x "./startup.sh" ]; then
        echo "Making startup.sh executable..."
        chmod +x "./startup.sh"
    fi
    
    # Run the application
    ./startup.sh
fi

echo
echo "=== Copilot Script Completed ==="

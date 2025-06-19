#!/bin/bash

echo "=== Submission Reminder App Setup ==="
echo

# Prompt user for their name
read -p "Enter your name: " user_name

# Validate input
if [ -z "$user_name" ]; then
    echo "Error: Name cannot be empty!"
    exit 1
fi

# Create main directory
app_dir="submission_reminder_${user_name}"
echo "Creating application directory: $app_dir"

# Remove existing directory if it exists
if [ -d "$app_dir" ]; then
    echo "Warning: Directory $app_dir already exists. Removing it..."
    rm -rf "$app_dir"
fi

# Create directory structure
mkdir -p "$app_dir"
mkdir -p "$app_dir/app"
mkdir -p "$app_dir/modules"
mkdir -p "$app_dir/assets" 
mkdir -p "$app_dir/config"

echo "Directory structure created successfully!"

# Create config.env file
cat > "$app_dir/config/config.env" << 'EOF'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# Create functions.sh file
cat > "$app_dir/modules/functions.sh" << 'EOF'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

# Create reminder.sh file
cat > "$app_dir/reminder.sh" << 'EOF'
#!/bin/bash

# Source environment variables and helper functions
source ../config/config.env
source ../modules/functions.sh

# Path to the submissions file
submissions_file="../assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

# Create submissions.txt file with original data plus 5 additional students
cat > "$app_dir/assets/submissions.txt" << 'EOF'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Marcus, Shell Navigation, not submitted
Sarah, Git, submitted
Ahmed, Shell Navigation, not submitted
Elena, Shell Basics, not submitted
James, Git, not submitted
EOF

# Create startup.sh script
cat > "$app_dir/startup.sh" << 'EOF'
#!/bin/bash

# Startup script for Submission Reminder App
echo "=== Starting Submission Reminder Application ==="
echo "Initializing system..."
echo

# Check if required files exist
if [ ! -f "./config/config.env" ]; then
    echo "Error: config.env file not found!"
    exit 1
fi

if [ ! -f "./modules/functions.sh" ]; then
    echo "Error: functions.sh file not found!"
    exit 1
fi    

if [ ! -f "./assets/submissions.txt" ]; then
    echo "Error: submissions.txt file not found!"
    exit 1
fi

if [ ! -f "./reminder.sh" ]; then
    echo "Error: reminder.sh file not found!"
    exit 1
fi

echo "All required files found. Starting reminder system..."
echo

# Execute the reminder script
./reminder.sh

echo
echo "=== Application completed successfully ==="
EOF

# Make all .sh files executable
echo "Setting executable permissions for .sh files..."
find "$app_dir" -name "*.sh" -type f -exec chmod +x {} \;

echo
echo "=== Setup Complete! ==="
echo "Application directory created: $app_dir"
echo "Directory structure:"
echo "├── $app_dir/"
echo "│   ├── app/"
echo "│   │   └── reminder.sh"
echo "│   ├── config/"
echo "│   │   └── config.env"
echo "│   ├── modules/"
echo "│   │   └── functions.sh"
echo "│   ├── assets/"
echo "│   │   └── submissions.txt"
echo "│   └── startup.sh"
echo

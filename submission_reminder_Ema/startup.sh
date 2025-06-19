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

# Submission Reminder App

This is a shell script project that helps identify students who need to be reminded of their pending assignment submissions. It sets up the necessary environment, manages configuration, and runs the application.

## Author

* GitHub: ema-love
* Name: Akintayo Erioluwa Mercy


## Project Structure

After running the setup script, a directory named `submission`\*`reminder`\*ema  is created with the following structure:
submission_reminder_ema/
├── assets/
│   └── submissions.txt
├── config/
│   └── config.env
├── modules/
│   └── functions.sh
├── reminder.sh
├── startup.sh

## Scripts Overview

### `create_environment.sh`
- Prompts the user for their name.
- Creates the full project directory structure.
- Adds all required files to their correct locations.
- Sets executable permissions for all `.sh` files.

### `copilot_shell_script.sh`
- Prompts the user to enter a new assignment name.
- Automatically updates the `ASSIGNMENT` value inside `config/config.env`.
- Reruns `startup.sh` to display students who haven’t submitted the updated assignment.
  
  ### `startup.sh`
- Executes the main reminder logic.
- Reads from `submissions.txt` and `config.env` to show pending submissions.

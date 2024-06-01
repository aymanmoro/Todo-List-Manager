# Todo-List-Manager
The Todo List Manager is a command-line script written in Bash that empowers users to efficiently manage their todo tasks. It provides a range of functionalities to create, update, delete, show, list, search, backup, and restore tasks. 

# Overview

The Todo List Manager is a bash script that helps you manage your daily tasks efficiently. Each task has a unique identifier, a title, a description, a location, a due date, a due time, and a completion marker. The script provides functionalities to create, update, delete, show, list, and search tasks with ease. Additionally, it allows you to backup and restore tasks to ensure your data is safe.

# Features

# Create a Task:

Prompts the user to enter a title (required), due date (required), description (optional), location (optional), and due time (optional). The task is then added to the todo list.
Usage: Choose option 1 from the main menu.
# Update a Task:

Allows the user to update an existing task's title, due date, description, location, due time, and completion marker.
Usage: Choose option 2 from the main menu.
# Delete a Task:

Deletes a task based on the unique task ID provided by the user.
Usage: Choose option 3 from the main menu.
# Show a Task:
Displays all information about a specific task based on the task ID provided by the user.
Usage: Choose option 4 from the main menu.
# List Tasks of a Given Day:

Lists all tasks for a specified date, organized into completed and uncompleted sections.
Usage: Choose option 5 from the main menu.
# Search for a Task by Title or ID:

Searches for tasks based on a provided title or ID and displays matching results.
Usage: Choose option 6 from the main menu.
# List All Tasks:

Lists all tasks in the todo list with their details.
Usage: Choose option 7 from the main menu.
Display Today's Tasks:

Displays all tasks for the current day, organized into completed and uncompleted sections.
Usage: Choose option 8 from the main menu.
# Backup Tasks:

Creates a backup of the current todo list to a backup file.
Usage: Choose option 9 from the main menu.
# Restore Tasks:

Restores tasks from the backup file to the todo list.
Usage: Choose option 10 from the main menu.
# Exit:

Exits the Todo List Manager script.
Usage: Choose option 11 from the main menu.
# File Management
The script uses two text files to manage the tasks:

todo.txt: This file stores all the current tasks. Each task is stored in a specific format where the fields are separated by colons (:).
todo_backup.txt: This file serves as a backup for the todo.txt file. It ensures that tasks are not lost in case of accidental deletion or corruption of the primary file.
# Initialization:

When the script runs, it ensures that the todo.txt file exists by using the touch command. If the file does not exist, it creates an empty file.

# Ensure the todo file exists
Creating a Task:

When a new task is created, it is appended to the todo.txt file with a unique identifier and other details.
Updating a Task:

When a task is updated, the script reads the current details, allows the user to modify them, and then replaces the old entry with the updated one in the todo.txt file.
Deleting a Task:

When a task is deleted, it is removed from the todo.txt file using the sed command.
Backup and Restore:

The script automatically creates a backup of the todo.txt file whenever a task is created, updated, or deleted. This ensures that the latest state of the tasks is always saved.

The user can manually restore the tasks from the backup file using the restore option.

# Installation
  Clone the repository: git clone https://github.com/aymanmoro/todo-list-manager.git
# Navigate to the repository directory:

  
   cd todo-list-manager

# Make the script executable:

   chmod +x todo.sh

# Usage
Run the script using the following command:

   ./todo.sh

The script will display a menu with various options. Choose the appropriate option number to perform the desired action.

# Backup and Restore
The script automatically creates a backup of the todo list whenever a task is created, updated, or deleted.
You can manually backup and restore tasks using the respective options in the main menu.

# Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any improvements or bug fixes.

# License
This project is licensed under the MIT License. See the LICENSE file for more details.

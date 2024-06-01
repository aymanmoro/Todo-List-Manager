#!/bin/bash

TODO_FILE="todo.txt"
BACKUP_FILE="todo_backup.txt"

# Ensure the todo file exists
touch "$TODO_FILE"

# Generate a unique identifier for a new task
generate_id() {
    if [ -s "$TODO_FILE" ]; then
        awk -F: 'END {print $1+1}' "$TODO_FILE"
    else
        echo 1
    fi
}

# Create a task
create_task() {
    id=$(generate_id)
    read -p "Enter title (required): " title
    if [ -z "$title" ]; then
        echo "Title is required." >&2
        return
    fi
    read -p "Enter due date (required, format YYYY-MM-DD): " due_date
    if ! date -d "$due_date" "+%Y-%m-%d" &>/dev/null; then
        echo "Invalid due date format." >&2
        return
    fi
    read -p "Enter description (optional): " description
    read -p "Enter location (optional): " location
    read -p "Enter due time (optional, format HH:MM): " due_time
    if [ -n "$due_time" ] && ! date -d "$due_time" "+%H:%M" &>/dev/null; then
        echo "Invalid due time format." >&2
        return
    fi
    completion_marker=false

    echo "$id:$title:$description:$location:$due_date:$due_time:$completion_marker" >> "$TODO_FILE"
    echo "Task $id created successfully."
    backup_tasks
}

# Update a task
update_task() {
    read -p "Enter task ID to update: " task_id
    task=$(grep "^$task_id:" "$TODO_FILE")
    if [ -z "$task" ]; then
        echo "Task not found." >&2
        return
    fi

    IFS=":" read -r id current_title current_description current_location current_due_date current_due_time current_completion_marker <<< "$task"

    read -p "Enter title (current: $current_title): " title
    title=${title:-$current_title}
    read -p "Enter due date (current: $current_due_date): " due_date
    due_date=${due_date:-$current_due_date}
    if ! date -d "$due_date" "+%Y-%m-%d" &>/dev/null; then
        echo "Invalid due date format." >&2
        return
    fi
    read -p "Enter description (current: $current_description): " description
    description=${description:-$current_description}
    read -p "Enter location (current: $current_location): " location
    location=${location:-$current_location}
    read -p "Enter due time (current: $current_due_time): " due_time
    due_time=${due_time:-$current_due_time}
    if [ -n "$due_time" ] && ! date -d "$due_time" "+%H:%M" &>/dev/null; then
        echo "Invalid due time format." >&2
        return
    fi
    read -p "Is the task completed? (current: $current_completion_marker, y/n): " completion_marker
    case "$completion_marker" in
        y) completion_marker=true ;;
        n) completion_marker=false ;;
        *) completion_marker=$current_completion_marker ;;
    esac

    sed -i.bak "/^$task_id:/d" "$TODO_FILE"
    echo "$id:$title:$description:$location:$due_date:$due_time:$completion_marker" >> "$TODO_FILE"
    echo "Task $task_id updated successfully."
    backup_tasks
}

# Delete a task
delete_task() {
    read -p "Enter task ID to delete: " task_id
    if grep -q "^$task_id:" "$TODO_FILE"; then
        sed -i.bak "/^$task_id:/d" "$TODO_FILE"
        echo "Task $task_id deleted successfully."
        backup_tasks
    else
        echo "Task not found." >&2
    fi
}

# Show a task
show_task() {
    read -p "Enter task ID to show: " task_id
    task=$(grep "^$task_id:" "$TODO_FILE")
    if [ -z "$task" ]; then
        echo "Task not found." >&2
        return
    fi
    IFS=":" read -r id title description location due_date due_time completion_marker <<< "$task"
    echo -e "ID: $id\nTitle: $title\nDescription: $description\nLocation: $location\nDue Date: $due_date\nDue Time: $due_time\nCompleted: $completion_marker"
}

# List tasks of a given day
list_tasks_of_day() {
    read -p "Enter date (format YYYY-MM-DD): " date
    if ! date -d "$date" "+%Y-%m-%d" &>/dev/null; then
        echo "Invalid date format." >&2
        return
    fi

    echo "Tasks for $date"
    echo "================"
    
    completed_tasks=$(grep ":$date:.*:true$" "$TODO_FILE")
    uncompleted_tasks=$(grep ":$date:.*:false$" "$TODO_FILE")

    echo -e "\nCompleted tasks:"
    if [ -z "$completed_tasks" ]; then
        echo "None"
    else
        echo "$completed_tasks" | awk -F: '{printf "%-4s %-20s %-10s %-10s\n", $1, $2, $6, $5}'
    fi
    
    echo -e "\nUncompleted tasks:"
    if [ -z "$uncompleted_tasks" ]; then
        echo "None"
    else
        echo "$uncompleted_tasks" | awk -F: '{printf "%-4s %-20s %-10s %-10s\n", $1, $2, $6, $5}'
    fi
}

# Search for a task by title or ID
search_task() {
    read -p "Enter title or ID to search: " query
    tasks=$(grep -i ":$query\|^$query:" "$TODO_FILE")
    if [ -z "$tasks" ]; then
        echo "No tasks found matching the query." >&2
    else
        echo "Search results:"
        echo "==============="
        echo "$tasks" | awk -F: '{printf "%-4s %-20s %-10s %-10s\n", $1, $2, $6, $5}'
    fi
}

# List all tasks
list_all_tasks() {
    if [ ! -s "$TODO_FILE" ]; then
        echo "No tasks found." >&2
        return
    fi

    echo "All tasks:"
    echo "=========="
    awk -F: '{printf "%-4s %-20s %-10s %-10s %-10s %-10s\n", $1, $2, $5, $6, ($7=="true"?"Yes":"No"), ($4==""?"None":$4)}' "$TODO_FILE"
}

# List today's tasks (default action)
list_today_tasks() {
    today=$(date "+%Y-%m-%d")
    
    echo "Tasks for Today ($today)"
    echo "======================="
    
    completed_tasks=$(grep ":$today:.*:true$" "$TODO_FILE")
    uncompleted_tasks=$(grep ":$today:.*:false$" "$TODO_FILE")

    echo -e "\nCompleted tasks:"
    if [ -z "$completed_tasks" ]; then
        echo "None"
    else
        echo "$completed_tasks" | awk -F: '{printf "%-4s %-20s %-10s %-10s\n", $1, $2, $6, $5}'
    fi
    
    echo -e "\nUncompleted tasks:"
    if [ -z "$uncompleted_tasks" ]; then
        echo "None"
    else
        echo "$uncompleted_tasks" | awk -F: '{printf "%-4s %-20s %-10s %-10s\n", $1, $2, $6, $5}'
    fi
}

# Backup the todo file
backup_tasks() {
    cp "$TODO_FILE" "$BACKUP_FILE"
    echo "Tasks backed up successfully."
}

# Restore tasks from the backup
restore_tasks() {
    if [ -f "$BACKUP_FILE" ]; then
        cp "$BACKUP_FILE" "$TODO_FILE"
        echo "Tasks restored from backup."
    else
        echo "No backup found." >&2
    fi
}

# Main menu
main_menu() {
    echo "Todo List Manager"
    echo "================="
    echo "1. Create a task"
    echo "2. Update a task"
    echo "3. Delete a task"
    echo "4. Show a task"
    echo "5. List tasks of a given day"
    echo "6. Search for a task by title or ID"
    echo "7. List all tasks"
    echo "8. Display today's tasks"
    echo "9. Backup tasks"
    echo "10. Restore tasks"
    echo "11. Exit"
    read -p "Choose an option: " option
    case $option in
        1) create_task ;;
        2) update_task ;;
        3) delete_task ;;
        4) show_task ;;
        5) list_tasks_of_day ;;
        6) search_task ;;
        7) list_all_tasks ;;
        8) list_today_tasks ;;
        9) backup_tasks ;;
        10) restore_tasks ;;
        11) exit 0 ;;
        *) echo "Invalid option. Please try again." >&2 ;;
    esac
}

# Main loop
while true; do
    main_menu
done

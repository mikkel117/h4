#!/bin/bash

tput clear

col=$(tput cols)
menuText="1. vis PID 2. dræp en PID 3. 4. pc info 5. services 6. søg efter file 7. bruger/grupper info"

displayNav() {
    textLength=${#menuText}
    halfCol=$(( (col - textLength) / 2 ))
    tput cup 0 0
    printf '%*s\n' "$col" '' | tr ' ' '-'  # Top border
    tput cup 1 $half_col
    echo "$menuText"
    tput cup 2 0
    printf '%*s\n' "$col" '' | tr ' ' '-'  # Bottom border
}

displayPID(){
    echo "Currently Running Processes:"
    echo "============================="
    echo "PID    Command"
    #ps -ef
    ps -e -o pid=,comm=
    echo "============================="
    echo "Total number of processes: $(ps -e | wc -l)"
    echo "============================="
    echo "Press any key to continue..."
    read -n 1
    tput clear
}

killAPID(){
    echo "Enter the PID of the process you want to kill:"
    read -r pid
    echo "Are you sure you want to kill PID: $pid (y/n)?"
    read -r confirm
    if [ "$confirm" == "y" ]; then
        if kill $pid > /dev/null 2>/dev/null; then
            echo "Process $pid has been killed."
        else
            echo "Failed to kill process $pid."
        fi
    else
        echo "no action taken"
    fi
    echo "============================="
    echo "Press any key to continue..."
    read -n 1
    tput clear
}

displayContent() {
     case $1 in
        1) displayPID ;;
        2) killAPID ;;
        3) echo "PC info...";;
        4) echo "Showing services...";;
        5) echo "Søger efter fil...";;
        6) echo "Bruger/grupper info...";;
        *) echo "Ugyldigt valg!";;
    esac
}

while true; do
    displayNav
    tput cup 4 0
    echo "Vælg en mulighed (eller 'q' for at afslutte):"
    read -r choice

    if [ "$choice" == "q" ]; then
        break
    fi
    tput cup 4 0
    tput ed
    displayContent "$choice"

done

tput clear
echo "Farvel!"
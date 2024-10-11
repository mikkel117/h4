#!/bin/bash

tput clear

col=$(tput cols)
menuText="1. vis PID 2. dræp en PID 3. pc info 4. services 5. søg efter file 6. bruger/grupper info"

displayNav() {
    textLength=${#menuText}
    #maybe try this again later
    #halfCol=$(( (col - textLength) / 2 ))
    tput cup 0 0
    printf '%*s\n' "$col" '' | tr ' ' '-'  # Top border
    tput cup 1 0
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
    echo "tryk på en tast for at fortsætte..."
    read -n 1
}

killAPID(){
    echo "skrive et PID nummer for at dræbe den process:"
    read -r pid
    echo "Er du sikker på at du ville dræbe PID : $pid (y/n)?"
    read -r confirm
    if [ "$confirm" == "y" ]; then
        if kill $pid > /dev/null 2>/dev/null; then
            echo "Process $pid er blevet dræbt."
        else
            echo "Process $pid kunne ikke dræbes."
        fi
    else
        echo "dræbning af processen er blevet annulleret."
    fi
    echo "============================="
    echo "tryk på en tast for at fortsætte..."
    read -n 1
}

displayPCInfo(){
    echo "PC Information:"
    echo -e "\n=== CPU Information ===\n"
    echo "CPU model: $(lscpu | grep 'Model name:' | awk -F ':' '{print $2}' | xargs)"

    echo -e "\n=== Memory Information ===\n"
    total_ram=$(free -h | grep 'Mem:' | awk '{print $2}')
    used_ram=$(free -h | grep 'Mem:' | awk '{print $3}')
	echo "Total Ram: $total_ram"
	echo "Used Ram: $used_ram"
    echo -e "\n=== Disk Information === \n"
	disk_space=$(df -h --output=avail / | tail -n 1)
	echo "Available disk space: $disk_space"

    echo "============================="
    echo "tryk på en tast for at fortsætte..."
    read -n 1
}

displayContent() {
     case $1 in
        1) displayPID ;;
        2) killAPID ;;
        3) displayPCInfo;;
        4) echo "Showing services...";;
        5) echo "Søger efter fil...";;
        6) echo "Bruger/grupper info...";;
        *) echo "Ugyldigt valg!";;
    esac
}

while true; do
    tput clear
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

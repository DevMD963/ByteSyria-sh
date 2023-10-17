#!/bin/bash

colorize() {
    local color="$1"
    local text="$2"
    tput setaf "$color"
    echo -n "$text"
    tput sgr0
}

install_nmap_if_not_exist() {
    if ! command -v nmap &> /usr/bin/nmap; then
        colorize 3 "nmap is not installed. Installing...\n"
        sudo apt-get update
        sudo apt-get install nmap -y
    fi
}

check_open_ports() {
    colorize 4 "Checking open ports using nmap...\n"
    nmap -F --open localhost | awk '/^[0-9]/ {print $1"/"$3}' | tail -n +3 | column -t
}

display_server_info() {
    colorize 4 "Hostname: "
    echo "$(hostname)"
    colorize 4 "Kernel Version: "
    echo "$(uname -r)"
    colorize 4 "Uptime: "
    echo "$(uptime)"
    echo
}

calculate_server_usage() {
    top -b -n 1 | grep "Cpu(s)" | awk '{print "CPU Usage: " $2 + $4 "%"}'
    free -m | grep "Mem" | awk '{print "Memory Usage: " $3 "MB / " $2 "MB"}'
    df -h / | grep "/" | awk '{print "Disk Usage (Root): " $3 " / " $2 " (" $5 ")"}'
    echo
}

clear

colorize 2 "Byte Syria Security program\n\n"

read -p "Do you want to update your system? (Y/N): " update_choice
if [ "$update_choice" = "Y" ] || [ "$update_choice" = "y" ]; then
    colorize 3 "Updating your system...\n"
    sudo apt-get update
    sudo apt-get upgrade -y
fi

read -p "Do you want to perform a fast security check? (Y/N): " security_check_choice
if [ "$security_check_choice" = "Y" ] || [ "$security_check_choice" = "y" ]; then
    install_nmap_if_not_exist
    clear
    display_server_info
    check_open_ports
    calculate_server_usage
else
    clear
    display_server_info
    calculate_server_usage
fi

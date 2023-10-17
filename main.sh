#!/bin/bash

colorize() {
    local color="$1"
    local text="$2"
    tput setaf "$color"
    echo -n "$text"
    tput sgr0
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
display_server_info
calculate_server_usage
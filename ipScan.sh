#!/bin/bash

###############################################
############## Simple IP Scanner ##############
############## Made by CodeShark ##############
##############   Version - 1.2   ##############
###############################################

# Usage: ./ipScan.sh <ip-range>
# Example: ./ipScan.sh 10.2.1

function ctrl_c(){
    echo -e "\n\n[*] Saliendo...\n"
    tput cnorm
    exit 1
}

trap ctrl_c INT

function init(){
    echo
    echo -e "\t\t###############################################"
    echo -e "\t\t############## Simple IP Scanner ##############"
    echo -e "\t\t############## Made by CodeShark ##############"
    echo -e "\t\t##############   Version - 1.2   ##############"
    echo -e "\t\t###############################################"
}

function usage(){
	echo -e "\n\t[+] Usage: ipScan.sh <ip-range> <options>"
	echo -e "\n\t[+] Example: ipScan.sh 127.0.0"
    echo -e "\n\t[+] Example: ipScan.sh 127.0.0 -p\t Scan open ports in the range\n"
}

function scanPort(){
    ip_addr=$1

    for port in $(seq 1 65535); do
        timeout 1 bash -c "echo '' > /dev/tcp/$ip_addr/$port" &>/dev/null && echo -e "\n\tHost: $ip_addr \tPort: $port - OPEN" &
    done; wait
    echo
}

init

if [ $# -eq 0 ]; then
	echo -e "\n[!] No ip range supplied"
    usage
	exit 1
else
    ip_range=$1

	if [[ $ip_range =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then

        tput civis

        echo -e "\n[+] Scanning range: $ip_range.0/24\n"

        for ip in $(seq 1 254); do
            if [ "$#" -eq 2 ] && [ "$2" = "-p" ]; then
                timeout 1 bash -c "ping -c 1 $ip_range.$ip" &>/dev/null && echo -e "\tHost: $ip_range.$ip - ACTIVE" && scanPort "$ip_range.$ip" &
            else
                timeout 1 bash -c "ping -c 1 $ip_range.$ip" &>/dev/null && echo -e "\tHost: $ip_range.$ip - ACTIVE" &
            fi
        done; wait

        echo
        tput cnorm
        exit 0
    else
        echo -e "\n[!] Enter a valid range"
        usage
	    exit 1
    fi
fi
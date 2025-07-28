#!/usr/bin/env bash

#? List all interfaces and their *PRIMARY* IP addresses

echo
# List all interfaces except the excluded ones
for interface in $(ip link show | grep -vE 'lo|docker|veth|br-|virbr' | grep 'BROADCAST' | awk '{print $2}' | tr -d ':')
do
    # Fetch the IP addresses for the current interface
    ip_addresses=( $(ip addr show $interface | grep 'inet ' | awk '{print $2}' | cut -d/ -f1) )

    # Check if there are any IP addresses associated with this interface
    if [ ${#ip_addresses[@]} -gt 0 ]; then
        # Display the primary IP address
        echo -e "The IP address for interface \033[0;32m$interface\033[0m is: \033[0;31m${ip_addresses[0]}\033[0m\n"

        # Display the VIP, if there's more than one IP
        if [ ${#ip_addresses[@]} -gt 1 ]; then
            echo -e "\nThe VIP for \033[0;32m$interface\033[0m is: \033[0;31m${ip_addresses[1]}\033[0m\n"
        fi
    fi
done

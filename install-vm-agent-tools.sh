#!/usr/bin/env bash

#? Install VM tools based on the guest type

install_vm_tools()
{
    local VM_TOOLS="$1"
    sudo apt -y install "$VM_TOOLS"
    if [ $? -ne 0 ]; then
        echo "Failed to install VM agent/tools for guest type: $GUEST_TYPE"
        exit 1
    else
        echo "VM agent/tools installed successfully for guest type: $GUEST_TYPE"
        exit 0
    fi
    unset VM_AGENT_TOOLS, GUEST_TYPE
}

if [ -x /usr/bin/facter ]; then
    GUEST_TYPE=$(facter virtual)
    if [ -z "$GUEST_TYPE" ]; then
        echo -e "\nUnable to determine guest type. Supported types are: virtualbox, vmware, qemu, kvm.\n"
        exit 1
    fi
else
    sudo apt update -y -qq
    sudo apt install -y facter
    GUEST_TYPE=$(facter virtual)
    if [ -z "$GUEST_TYPE" ]; then
        echo -e "\nUnable to determine guest type. Supported types are: virtualbox, vmware, qemu, kvm.\n"
        exit 1
    fi
fi

if [ "$GUEST_TYPE" == "virtualbox" ]; then
    #! Install virtualbox-guest-additions
    echo -e "\nGuest type: VirtualBox. Install virtualbox-guest-additions\n"
    install_vm_tools "virtualbox-guest-additions-iso"
elif [ "$GUEST_TYPE" == "vmware" ]; then
    #! Install open-vm-tools
    echo -e "\nGuest type: VMware. Install open-vm-tools\n"
    install_vm_tools "open-vm-tools"
elif [ "$GUEST_TYPE" == "qemu" ]; then
    #! Install qemu-guest-agent
    echo -e "\nGuest type: QEMU. Install qemu-guest-agent\n"
            install_vm_tools "qemu-guest-agent"
elif [ "$GUEST_TYPE" == "kvm" ]; then
    #! Install qemu-guest-agent
    echo -e "\nGuest type: KVM. Install qemu-guest-agent\n"
    install_vm_tools "qemu-guest-agent"
fi

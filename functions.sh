#!/usr/bin/env bash

#! ABOUT: This script contains functions that can be used in other scripts.
#! It is designed to be sourced by other scripts to provide common functionality.
#! It is not intended to be run directly.

#? USAGE: add get_functions_script function to your script, to download and call

#^ bash -c "$(wget -nv -qLO - https://scripts.encyapps.com/src/func.sh)"

#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#*  DOWNLOAD AND SOURCE FUNCTIONS
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#

#! Add this function to your script to use any of the functions below

# get_functions_script()
# {
#     sudo rm -rf /tmp/func.sh
#     wget -qO- https://scripts.encyapps.com/src/func.sh > /tmp/func.sh
#     if [ $? -ne 0 ]; then
#         echo -e "\033[1;31m  X  \033[1;34mDownloading functions script\033[0m"
#         exit 1
#     else
#         echo -e "\033[1;32m  ✓  \033[1;34mDownloading functions script\033[0m"
#         source /tmp/func.sh
#     fi
# }
# get_functions_script
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#*  EXAMPLE SCRIPT STRUCTURE
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#! script_banner
# Optional pre-run task
#! set_user_info
    # main task title
    #^ task_banner "start" "Update unattended-upgrades config / ${MESSAGE}"
        # 1st task title
        #* task_title  "Update system"
            # 1st task, 1st sub_task
            #? subtask_title "Update apt with 'apt update' / ${MESSAGE}"
                # 1st task, 1st sub_task, task
                #~ apt update -qq -y
            # 1st task, 1st sub_task, task result
            #? subtask_exit_status "Updating apt / ${MESSAGE}"
            # 1st task, 2nd sub_task
            #? subtask_title "Upgrade system with 'apt full-upgrade' / ${MESSAGE}"
                # 1st task, 2nd sub_task, task
                #~ apt full-upgrade -qq -y
            # 1st task, 2nd sub_task, task result
            #? subtask_exit_status "Upgrading system /${MESSAGE}"
        # 1st task result
        #* task_exit_status "Updating system / ${MESSAGE}"
        # 2nd task title
        #* task_title  "Replace unattended-upgrades config /${MESSAGE}"
            # 2nd task, 1st sub task
            #? get_file ...
                #~ Downloads and installs/replaces a file
                # 2nd task, 1st sub task, get_file result
        # 2nd task result
        #* task_exit_status "Replacing unattended-upgrades config /${MESSAGE}"
        # 3rd task title
        #* task_title  "Restart unattended-upgrades service /${MESSAGE}"
                # 3rd task, 1st sub_task, task
                #~ systemctl restart unattended-upgrades
        # 3rd task result
        #* task_exit_status "Restarting unattended-upgrades service /${MESSAGE}"
    # main task result
    #^ task_banner "end"  "Updating unattended-upgrades config / ${MESSAGE}"
# script result banner
#! exit_and_display_status
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#*  Script Functions
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? Banners, Titles, Headers, Footers, Exit status, and Message functions
#^ script_banner "${TASK_TITLE}"                                        # ABOUT: Display a banner for the script
#^ task_banner "start" ""                                               # ABOUT: Display a banner for a task
#^ task_title ""                                                        # ABOUT: Display a title for a task
#^ subtask_title ""                                                     # ABOUT: Display a title for a subtask
#^ subtask_exit_status ""                                               # ABOUT: Display the exit status for a subtask
#^ task_exit_status ""                                                  # ABOUT: Display the exit status for a task
#^ task_banner "end" ""                                                 # ABOUT: Display a banner for the end of a task
#^ exit_and_display_status                                              # ABOUT: Exit the script and display the final status
#? Progress bars and spinners functions
#^ download_bar                                                         # ABOUT: Display a fake download progress bar to spice up the output
#^ spin                                                                 # ABOUT: Display a spinner while a command is running
#? User functions
#^ prompt_for_sudo                                                      # ABOUT: Prompt for sudo access
#^ run_as_root                                                          # ABOUT: Check if script is running as sudo/root
#^ set_user_info "USERNAME" "USER_UID" "USER_GID"                       # ABOUT: Get running user info and set USERNAME, USER_UID, and USER_GID
#^ discover_user_info                                                   # ABOUT: Discover user information
#? Prompts and query functions
#^ prompt_user_query "Title message" "Prompt message" "Exit message"    # ABOUT: Generic prompt for user input, set result to PROMPT_RESULT variable
#^ prompt_for_domain_info                                               # ABOUT: Prompt user for domain name, set result to ${DOMAIN_NAME}
#^ prompt_for_domain_user_info                                          # ABOUT: Prompt user for domain user, set result to ${DOMAIN_USER}
#? Set owner and permissions functions
#^ set_owner "/path/to/file_or_directory" "USER:GROUP"                  # ABOUT: Set owner and group for a file or directory
#^ set_permissions "/path/to/file_or_directory" "PERMISSIONS"           # ABOUT: Set permissions for a file or directory
#? Directory and file functions
#^ create_common_dir                                                    # ABOUT: Create common directories if they do not exist
#^ remove_directory "task/subtask" "/tmp/mydirectory"                   # ABOUT: Remove a directory
#^ remove_file "task/subtask" "/tmp/file.txt"                           # ABOUT: Remove a file
#^ create_directory "/path/to/directory"                                # ABOUT: Create directory if it does not exist
#^ create_file "/path/to/file"                                          # ABOUT: Create file if it does not exist
#? Shell functions
#^ reload_shell
#? Get file functions
#^ get_file "http://example.com/file" "/tmp" "/etc" "file_name" "644" "root:root"
#^ get_file "http://example.com/file" \                                 # wget file from url
#^          "/tmp" \                                                    # temporary directory to download file to
#^          "/etc" \                                                    # destination directory to copy file to
#^          "file_name" \                                               # destination file name
#^          "644" \                                                     # file permissions
#^          "root:root"                                                 # file owner and group
#? Package functions
#^ install_if_not_installed "package_name"                              # ABOUT: Install a package if it is not already installed
#^ install_package "package_name"                                       # ABOUT: Install a package
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#*  VARIABLES
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#*  COLORS
RED='\033[0;31m'           # Red              ${RED}
U_RED='\e\033[4;31m'       # U Line Red       ${U_RED}
B_RED='\033[1;31m'         # Bold Red         ${B_RED}
GREEN='\033[0;32m'         # Green            ${GREEN}
U_GREEN='\e\033[4;32m'     # U Line Green     ${U_GREEN}
B_GREEN='\033[1;32m'       # Bold Green       ${B_GREEN}
YELLOW='\033[0;33m'        # Yellow           ${YELLOW}
U_YELLOW='\e\033[4;33m'    # U Line Yellow    ${U_YELLOW}
B_YELLOW='\033[1;33m'      # Bold Yellow      ${B_YELLOW}
BLUE='\033[0;34m'          # Blue             ${BLUE}
U_BLUE='\e\033[4;34m'      # U Line Blue.     ${U_BLUE}
B_BLUE='\033[1;34m'        # Bold Blue        ${B_BLUE}
MAGENTA='\033[0;35m'       # Magenta          ${MAGENTA}
U_MAGENTA='\e\033[4;35m'   # U Line Magenta   ${U_MAGENTA}
B_MAGENTA='\033[1;35m'     # Bold Magenta     ${B_MAGENTA}
CYAN='\033[0;36m'          # Cyan             ${CYAN}
U_CYAN='\e\033[4;36m'      # U Line Cyan      ${U_CYAN}
B_CYAN='\033[1;36m'        # Bold Cyan        ${B_CYAN}
WHITE='\033[0;37m'         # White            ${WHITE}
U_WHITE='\e\033[4;37m'     # U Line White     ${U_WHITE}
B_WHITE='\033[1;37m'       # Bold White       ${B_WHITE}
BLACK='\033[0;30m'         # Black            ${BLACK}
U_BLACK='\e\033[4;30m'     # U Line Black.    ${U_BLACK}
B_BLACK='\033[1;30m'       # Bold Black       ${B_BLACK}
NC='\033[0m'               # No Color         ${NC}
#*  COMMAND EXIT CODE VARIABLE
EXIT_STATUS="0"
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#*  MANDITORY FUNCTIONS
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT:
#* USEAGE:
#* EXAMPLE:

script_banner() #? ABOUT: Display a banner for the script
{
    echo -e "${RED}-----------------------------------------------------------------${NC}${B_BLUE}"
    echo -e "   ${TASK_TITLE}"
    echo -e "${RED}-----------------------------------------------------------------${NC}${B_YELLOW}"
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT:
#* USEAGE:
#* EXAMPLE:

task_banner() #? ABOUT: Display a banner for a task
{
    local START_END="$1"
    local MSG="$2"
    local LAST_EXIT="${EXIT_STATUS}"
    if [ $START_END == "start" ]; then
        echo -e "\n${B_BLUE} - ${MSG}${NC}"
    elif [ $START_END == "end" ]; then
        if [ "$LAST_EXIT" -ne 0 ]; then
            echo -e "\n${B_RED}  ERROR: ${RED}${MSG}${NC}"
        else
            echo -e "\n${B_BLUE} - ${MSG}${NC}"
        fi
    fi
    sleep 0.40
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT:
#* USEAGE:
#* EXAMPLE:

task_title() #? ABOUT: Display a title for a task
{
    local TITLE="$1"
    echo -e "\n${B_BLUE}  >  ${BLUE}${TITLE}${NC}"
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT:
#* USEAGE:
#* EXAMPLE:

subtask_title()
{
    local TITLE="$1"
    echo -e "${B_BLUE}      * ${BLUE}${TITLE}${NC}"
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT:
#* USEAGE:
#* EXAMPLE:

subtask_exit_status()
{
    local LAST_EXIT="${EXIT_STATUS}"
    local MSG="$1"
    if [ $LAST_EXIT -ne 0 ]; then
        echo -e "${B_RED}      X ${RED}${MSG}${NC}"
        EXIT_STATUS="${LAST_EXIT}"
    else
        echo -e "${B_GREEN}      ✓ ${GREEN}${MSG}${NC}"
        EXIT_STATUS="${LAST_EXIT}"
    fi
    sleep 0.40
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT:
#* USEAGE:
#* EXAMPLE:

task_exit_status()
{
    local LAST_EXIT="${EXIT_STATUS}"
    local MSG="$1"
    if [ $LAST_EXIT -ne 0 ]; then
        echo -e "${B_RED}  X  ${RED}ERROR: ${MSG}${NC}"
        EXIT_STATUS="${LAST_EXIT}"
    else
        echo -e "${B_GREEN}  ✓  ${GREEN}SUCCESS: ${MSG}${NC}"
        EXIT_STATUS="${LAST_EXIT}"
    fi
    sleep 0.40
}

#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT: Exit script and display message and exit status. Message is set using
#?        MESSAGE variable.
#* USEAGE: exit_and_display_status
#* EXAMPLE: exit_and_display_status

exit_and_display_status()
{
    local LAST_EXIT="$EXIT_STATUS"
    echo -e "\n${RED}-----------------------------------------------------------------${NC}"
    if [ $EXIT_STATUS -ne 0 ]; then
        echo -e "${B_RED} ERROR: ${NC}${RED}${MESSAGE}${NC}${RED}${NC}"
        LAST_EXIT="1"
    else
        echo -e "${B_GREEN} SUCCESS: ${NC}${GREEN}${MESSAGE}${NC}${GREEN}${NC}"
        LAST_EXIT="0"
    fi
    echo -e "${B_YELLOW} Exit CODE: ${YELLOW}${EXIT_STATUS}${NC}"
    echo -e "${RED}-----------------------------------------------------------------${NC}\n"
    unset_script_variables
    rm -rf /tmp/func.sh > /dev/null 2>&1
    exit 0
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT: Unset script variables
#* USEAGE: unset_script_variables
#* EXAMPLE: unset_script_variables

unset_script_variables()
{
    unset URL
    unset FILE
    unset DIR
    unset TEMP_DIR
    unset MOD
    unset OWN
    unset USERNAME
    unset USER_UID
    unset USER_GID
    unset EXIT_STATUS
    unset MESSAGE
    unset TASK_TITLE
    unset TITLE
    unset DOMAIN_NAME
    unset FQDN
    unset DOMAIN_USER
    unset LAST_EXIT
    unset MSG
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT:
#* USEAGE:
#* EXAMPLE:

# example()
# {

# }
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#*  OPTIONAL FUNCTIONS
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT: Check if script is running as sudo/root
#* USEAGE: run_as_root
#* EXAMPLE: run_as_root

prompt_for_sudo()
{
    sudo echo
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT: Check if script is running as sudo/root
#* USEAGE: run_as_root
#* EXAMPLE: run_as_root

run_as_root()
{
    task_title "Checking if script is run as root"
    
    if [ "$(id -u)" -ne 0 ]; then
        EXIT_STATUS="1"
        MESSAGE="This script must be run as root."
        exit_and_display_status "This script must be run as root."
    else
        EXIT_STATUS="0"
        task_exit_status "Running script as root."
    fi
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT: Get running user info and set USERNAME, USER_UID, and USER_GID
#* USEAGE: set_user_info
#* EXAMPLE: set_user_info

set_user_info()
{
    local SET_USERNAME="$1"
    local SET_UID="$2"
    local SET_GID="$3"

    task_banner "start" "Set Username, UID, and GID"

    if [ -z "$SET_USERNAME" ] || [ -z "$SET_UID" ] || [ -z "$SET_GID" ]; then
        echo -e "${B_YELLOW}"
        read -rp "Username: " SET_USERNAME
        echo
        read -rp "UID: " SET_UID
        echo
        read -rp "GID: " SET_GID
        echo -e "${NC}"
        USERNAME="${SET_USERNAME}"
        USER_UID="${SET_UID}"
        USER_GID="${SET_GID}"
    else
        echo -e "${B_YELLOW}Using the following information:${NC}"
        USERNAME="${SET_USERNAME}"
        USER_UID="${SET_UID}"
        USER_GID="${SET_GID}"
    fi
    echo -e "\n${B_YELLOW}       * USER: ${B_MAGENTA}${USERNAME}${NC}"
    echo -e "${B_YELLOW}       * UID:  ${B_MAGENTA}${USER_UID}${NC}"
    echo -e "${B_YELLOW}       * GID:  ${B_MAGENTA}${USER_GID}${NC}\n"
    
    task_banner "end" "Set Username, UID, and GID"
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT: Get running user info and set USERNAME, USER_UID, and USER_GID
#* USEAGE: set_user_info
#* EXAMPLE: set_user_info

discover_user_info()
{
    task_banner "start" "Discover current user information"

    USERNAME="$(id -un)"
    USER_UID="$(id -u)"
    USER_GID="$(id -g)"
    echo -e "\n${B_YELLOW}       * USER: ${B_MAGENTA}${USERNAME}${NC}"
    echo -e "${B_YELLOW}       * UID:  ${B_MAGENTA}${USER_UID}${NC}"
    echo -e "${B_YELLOW}       * GID:  ${B_MAGENTA}${USER_GID}${NC}\n"
    
    task_banner "end" "Discover current user information"
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT: Prompt for user input, set result to PROMT_RESULT variable
#* USEAGE: prompt_for_user_query_info "Title message" "Prompt message" "Exit message"
#* EXAMPLE: prompt_for_user_query_info "Please enter download URL" "URL" "URL set to: ${PROMPT_RESULT}"

prompt_user_query()
{
    local TITLE_MSG="$1"
    local PROMPT_MSG="$2"
    local EXIT_MSG="$3"
    
    #? PROMPT USER FOR INPUT
    task_banner "start" "${TITLE_MSG}"
    echo -e "${B_YELLOW}"
    read -rp "${PROMPT_MSG}: " PROMPT_RESULT
    echo -e "${NC}"
    task_banner "end" "${EXIT_MSG}"
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT: Prompt user for domain name, set result to ${DOMAIN_NAME}
#* USEAGE: prompt_for_domain_info
#* EXAMPLE: prompt_for_domain_info

prompt_for_domain_info()
{
    local RESULT_DOMAIN
    
    #? PROMPT FOR DOMAIN
    task_banner "start" "Please enter Active Directory Domain name you wish to join"
    echo -e "${B_YELLOW}"
    read -rp "FQDN of DOMAIN: " RESULT_DOMAIN
    echo -e "${NC}"
    DOMAIN_NAME="${RESULT_DOMAIN}"
    task_banner "end" "Domain name set to: ${CYAN}${DOMAIN_NAME}"
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT: Prompt user for domain user, set result to ${DOMAIN_USER}
#* USEAGE: prompt_for_domain_user_info
#* EXAMPLE: prompt_for_domain_user_info

prompt_for_domain_user_info()
{
    local RESULT_USERNAME

    #? PROMPT FOR DOMAIN USER
    task_banner "start" "Please enter Active Directory user name used to join the Active Directory Domain"
    echo -e "${B_YELLOW}"
    read -rp "Username: " RESULT_USERNAME
    echo -e "${NC}"
    DOMAIN_USER="${RESULT_USERNAME}"
    task_banner "end" "Domain user set to: ${CYAN}${DOMAIN_USER}"
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT: Create common directories if they do not exist. Run discover_user_info
#?        or set_user_info before to set USERNAME, USER_UID, USER_GID
#* USEAGE: create_common_dir
#* EXAMPLE: create_common_dir

create_common_dir()
{
    task_banner "start" "Checking if common directories"

    #? ~/.config
    # subtask_title "~/.config, creating if not found"
    create_directory "/home/${USERNAME}/.config"
    # if [ -d "${HOME}/.config" ]; then
    #     EXIT_STATUS="0"
    #     subtask_exit_status "Directory already exists"
    # else
    #     \mkdir -p ~/.config
    #     if [ -d "${HOME}/.config" ]; then
    #         EXIT_STATUS="0"
    #         subtask_exit_status "Directory created successfully"
    #     else
    #         EXIT_STATUS="1"
    #         subtask_exit_status "Failed to create directory"
    #     fi
    # fi

    #? ~/.local, ~/.local/bin, ~/.local/share, ~/.local/share/nano
    # subtask_title "~/.local, creating if not found"
    create_directory "/home/${USERNAME}/.local/bin"
    set_owner "/home/${USERNAME}/.local" "${USER_UID}:${USER_GID}"
    set_owner "/home/${USERNAME}/.local/bin" "${USER_UID}:${USER_GID}"
    create_directory "/home/${USERNAME}/.local/share/nano"
    set_owner "/home/${USERNAME}/.local" "${USER_UID}:${USER_GID}"
    set_owner "/home/${USERNAME}/.local/share" "${USER_UID}:${USER_GID}"
    set_owner "/home/${USERNAME}/.local/share/nano" "${USER_UID}:${USER_GID}"
    # if [ -d "${HOME}/.local" ]; then
    #     EXIT_STATUS="0"
    #     subtask_exit_status "Directory already exists"
    # else
    #     \mkdir -p ~/.local/share
    #     \mkdir -p ~/.local/bin
    #     \mkdir -p ~/.local/share/nano
    #     if [ -d "${HOME}/.local" ]; then
    #         EXIT_STATUS="0"
    #         subtask_exit_status "Directory created successfully"
    #     else
    #         EXIT_STATUS="1"
    #         subtask_exit_status "Failed to create directory"
    #     fi
    # fi

    #? ~/.scripts
    # subtask_title "~/.scripts, creating if not found"
    create_directory "/home/${USERNAME}/.scripts/portgen"
    set_owner "/home/${USERNAME}/.scripts" "${USER_UID}:${USER_GID}"
    set_owner "/home/${USERNAME}/.scripts/portgen" "${USER_UID}:${USER_GID}"
    # if [ -d "${HOME}/.scripts" ]; then
    #     EXIT_STATUS="0"
    #     subtask_exit_status "Directory already exists"
    # else
    #     \mkdir -p ~/.scripts
    #     if [ -d "${HOME}/.scripts" ]; then
    #         EXIT_STATUS="0"
    #         subtask_exit_status "Directory created successfully"
    #     else
    #         EXIT_STATUS="1"
    #         subtask_exit_status "Failed to create directory"
    #     fi
    # fi

    #? ~/.backup_configs
    # subtask_title "~/.backup_configs, creating if not found"
    create_directory "/home/${USERNAME}/.backup_configs"
    set_owner "/home/${USERNAME}/.backup_configs" "${USER_UID}:${USER_GID}"
    # if [ -d "${HOME}/.backup_configs" ]; then
    #     EXIT_STATUS="0"
    #     subtask_exit_status "Directory already exists"
    # else
    #     \mkdir -p ~/.backup_configs
    #     if [ -d "${HOME}/.backup_configs" ]; then
    #         EXIT_STATUS="0"
    #         subtask_exit_status "Directory created successfully"
    #     else
    #         EXIT_STATUS="1"
    #         subtask_exit_status "Failed to create directory"
    #     fi
    # fi

    #? ~/.ssh
    # subtask_title "~/.ssh, creating if not found"
    create_directory "/home/${USERNAME}/.ssh"
    set_permissions "/home/${USERNAME}/.ssh" 700
    set_owner "/home/${USERNAME}/.ssh" "${USER_UID}"
    create_file "/home/${USERNAME}/.ssh/authorized_keys"
    set_permissions "/home/${USERNAME}/.ssh/authorized_keys" 600
    set_owner "/home/${USERNAME}/.ssh/authorized_keys" "${USER_UID}"
    # if [ -d "${HOME}/.ssh" ]; then
    #     EXIT_STATUS="0"
    #     subtask_exit_status "Directory already exists"
    # else
    #     \mkdir -p ~/.ssh
    #     if [ -d "${HOME}/.ssh" ]; then
    #         EXIT_STATUS="0"
    #         subtask_exit_status "Directory created successfully"
    #     else
    #         EXIT_STATUS="1"
    #         subtask_exit_status "Failed to create directory"
    #     fi
    #     touch ~/.ssh/authorized_keys
    #     if [ -f "${HOME}/.ssh/authorized_keys" ]; then
    #         chmod 600 ~/.ssh/authorized_keys
    #         EXIT_STATUS="0"
    #         subtask_exit_status "File created successfully"
    #     else
    #         EXIT_STATUS="1"
    #         subtask_exit_status "Failed to create file"
    #     fi
    #     touch ~/.ssh/config
    #     if [ -f "${HOME}/.ssh/config" ]; then
    #         chmod 600 ~/.ssh/config
    #         EXIT_STATUS="0"
    #         subtask_exit_status "File created successfully"
    #     else
    #         EXIT_STATUS="1"
    #         subtask_exit_status "Failed to create file"
    #     fi
    # fi

    #? ~/.ssh/config.d
    # subtask_title "~/.ssh/config.d, creating if not found"
    create_directory "/home/${USERNAME}/.ssh/config.d"
    set_permissions "/home/${USERNAME}/.ssh/config.d" 700
    set_owner "/home/${USERNAME}/.ssh/config.d" "${USER_UID}:${USER_GID}"
    # if [ -d "${HOME}/.ssh/config.d" ]; then
    #     EXIT_STATUS="0"
    #     subtask_exit_status "Directory already exists"
    # else
    #     \mkdir -p ~/.ssh/config.d
    #     if [ -d "${HOME}/.ssh/config.d" ]; then
    #         EXIT_STATUS="0"
    #         subtask_exit_status "Directory created successfully"
    #     else
    #         EXIT_STATUS="1"
    #         subtask_exit_status "Failed to create directory"
    #     fi
    # fi
    task_banner "end" "Checking if common directories"
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT: Remove an existing directory and validate success
#* USEAGE: remove_directory <TASK_TYPE> <DIR_PATH>
#* EXAMPLE: remove_directory "task/subtask" "/tmp/mydirectory"

remove_directory()
{
    local TASK_TYPE="$1"
    local DIR_PATH="$2"
    local TASK_MSG=""
    local LAST_EXIT=""

    #? Check if output is as a task or subtask
    if [ "$TASK_TYPE" == "task" ]; then
        TASK_MSG="task"
    elif [ "$TASK_TYPE" == "subtask" ]; then
        TASK_MSG="subtask"
    else
        echo -e "${B_RED}Invalid task type: ${TASK_TYPE}${NC}"
        return 1
    fi
    #? Remove directory and exit with result
    "${TASK_MSG}"_title "Remove ${CYAN}${FILE_PATH}"
    if [ -d "${DIR_PATH}" ]; then
        sudo rm -rf "${DIR_PATH}" 2>/dev/null
        LAST_EXIT="$?"
        if [ "${LAST_EXIT}" -ne 0 ]; then
            EXIT_STATUS="${LAST_EXIT}"
            "${TASK_MSG}"_exit_status "Failed to remove: ${CYAN}${DIR_PATH}"
        else
            EXIT_STATUS="0"
            "${TASK_MSG}"_exit_status "Removed: ${CYAN}${DIR_PATH}"
        fi
    else
        EXIT_STATUS="0"
        "${TASK_MSG}"_exit_status "Directory ${CYAN}${DIR_PATH}${BLUE} does not exist, skipping"
    fi
    #? Unset variables just in case
    unset DIR_PATH
    unset LAST_EXIT
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT: Remove an existing file and validate success
#* USEAGE: remove_file <TASK_TYPE> <FILE_PATH>
#* EXAMPLE: remove_file "task/subtask" "/tmp/file.txt"

remove_file()
{
    local TASK_TYPE="$1"
    local FILE_PATH="$2"
    local TASK_MSG=""
    local LAST_EXIT=""

    #? Check if output is as a task or subtask
    if [ "$TASK_TYPE" == "task" ]; then
        TASK_MSG="task"
    elif [ "$TASK_TYPE" == "subtask" ]; then
        TASK_MSG="subtask"
    else
        echo -e "${B_RED}Invalid task type: ${TASK_TYPE}${NC}"
        return 1
    fi
    "${TASK_MSG}"_title "Remove ${CYAN}${FILE_PATH}"
    if [ -f "${FILE_PATH}" ]; then
        #? Remove file and exit with result
        sudo rm -rf "${FILE_PATH}" 2>/dev/null
        LAST_EXIT="$?"
        if [ "${LAST_EXIT}" -ne 0 ]; then
            EXIT_STATUS="${LAST_EXIT}"
            "${TASK_MSG}"_exit_status "Failed to remove: ${CYAN}${FILE_PATH}"
        else
            EXIT_STATUS="0"
            "${TASK_MSG}"_exit_status "Removed: ${CYAN}${FILE_PATH}"
        fi
    else
        EXIT_STATUS="0"
        "${TASK_MSG}"_exit_status "File ${CYAN}${FILE_PATH}${BLUE} does not exist, skipping"
    fi

    #? Unset variables just in case
    unset FILE_PATH
    unset LAST_EXIT
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT: Create file if they do not exist
#* USEAGE: create_file /path/to/file
#* EXAMPLE: create_file /tmp/myfile.txt

create_file()
{
    local FILE="$1"

    task_title "Create file if it does not exist: ${CYAN}${FILE}"
    
    subtask_title "Checking if file exists"
    #? Check if file exists
    if [ -f "${FILE}" ]; then
        EXIT_STATUS="0"
        subtask_exit_status "File already exists"
        task_exit_status "Existing file found"
    else
        subtask_title "File does not exist, creating now: ${CYAN}${FILE}"
        #? Create file and exit with result
        touch "${FILE}"
        if [ $? -ne 0 ]; then
            EXIT_STATUS="1"
            task_exit_status "Creating file: ${CYAN}${FILE}"
        else
            EXIT_STATUS="0"
            task_exit_status "Creating file: ${CYAN}${FILE}"
        fi
    fi
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT: Create directory if it does not exist
#* USEAGE: create_directory /path/to/directory
#* EXAMPLE: create_directory /tmp/directory

create_directory()
{
    local DIR="$1"
    
    task_title "Create directory if it does not exist: ${CYAN}${DIR}"
    
    subtask_title "Checking if directory exists"
    #? Check if directory exists
    if [ -d "${DIR}" ]; then
        EXIT_STATUS="0"
        subtask_exit_status "Directory already exists"
        task_exit_status "Existing directory found"
    else
        subtask_title "Directory does not exist, creating now: ${CYAN}${DIR}"
        #? make directory and exit with result
        \mkdir -p "${DIR}"
        if [ $? -ne 0 ]; then
            EXIT_STATUS="1"
            task_exit_status "Creating directory: ${CYAN}${DIR}"
        else
            EXIT_STATUS="0"
            task_exit_status "Creating directory: ${CYAN}${DIR}"
        fi
    fi
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT: Setting permissions on a directory or file
#* USEAGE: set_permissions /path/to/file <permissions>
#* EXAMPLE: set_permissions /etc/hosts 644

set_permissions()
{
    local TARGET="$1"
    local PERMISSIONS="$2"

    task_title "Setting permissions for ${CYAN}${TARGET}"

    subtask_title "Checking if ${CYAN}${TARGET}${B_BLUE} exists"
    if [ -e "${TARGET}" ]; then
        subtask_title "${CYAN}${TARGET}${B_BLUE} exists"
        #? Set permissions and exit with result
        sudo chmod "${PERMISSIONS}" "${TARGET}"
        EXIT_STATUS="$?"
        task_exit_status "Setting permissions for ${CYAN}${TARGET}"
    else
        EXIT_STATUS="1"
        task_exit_status "Setting permissions for ${CYAN}${TARGET}"
    fi
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT: Setting owner on a directory or file
#* USEAGE: set_owner /path/to/directory <owner>
#* EXAMPLE: set_owner /etc/hosts root:root

set_owner()
{
    local TARGET="$1"
    local OWNER="$2"

    task_title "Setting owner for ${CYAN}${TARGET}"

    subtask_title "Checking if ${CYAN}${TARGET}${B_BLUE} exists"
    if [ -e "${TARGET}" ]; then
        subtask_exit_status "${CYAN}${TARGET}${B_BLUE} exists"
        #? Set owner and exit with result
        sudo chown "${OWNER}" "${TARGET}"
        EXIT_STATUS="$?"
        task_exit_status "Setting owner: ${CYAN}${TARGET}"
    else
        EXIT_STATUS="1"
        subtask_exit_status "Not found: ${CYAN}${TARGET}"
        task_exit_status "Setting owner: ${CYAN}${TARGET}"
    fi
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT: Download file from URL, set permissions and owner, and install/replace
#?        existing file. Set EXIT_ON_FAILURE to true to exit script on failure
#* USEAGE: get_file <url> <temp_dir> <dir> <file> <mod> <own>
#* EXAMPLE: get_file "http://example.com/file" "/tmp" "/etc" "file" "644" "root:root"

get_file()
{
    local URL="$1"
    local TEMP_DIR="$2"
    local DIR="$3"
    local FILE="$4"
    local MOD="$5"
    local OWN="$6"
    local LAST_EXIT=""
    local EXIT_ON_FAIL="${EXIT_ON_FAILURE}"

    task_title "Download, set owner, set permissions and apply ${CYAN}${FILE}"

    #? Remove "temp" file from "temp" directory if it exists.
    subtask_title "Remove previous temp files in ${CYAN}${TEMP_DIR}"
    if [ -f "${TEMP_DIR}/${FILE}" ]; then
        sudo rm -rf "${TEMP_DIR}/${FILE}" > /dev/null 2>&1
        LAST_EXIT="$?"
        if [ "${LAST_EXIT}" -ne 0 ]; then
            EXIT_STATUS="${LAST_EXIT}"
            subtask_exit_status "Failed to remove previous ${CYAN}${TEMP_DIR}/${FILE}"
        fi
    else
        EXIT_STATUS="0"
        subtask_exit_status "No previous ${CYAN}${FILE}${GREEN} found in ${CYAN}${TEMP_DIR}"
    fi
    if [ -f "${TEMP_DIR}/${FILE}.bkup" ]; then
        sudo rm -rf "${TEMP_DIR}/${FILE}.bkup" > /dev/null 2>&1
        LAST_EXIT="$?"
        if [ "${LAST_EXIT}" -ne 0 ]; then
            EXIT_STATUS="${LAST_EXIT}"
            subtask_exit_status "Failed to remove previous ${CYAN}${TEMP_DIR}/${FILE}.bkup"
        fi
    else
        EXIT_STATUS="0"
        subtask_exit_status "No previous ${CYAN}${FILE}.bkup${GREEN} found in ${CYAN}${TEMP_DIR}"
    fi
    #? Download file
    subtask_title "Download ${CYAN}${FILE}${BLUE} from ${CYAN}${URL}${BLUE} to ${CYAN}${TEMP_DIR}"
    echo
    wget -O "${TEMP_DIR}/${FILE}" "${URL}" > /dev/null 2>&1
    LAST_EXIT="$?"
    for _ in {1..80}; do
        echo -ne "\e[31m▓\e[0m"
        sleep 0.01
    done
    echo -e "\n"
    if [ ! -f "${TEMP_DIR}/${FILE}" ]; then
        if [ "${EXIT_ON_FAIL}" = "true" ] && [ "${LAST_EXIT}" -ne 0 ]; then
            EXIT_STATUS="${LAST_EXIT}"
            MESSAGE="CRITICAL FAILURE - Failed to download ${CYAN}${FILE}${RED}, exiting script"
            exit_and_display_status
        elif [ "${EXIT_ON_FAIL}" = "false" ] && [ "${LAST_EXIT}" -ne 0 ]; then
            EXIT_STATUS="${LAST_EXIT}"
            subtask_exit_status "Failed to download ${CYAN}${FILE}${RED}. ${CYAN}${FILE}${RED} is marked as non critical, continuing script"
        fi
    else
        EXIT_STATUS="0"
        subtask_exit_status "Download successful"
    fi
    #? Modify permissions and owner
    subtask_title "Set permissions: ${CYAN}${TEMP_DIR}/${FILE}"
    if [ -f "${TEMP_DIR}"/"${FILE}" ]; then
        #? Modify permissions
        sudo chmod "${MOD}" "${TEMP_DIR}"/"${FILE}"
        LAST_EXIT="$?"
        if [ "${LAST_EXIT}" -ne 0 ]; then
            EXIT_STATUS="${LAST_EXIT}"
            subtask_exit_status "Failed to set owner on ${CYAN}${TEMP_DIR}/${FILE}${RED} to ${CYAN}${MOD}"
        else
            EXIT_STATUS="0"
            subtask_exit_status " Permissions set: ${CYAN}${MOD}"
            #? Modify owner
            subtask_title "Set owner: ${CYAN}${TEMP_DIR}/${FILE}"
            sudo chown "${OWN}" "${TEMP_DIR}/${FILE}"
            LAST_EXIT="$?"
            if [ "${LAST_EXIT}" -ne 0 ]; then
                EXIT_STATUS="${LAST_EXIT}"
                subtask_exit_status "Failed to set owner on ${CYAN}${TEMP_DIR}/${FILE}${RED} to ${CYAN}${OWN}"
            else
                EXIT_STATUS="0"
                subtask_exit_status "Owner set: ${CYAN}${OWN}"
            fi
        fi
    else
        EXIT_STATUS="1"
        MESSAGE="CRITICAL FAILURE - Failed to download ${CYAN}${FILE}${RED}, exiting script"
        exit_and_display_status
    fi
    #? Backup original file to temp directory and apend .bkup
    subtask_title "Backup original, if found, to ${CYAN}${TEMP_DIR}"
    if [ -f "${DIR}"/"$FILE" ]; then
        subtask_title "Backup original found, backing up to ${CYAN}${TEMP_DIR}/${FILE}.bkup"
        sudo mv -f "${DIR}/$FILE" "$TEMP_DIR/$FILE.bkup"
        LAST_EXIT="$?"
        if [ $LAST_EXIT -ne 0 ]; then
            EXIT_STATUS="${LAST_EXIT}"
            subtask_exit_status "Failed to backup original ${CYAN}${FILE}${RED} to ${CYAN}${TEMP_DIR}/${FILE}.bkup"
        else
            EXIT_STATUS="0"
            echo -e "${B_YELLOW}            $(sudo ls -alhp --color=auto "${TEMP_DIR}/${FILE}.bkup" | awk '{print $9}')${NC}"
            subtask_exit_status "Original copied to: ${CYAN}${TEMP_DIR}/${FILE}.bkup"
        fi
    else
        EXIT_STATUS="0"
        subtask_exit_status "No original found, ${CYAN}${DIR}/${FILE}, skipping backup"
    fi
    #? Replace file in target directory
    subtask_title "Replace ${CYAN}${FILE}${BLUE} in ${CYAN}${DIR}${BLUE} with new version from ${CYAN}${TEMP_DIR}"
    if [ -f "${TEMP_DIR}/${FILE}" ]; then
        sudo mv -f "${TEMP_DIR}/${FILE}" "${DIR}/${FILE}"
        LAST_EXIT="$?"
        # echo -e "${NC}"
        if [ "${LAST_EXIT}" -ne 0 ]; then
            if [ "${EXIT_ON_FAIL}" = "true" ] && [ "${LAST_EXIT}" -ne 0 ]; then
                subtask_exit_status "Failed to Replace ${CYAN}${FILE}${RED} restoring backup"
                sudo mv -f "$TEMP_DIR"/"$FILE".bkup "${DIR}"/"$FILE"
                if [ -f "${DIR}/$FILE" ]; then
                    subtask_exit_status "Restored backup ${CYAN}${FILE}${YELLOW} from ${CYAN}${TEMP_DIR}/${FILE}.bkup"
                else
                    subtask_exit_status "Failed to restore backup ${CYAN}${FILE}"
                fi
                #? Exit function with error message
                EXIT_STATUS="${LAST_EXIT}"
                MESSAGE="CRITICAL FAILURE - Failed to Replace ${CYAN}${FILE}${RED}, exiting script"
                exit_and_display_status
            elif [ "${EXIT_ON_FAIL}" = "false" ] && [ "${LAST_EXIT}" -ne 0 ]; then
                subtask_exit_status "Failed to Replace ${CYAN}${FILE}${RED} restoring backup"
                sudo mv -f "${TEMP_DIR}/${FILE}.bkup" "${DIR}/${FILE}"
                if [ -f "${DIR}/${FILE}" ]; then
                    subtask_exit_status "Restored backup ${CYAN}${FILE}${YELLOW} from ${CYAN}${TEMP_DIR}/${FILE}.bkup"
                else
                    subtask_exit_status "Failed to restore backup ${CYAN}${FILE}"
                fi
                EXIT_STATUS="1"
            fi
        else
            echo -e "${B_YELLOW}            $(sudo ls -alhp --color=auto "${DIR}/${FILE}" | awk '{print $9}')${NC}"
            EXIT_STATUS="0"
        fi
    fi
    #? Cleanup temp files
    if [ -f "${TEMP_DIR}/${FILE}" ]; then
        subtask_title "Cleanup temp files in ${CYAN}${TEMP_DIR}"
        sudo rm -rf "${TEMP_DIR}/${FILE}" > /dev/null 2>&1
        if [ "$?" -ne 0 ]; then
            subtask_exit_status "Failed to remove temp files"
        else
            subtask_exit_status "Temp files removed"
        fi
    fi
    #? Exit function with result
    if [ "${EXIT_STATUS}" -ne 0 ]; then
        EXIT_STATUS="1"
        task_exit_status "Failed to Replace ${CYAN}${FILE}${RED} is marked as non critical, continuing script"
    else
        EXIT_STATUS="0"
        task_exit_status "Replaced ${CYAN}${FILE}"
    fi
    #? unset vars just incase
    unset URL
    unset TEMP_DIR
    unset DIR
    unset FILE
    unset MOD
    unset OWN
    unset LAST_EXIT
    unset EXIT_ON_FAIL
    unset EXIT_ON_FAILURE
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT: Check if package is already installed. Exit if already installed,
#?        else install. set EXIT_ON_FAILURE to true to exit script on failure
#* USEAGE: install_package <package_name>
#* EXAMPLE: install_package "figlet"

install_if_not_installed()
{
    local INSTALL_PKG="$1"
    local EXIT_ON_FAIL="${EXIT_ON_FAILURE}"
    local LAST_EXIT=""

    task_title  "Checking if ${CYAN}${INSTALL_PKG}${BLUE} is installed"

    #? Check if package is installed
    if [ "$(dpkg --list | grep -c ${INSTALL_PKG})" -eq 1 ]; then
        EXIT_STATUS="0"
        task_exit_status "${CYAN}${INSTALL_PKG}${BLUE} is already installed"
    else
        subtask_title "${CYAN}${INSTALL_PKG}${BLUE} is not installed, installing now"
        subtask_title "Update apt repositories"
        echo -e "${YELLOW}"
        #? Update apt repositories
        sudo apt update -qq -y
        LAST_EXIT="$?"
        if [ "${LAST_EXIT}" -ne 0 ]; then
            EXIT_STATUS="${LAST_EXIT}"
            echo -e "${NC}"
            subtask_exit_status "${YELLOW}Failed to update apt repositories, attempting to install anyway"
            #? call install_package function to install package
            install_package "${INSTALL_PKG}"
        else
            EXIT_STATUS="0"
            echo -e "${NC}"
            #? call install_package function to install package
            subtask_exit_status "Updated apt repositories successfully"
            install_package "${INSTALL_PKG}"
        fi
    fi
    #? unset vars just incase
    unset INSTALL_PKG
    unset EXIT_ON_FAIL
    unset EXIT_ON_FAILURE
    unset LAST_EXIT
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT: Install a package using apt, set EXIT_ON_FAILURE to true to exit
#?        script on failure
#* USEAGE: install_package <package_name>
#* EXAMPLE: install_package "figlet"

install_package()
{
    local INSTALL_PKG="$1"
    local EXIT_ON_FAIL="${EXIT_ON_FAILURE}"
    local LAST_EXIT=""

    task_title "Install ${CYAN}${INSTALL_PKG}"

    echo -e "${YELLOW}"
    #? Install package
    sudo apt install ${INSTALL_PKG} -qq -y
    LAST_EXIT="$?"
    #? Exit function with result
    if [ "${LAST_EXIT}" -ne 0 ]; then
        if [ "${EXIT_ON_FAIL}" = "true" ] && [ "${LAST_EXIT}" -ne 0 ]; then
            EXIT_STATUS="${LAST_EXIT}"
            echo -e "${NC}"
            MESSAGE="CRITICAL FAILURE - Failed to install ${CYAN}${INSTALL_PKG}${RED}, exiting script"
            exit_and_display_status
        elif [ "${EXIT_ON_FAIL}" = "false" ] && [ "${LAST_EXIT}" -ne 0 ]; then
            EXIT_STATUS="${LAST_EXIT}"
            echo -e "${NC}"
            task_exit_status "Failed to install ${CYAN}${INSTALL_PKG}${RED}. ${CYAN}${INSTALL_PKG}${RED} is marked as non critical, continuing script"
        fi
    else
        EXIT_STATUS="0"
        echo -e "${NC}"
        task_exit_status "${CYAN}${INSTALL_PKG}${GREEN} installed"
    fi
    #? unset vars just incase
    unset INSTALL_PKG
    unset EXIT_ON_FAIL
    unset EXIT_ON_FAILURE
    unset LAST_EXIT
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT: Determine shell and reload config.
#* USEAGE: reload_shell
#* EXAMPLE: reload_shell

reload_shell()
{
    task_title "Reload the config based on the detected shell"
    case "$SHELL" in
        '/bin/zsh')
            source "${HOME}/.zshrc"
            task_exit_status "Reloading zsh configuration"
            ;;
        '/bin/bash')
            source "${HOME}/.bashrc"
            task_exit_status "Reloading bash configuration"
            ;;
        '/bin/fish')
            fish -c source "${HOME}/.config/fish/config.fish"
            task_exit_status "Reloading fish configuration"
            ;;
        *)  EXIT_STATUS="1"
            task_exit_status "Unsupported shell"
            ;;
    esac
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT: Display a fake download progress bar to spice up the output and add 
#?        a little deplay to the script
#* USEAGE: download_bar
#* EXAMPLE: download_bar

download_bar()
{
    echo
    for _ in {1..80}; do
        echo -ne "\e[31m▓\e[0m"
        sleep 0.015
    done
    echo -e "\n"
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT: Spinner function to show a spinner while a command is running. Useful 
#?        if command is slow, running quietly, or in the background.
#* USEAGE: <command>|<func> & spin
#* EXAMPLE: <command>|<func> & spin

spin() 
{
  local pid=$!
  local delay=0.1
  local spinstr='|/-\'
  while kill -0 "$pid" 2>/dev/null; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  wait $pid
}
#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#
#? ABOUT:
#* USEAGE:
#* EXAMPLE:

# example()
# {
#   echo -e "${GREEN}Hello ${BLLUE}World${RED}!${NC}"
# }

#! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ !#

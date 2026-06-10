NO_FORMAT="\033[0m"
F_BOLD="\033[1m"
C_LIGHTSLATEBLUE="\033[38;5;105m"
GREEN="\033[38;5;29m"
RED="\033[38;5;124m"

if error=$(ip addr replace 20.1.1.1/24 dev eth0 2>&1); then
    echo -e "${F_BOLD}${C_LIGHTSLATEBLUE}[INFO] Setting IP Address for host-1 ...${NO_FORMAT}"
    echo -e "${F_BOLD}${GREEN}[SUCCESS] Ip Address is now set to : 20.1.1.1/24 for host-1${NO_FORMAT}"
else
    echo -e "${F_BOLD}${RED}[ERROR] ${error}${NO_FORMAT}"
fi


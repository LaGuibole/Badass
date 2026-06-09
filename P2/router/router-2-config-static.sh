#!/bin/sh

NO_FORMAT=$'\033[0m'
F_BOLD=$'\033[1m'
C_LIGHTSLATEBLUE=$'\033[38;5;105m'
GREEN=$'\033[38;5;29m'
RED=$'\033[38;5;124m'

run_cmd() {
    if error=$("$@" 2>&1); then
        return 0
    else
        echo "${F_BOLD}${RED}[ERROR] ${error}${NO_FORMAT}"
        exit 1
    fi
}

# Cleaning
ip link del vxlan10 2>/dev/null
ip link del br0 2>/dev/null
echo "${F_BOLD}${C_LIGHTSLATEBLUE}[INFO] Cleaning former VxLan and Bridge ...${NO_FORMAT}"

# Underlay router interface
run_cmd ip addr replace 10.1.1.2/24 dev eth0
echo "${F_BOLD}${C_LIGHTSLATEBLUE}[INFO] Adding underlay router-2 interface ...${NO_FORMAT}"

# Bridge setup
run_cmd ip link replace br0 type bridge
run_cmd ip link set br0 up
echo "${F_BOLD}${C_LIGHTSLATEBLUE}[INFO] Setting bridge up ...${NO_FORMAT}"

# Static VXLAN setup
run_cmd ip link replace vxlan10 type vxlan id 10 dev eth0 local 10.1.1.2 remote 10.1.1.1 dstport 4789
run_cmd ip link set vxlan10 up
echo "${F_BOLD}${C_LIGHTSLATEBLUE}[INFO] Setting VxLan up ...${NO_FORMAT}"

# Bridge membership
run_cmd ip link set eth1 master br0
run_cmd ip link set vxlan10 master br0
echo "${F_BOLD}${C_LIGHTSLATEBLUE}[INFO] Setting VxLan to Bridge ...${NO_FORMAT}"

echo "${F_BOLD}${GREEN}[SUCCESS] Router-2-static VxLan configured${NO_FORMAT}"

#!/bin/sh

NO_FORMAT=$'\033[0m'
F_BOLD=$'\033[1m'
C_LIGHTSLATEBLUE=$'\033[38;5;105m'
GREEN=$'\033[38;5;29m'

# Cleaning
ip link del vxlan10 2>/dev/null
ip link del br0 2>/dev/null
echo "${F_BOLD}${C_LIGHTSLATEBLUE}[INFO] Cleaning former VxLan and Bridge ...${NO_FORMAT}"

# Underlay router interface
ip addr replace 10.1.1.1/24 dev eth0
echo "${F_BOLD}${C_LIGHTSLATEBLUE}[INFO] Adding underlay router-2 interface ...${NO_FORMAT}"

# Bridge Setup
ip link replace br0 type bridge
ip link set br0 up
echo "${F_BOLD}${C_LIGHTSLATEBLUE}[INFO] Setting bridge up ...${NO_FORMAT}"

# Static VxLan Setup
ip link replace vxlan10 type vxlan id 10 dev eth0 local 10.1.1.1 remote 10.1.1.2 dstport 4789
ip link set vxlan10 up
echo "${F_BOLD}${C_LIGHTSLATEBLUE}[INFO] Setting VxLan up ...${NO_FORMAT}"

# Adding VxLan to bridge
ip link set vxlan10 master br0

# Interface to local host
ip link set eth1 master br0
ip link set vxlan10 master br0
echo "${F_BOLD}${C_LIGHTSLATEBLUE}[INFO] Setting VxLan to Bridge ...${NO_FORMAT}"
echo "${F_BOLD}${GREEN}[SUCCESS] Router-2-static VxLan configured${NO_FORMAT}"


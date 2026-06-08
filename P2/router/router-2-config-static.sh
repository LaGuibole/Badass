#!/bin/sh

# Cleaning
ip link del vxlan10 2>/dev/null
ip link del br0 2>/dev/null
echo "[INFO] Cleaning former VxLan and Bridge ..."

# Underlay router interface
ip addr add 10.1.1.2/24 dev eth0
echo "[INFO] Adding underlay router-1 interface ..."

# Bridge Setup
ip link add br0 type bridge
ip link set br0 up
echo "[INFO] Setting bridge up ..."

# Static VxLan Setup
ip link add vxlan10 type vxlan id 10 dev eth0 local 10.1.1.2 remote 10.1.1.1 dstport 4789
ip link set vxlan10 up
echo "[INFO] Setting VxLan up ..."

# Adding VxLan to bridge
ip link set vxlan10 master br0

# Interface to local host
ip link set eth1 master br0
ip link set vxlan10 master br0
echo "[INFO] Setting VxLan to Bridge ..."
echo "[SUCCESS] Router-2-static VxLan configured"

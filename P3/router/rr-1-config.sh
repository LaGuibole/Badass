# Steps :
#	1. Turn off ipv6 to work only with ipv4 adresses
#	2. Set IP address on eth0 interface
#	3. Set IP address on eth1 interface
#	4. Set IP address on eth2 interface
#	5. Set IP address on lo interface
#	6. BGP Part :
#		6.1. Enable BGP routing process with AS 1
#		6.2. Create a BGP peer group tagged as DYNAMIC
#		6.3. Assign peer-group
#		6.4. Neighbor communication
#		6.5. Dynamic neighbors configuration - listen on a TRUSTED range, add them to specified peer-group -
#		6.6. Configure neighbor in peer group DYNAMIC as RR client
#	7. Enabling OSPF Process all on IP networks

vtysh << EOF
configure terminal
no ipv6 forwarding
interface eth0
	ip address 10.1.1.1/30
exit
interface eth1
	ip address 10.1.1.5/30
exit
interface eth2
	ip address 10.1.1.9/30
exit
interface lo
	ip address 1.1.1.1/32
exit
router bgp 1
	neighbor DYNAMIC peer-group
	neighbor DYNAMIC remote-as 1
	neighbor DYNAMIC update-source lo
	bgp listen range 1.1.1.0/24 peer-group DYNAMIC
	address-family l2vpn evpn
		neighbor DYNAMIC activate
		neighbor DYNAMIC route-reflector-client
	exit-address-family
exit
router ospf
	network 0.0.0.0/0 area 0
exit
EOF

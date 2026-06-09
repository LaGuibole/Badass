## BGP - At doors of autonomous system for 42 School ##

## Basic Notions ##

### Basic Architecture ###
*The Underlay:*
	`OSPF (IGP)` : Provides loopback reachability between all nodes (leaf/spine)
	`PIM (IP Multicast)` : For VXLAN flood-and-learn
*The Overlay*
	`VXLAN` : Encapsulates/decapsulates traffic between VTEPs. i.e the dataplane
	`BGP-EVPN` : Operates as the control plane to distribute end-host and VTEP reachability information

Sources :

- Tini Init System for Docker Containers : https://computingpost.medium.com/how-to-use-tini-init-system-in-docker-containers-69283d0099ed
- VXLAN BGP-EVPN Introduction : https://www.youtube.com/watch?v=7hxBvcAU7UE&t=35s


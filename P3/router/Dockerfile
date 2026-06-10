# FrrRouting image
FROM frrouting/frr:latest

# Installing depedencies
RUN apk update && apk add --no-cache \
	busybox-extras \
	iputils \
	tcpdump \
	nano
# Reminder : sed 's/searched_occurence/replacement_occurence' -i <Our File>
RUN sed 's/bgpd=no/bgpd=yes/' -i /etc/frr/daemons && \
	sed 's/ospfd=no/ospfd=yes/' -i /etc/frr/daemons && \
	sed 's/isisd=no/isisd=yes/' -i /etc/frr/daemons
RUN touch /etc/frr/vtysh.conf && \
	chown frr:frrvty /etc/frr/vtysh.conf && \
	chown 640 /etc/frr/vtysh.conf
# See README.md for Tini Init System for DOcker Containers
CMD ["/sbin/tini", "--", "/usr/lib/frr/docker-start"]


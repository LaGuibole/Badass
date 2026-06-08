# Alpine image
FROM alpine:latest

# Installing depedencies
RUN apk update && apk add --no-cache \
	busybox-extras \
	iputils \
	tcpdump \
	nano

CMD ["/bin/sh"]
	

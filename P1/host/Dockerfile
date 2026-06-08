# Alpine image
FROM alpine:latest

# Installing depedencies
RUN apk update && apk add --no-cache \
	busybox-extras \
	iputils \
	tcp-dump \
	nano

CMD ["/bin/sh"]
	

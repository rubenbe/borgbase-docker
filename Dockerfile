from alpine:3.11.5
RUN apk add --no-cache python3
RUN apk add     python3-dev \
    openssl-dev \
 alpine-sdk \
 acl-dev
RUN apk add --no-cache libffi-dev
RUN pip3 install borgbackup borgmatic

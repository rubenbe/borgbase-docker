from alpine:3.11.5
RUN apk add --no-cache python3
RUN apk add     python3-dev \
    openssl-dev \
 alpine-sdk \
 acl-dev
RUN apk add --no-cache libffi-dev
RUN pip3 install borgbackup borgmatic
RUN apk add --no-cache openssh
RUN mkdir -p  ~/.ssh && echo -e \
'Host *.repo.borgbase.com\n' \
'  IdentityFile /storage/ssh/id_ed25519\n' \
'  UserKnownHostsFile /storage/ssh/known_hosts\n' \
> /root/.ssh/config

RUN pip3 install requests
RUN curl -L https://github.com/borgbase/borgbase-api-client/archive/master.tar.gz | tar  -C /usr/local/bin/ --strip-components=1 -xvzf - borgbase-api-client-master/borgbase_api_client/

ADD backup.sh /usr/local/bin/backup
ADD autocreate-borg-repo.py /usr/local/bin/autocreate-borg-repo
CMD /usr/local/bin/backup

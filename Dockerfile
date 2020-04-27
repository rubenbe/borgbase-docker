from alpine:3.11.5 as builder
RUN apk add --no-cache \
    python3 \
    python3-dev \
    openssl-dev \
    alpine-sdk \
    acl-dev \
    libffi-dev \
    openssh
RUN pip3 install borgbackup borgmatic requests
RUN apk add --no-cache curl
RUN curl -L https://github.com/borgbase/borgbase-api-client/archive/master.tar.gz | tar  -C /usr/local/bin/ --strip-components=1 -xvzf - borgbase-api-client-master/borgbase_api_client/

from alpine:3.11.5
COPY --from=builder /usr/lib/python3.8/site-packages /usr/lib/python3.8/
COPY --from=builder /usr/bin/borgmatic /usr/bin/
COPY --from=builder /usr/bin/borg /usr/bin/
RUN apk add --no-cache \
    python3 \
    openssh-client \
    curl \
    mariadb-client \
    acl && \
    cd /usr/lib/python3.8/ && \
    rm -rf site-packages* \
           lib2to3 \
           ensurepip \
           pydoc_data \
           multiprocessing && \
    sh -c 'borgmatic -h > /dev/null'
RUN mkdir -p  ~/.ssh && echo -e \
'Host *.borgbase.com\n' \
'  IdentityFile /storage/ssh/id_ed25519\n' \
'  UserKnownHostsFile /usr/local/share/borgbase/known_hosts\n' \
> /root/.ssh/config && \
ln -s /config/borgmatic /etc/borgmatic


ADD known_hosts /usr/local/share/borgbase/known_hosts
ADD backup.sh /usr/local/bin/backup
ADD autocreate-borg-repo.py /usr/local/bin/autocreate-borg-repo
ADD nightly-backup.py /etc/periodic/daily/nightly-backup
COPY --from=builder /usr/local/bin/borgbase_api_client /usr/local/bin/borgbase_api_client
CMD /usr/local/bin/backup

FROM postgres:9.4

RUN apt-get update \
    && apt-get install -y python-dev lzop pv daemontools curl build-essential\
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN curl --silent --show-error --retry 5 https://bootstrap.pypa.io/get-pip.py | python
RUN pip install wal-e

ADD make_db.sh /docker-entrypoint-initdb.d/
ADD setup-wale.sh /docker-entrypoint-initdb.d/

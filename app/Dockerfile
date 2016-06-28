FROM ubuntu:14.04

RUN apt-get update && apt-get -y install wget netcat git curl build-essential && apt-get clean  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN wget https://storage.googleapis.com/golang/go1.6.1.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.6.1.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

RUN mkdir -p /mattermost/data



RUN mkdir /go
ENV GOPATH=/go
ENV GO15VENDOREXPERIMENT=0
RUN cd /go && mkdir -p src/github.com/mattermost


RUN cd /go/src/github.com/mattermost && git clone https://github.com/pwr-inf/platform.git

# https://github.com/mattermost/platform.git 
RUN cd /go/src/github.com/mattermost/platform && make package
RUN mv /go/src/github.com/mattermost/platform/dist/mattermost/* /mattermost/
COPY config.template.json /
COPY docker-entry.sh /

RUN chmod +x /docker-entry.sh

ENTRYPOINT /docker-entry.sh

EXPOSE 80

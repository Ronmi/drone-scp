FROM debian:stable-slim
MAINTAINER Ronmi Ren <ronmi@ronmi.tw>

RUN apt-get update \
 && apt-get install -y openssh-client \
 && apt-get clean -y \
 && rm -fr /var/lib/apt/lists/*

ADD scp.sh /usr/local/bin/

ENTRYPOINT /usr/local/bin/scp.sh

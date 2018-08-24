FROM debian:stretch-slim

RUN apt-get update && \
    echo "install basic utils" && \
    apt-get -y install iputils-ping net-tools telnet iproute2 procps netcat-traditional socat

COPY release/testserver_linux_64 /usr/local/bin/testserver
RUN chmod +x /usr/local/bin/testserver

EXPOSE 8800

ENTRYPOINT ["/entrypoint.sh"]

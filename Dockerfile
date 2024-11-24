FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y hping3 iperf3 iproute2 iptables \
    iputils-ping iputils-tracepath mtr-tiny nftables traceroute \
    whois wireguard-tools && rm -rf /var/lib/apt/lists/* /var/log/*

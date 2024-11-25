ARG GOLANG_VERSION=1.23

FROM golang:${GOLANG_VERSION}-bookworm AS builder

ARG wg_go_tag=12269c2761734b15625017d8565745096325392f
ARG wg_tools_tag=13f4ac4cb74b5a833fa7f825ba785b1e5774e84f

ENV PREFIX=/output

RUN apt-get update && \
    apt-get install -y git-core build-essential libmnl-dev iptables && \
    rm -rf /var/lib/apt/lists/* /var/log/* && \
    mkdir ${PREFIX}

RUN git clone https://git.zx2c4.com/wireguard-go && \
    cd wireguard-go && \
    git checkout $wg_go_tag && \
    make && \
    make install

ENV WITH_WGQUICK=yes
RUN git clone https://git.zx2c4.com/wireguard-tools && \
    cd wireguard-tools && \
    git checkout $wg_tools_tag && \
    cd src && \
    make && \
    make install

FROM debian:stable-slim

COPY --from=builder /output/bin/* /usr/local/bin/

RUN apt-get update && \
    apt-get install -y hping3 iperf3 iproute2 iptables \
    iputils-ping iputils-tracepath mtr-tiny nftables procps traceroute \
    whois && rm -rf /var/lib/apt/lists/* /var/log/*

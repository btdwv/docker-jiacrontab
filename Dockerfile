FROM golang:alpine3.11 as builder
RUN \
    apk add -U --no-cache docker-cli make git && \
    cd / && \
    git clone https://github.com/iwannay/jiacrontab.git && \
    cd /jiacrontab && \
    make build

FROM lsiobase/alpine:3.11
COPY --from=builder /jiacrontab/build/jiacrontab /

ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer=""

ENV VERSION 2.0.5

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS 2

RUN \
echo "**** install runtime packages ****" && \
apk add -U --no-cache docker-cli tini tzdata procps && \
echo "**** install pip packages ****" && \
pip install --no-cache-dir -U pip && \
pip install --no-cache-dir -U requests && \
echo "**** clean up ****" && \
rm -rf \
    /root/.cache \
    /tmp/*

COPY root/ /

EXPOSE 20000

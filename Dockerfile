FROM lsiobase/alpine:3.11 as builder
#FROM golang:alpine3.11 as builder
WORKDIR /
RUN \
    apk add -U --no-cache git make go && \
    git clone https://github.com/iwannay/jiacrontab.git
WORKDIR /jiacrontab
RUN make build

FROM lsiobase/alpine:3.11
COPY --from=builder /jiacrontab/build/* /

ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer=""

ENV VERSION 2.0.5

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS 2

RUN \
echo "**** install runtime packages ****" && \
apk add -U --no-cache docker-cli tini tzdata procps python2 py2-pip && \
echo "**** install pip packages ****" && \
pip install --no-cache-dir -U pip && \
pip install --no-cache-dir -U requests && \
echo "**** clean up ****" && \
rm -rf \
    /root/.cache \
    /tmp/*

COPY root/ /

EXPOSE 20000

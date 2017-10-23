FROM ubuntu:16.04 as build

ARG ORACLE_INSTANTCLIENT_MAJOR
ARG ORACLE_INSTANTCLIENT_VERSION
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /

RUN apt-get update && \
    apt-get install -y build-essential ca-certificates git libtool vim wget fakeroot dpkg-dev quilt debhelper mc alien \
    libcurl4-openssl-dev libcap-dev libgdbm-dev \
    libiodbc2-dev libjson0-dev libkrb5-dev libldap2-dev libpam0g-dev \
    libpcap-dev libperl-dev libmysqlclient-dev libpq-dev libreadline-dev \
    libsasl2-dev libsqlite3-dev libssl-dev libtalloc-dev libwbclient-dev \
    libyubikey-dev libykclient-dev libmemcached-dev libhiredis-dev python-dev \
    samba-dev libcollectdclient-dev

ENV ORACLE_INSTANTCLIENT_MAJOR ${ORACLE_INSTANTCLIENT_MAJOR:-12.2}
ENV ORACLE_INSTANTCLIENT_VERSION ${ORACLE_INSTANTCLIENT_VERSION:-12.2.0.1.0}

COPY include/localtime /etc/
COPY vendor/instantclient-${ORACLE_INSTANTCLIENT_VERSION}/oracle-instantclient${ORACLE_INSTANTCLIENT_MAJOR}-*-${ORACLE_INSTANTCLIENT_VERSION}-1.x86_64.rpm /

RUN alien oracle-instantclient${ORACLE_INSTANTCLIENT_MAJOR}-*-${ORACLE_INSTANTCLIENT_VERSION}-1.x86_64.rpm


FROM ubuntu:16.04
MAINTAINER Vladimir Kushnir <vkushnir@gmail.com>

ARG ORACLE_INSTANTCLIENT_MAJOR
ARG ORACLE_INSTANTCLIENT_VERSION
ARG DEBIAN_FRONTEND=noninteractive

LABEL \
    version="0.2" \
    description="Oralce Instantclient"

ENV NLS_LANG RUSSIAN_CIS.UTF8
ENV LANG en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV ORACLE_INSTANTCLIENT_MAJOR ${ORACLE_INSTANTCLIENT_MAJOR:-12.2}
ENV ORACLE_INSTANTCLIENT_VERSION ${ORACLE_INSTANTCLIENT_VERSION:-12.2.0.1.0}
ENV ORACLE_HOME /usr/lib/oracle/${ORACLE_INSTANTCLIENT_MAJOR}/client64
ENV PATH=$PATH:$ORACLE_HOME/bin
ENV LD_LIBRARY_PATH /usr/lib/oracle/${ORACLE_INSTANTCLIENT_MAJOR}/client64/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}

WORKDIR /

RUN apt-get clean && \
    apt-get update && \
    apt-get install -y --no-install-recommends locales libaio1 && \
    locale-gen en_US.UTF-8 ru_RU.UTF-8 ru_RU.CP1251

#COPY vendor/instantclient-${ORACLE_INSTANTCLIENT_VERSION}/oracle-instantclient${ORACLE_INSTANTCLIENT_MAJOR}-*-${ORACLE_INSTANTCLIENT_VERSION}-1.x86_64.rpm /
COPY --from=build /oracle-instantclient${ORACLE_INSTANTCLIENT_MAJOR}-*_${ORACLE_INSTANTCLIENT_VERSION}-2_amd64.deb /
    
RUN dpkg -i oracle-instantclient${ORACLE_INSTANTCLIENT_MAJOR}-*_${ORACLE_INSTANTCLIENT_VERSION}-2_amd64.deb \
 && rm -rf oracle-instantclient${ORACLE_INSTANTCLIENT_MAJOR}-*_${ORACLE_INSTANTCLIENT_VERSION}-2_amd64.deb \
 && ln -s /usr/include/oracle/${ORACLE_INSTANTCLIENT_MAJOR}/client64 ${ORACLE_HOME}/include \
 && ln -s $(basename `find /usr/lib/oracle/${ORACLE_INSTANTCLIENT_MAJOR}/client64/lib/libnnz*.so -type f`) /usr/lib/oracle/${ORACLE_INSTANTCLIENT_MAJOR}/client64/lib/libnnz.so \
 && echo /usr/lib/oracle/${ORACLE_INSTANTCLIENT_MAJOR}/client64/lib > /etc/ld.so.conf.d/oracle.conf \
 && chmod o+r /etc/ld.so.conf.d/oracle.conf \
 && ldconfig

RUN apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*


FROM ubuntu
MAINTAINER Vladimir Kushnir <vkushnir@gmail.com>

ARG ORACLE_INSTANTCLIENT_MAJOR
ARG ORACLE_INSTANTCLIENT_VERSION
ARG DEBIAN_FRONTEND=noninteractive

LABEL \
    version="0.1" \
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

RUN apt-get clean && apt-get update && apt-get install -y --no-install-recommends apt-utils locales libaio1 \
 && locale-gen en_US.UTF-8 ru_RU.UTF-8 ru_RU.CP1251 \
 && apt-get autoremove \
 && rm -rf /var/lib/apt/lists/*

COPY vendor/instantclient-${ORACLE_INSTANTCLIENT_VERSION}/*oracle-instantclient${ORACLE_INSTANTCLIENT_MAJOR}-*_${ORACLE_INSTANTCLIENT_VERSION}-2_amd64.deb ./
    
RUN dpkg -i oracle-instantclient${ORACLE_INSTANTCLIENT_MAJOR}-*_${ORACLE_INSTANTCLIENT_VERSION}-2_amd64.deb \
 && rm -rf oracle-instantclient${ORACLE_INSTANTCLIENT_MAJOR}-*_${ORACLE_INSTANTCLIENT_VERSION}-2_amd64.deb \
 && ln -s /usr/include/oracle/${ORACLE_INSTANTCLIENT_MAJOR}/client64 ${ORACLE_HOME}/include \
 && ln -s $(basename `find /usr/lib/oracle/${ORACLE_INSTANTCLIENT_MAJOR}/client64/lib/libnnz*.so -type f`) /usr/lib/oracle/${ORACLE_INSTANTCLIENT_MAJOR}/client64/lib/libnnz.so \
 && echo /usr/lib/oracle/${ORACLE_INSTANTCLIENT_MAJOR}/client64/lib > /etc/ld.so.conf.d/oracle.conf \
 && chmod o+r /etc/ld.so.conf.d/oracle.conf \
 && ldconfig

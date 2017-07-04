FROM frolvlad/alpine-glibc
#FROM alpine
MAINTAINER Vladimir Kushnir <vkushnir@gmail.com>

LABEL \
    version="0.1" \
    description="Oralce Instantclient"

ENV NLS_LANG RUSSIAN_CIS.UTF8
ENV LANG en_US.UTF-8
ENV ORACLE_INSTANTCLIENT_MAJOR 12.2
ENV ORACLE_INSTANTCLIENT_VERSION 12.2.0.1.0
ENV ORACLE_BASE /opt/oracle
ENV ORACLE_HOME $ORACLE_BASE/instantclient_12_2

WORKDIR $ORACLE_BASE

RUN apk update && apk add libaio && rm -f /var/cache/apk/*
COPY vendor/instantclient-$ORACLE_INSTANTCLIENT_VERSION/instantclient-basic-linux.x64-$ORACLE_INSTANTCLIENT_VERSION.zip .
COPY vendor/instantclient-$ORACLE_INSTANTCLIENT_VERSION/instantclient-odbc-linux.x64-$ORACLE_INSTANTCLIENT_VERSION.zip .
COPY vendor/instantclient-$ORACLE_INSTANTCLIENT_VERSION/instantclient-sqlplus-linux.x64-$ORACLE_INSTANTCLIENT_VERSION.zip .
COPY vendor/instantclient-$ORACLE_INSTANTCLIENT_VERSION/instantclient-tools-linux.x64-$ORACLE_INSTANTCLIENT_VERSION.zip .
COPY vendor/instantclient-$ORACLE_INSTANTCLIENT_VERSION/instantclient-sdk-linux.x64-$ORACLE_INSTANTCLIENT_VERSION.zip .
RUN unzip instantclient-basic-linux.x64-$ORACLE_INSTANTCLIENT_VERSION.zip &&\
	unzip instantclient-odbc-linux.x64-$ORACLE_INSTANTCLIENT_VERSION.zip &&\
	unzip instantclient-sqlplus-linux.x64-$ORACLE_INSTANTCLIENT_VERSION.zip &&\
	unzip instantclient-tools-linux.x64-$ORACLE_INSTANTCLIENT_VERSION.zip &&\
	unzip instantclient-sdk-linux.x64-$ORACLE_INSTANTCLIENT_VERSION.zip &&\
	rm -f instantclient-*.zip &&\
	chmod -R -x $ORACLE_HOME &&\
	cd $ORACLE_HOME &&\
	chmod +x adrci genezi sqlplus exp* imp* sqlldr wrc &&\
	ln -s libclntsh.so.12.1 libclntsh.so &&\
	ln -s libnnz12.so libnnz.so
    
ENV LD_LIBRARY_PATH $ORACLE_HOME
ENV PATH $PATH:$ORACLE_HOME


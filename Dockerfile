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
ENV ORACLE_HOME instantclient_12_2
ENV ORACLE_BASE /opt/oracle

WORKDIR $ORACLE_BASE

RUN apk update && apk add libaio
COPY instantclient-basic-linux.x64-$ORACLE_INSTANTCLIENT_VERSION.zip .
COPY instantclient-odbc-linux.x64-$ORACLE_INSTANTCLIENT_VERSION.zip .
COPY instantclient-sqlplus-linux.x64-$ORACLE_INSTANTCLIENT_VERSION.zip .
COPY instantclient-tools-linux.x64-$ORACLE_INSTANTCLIENT_VERSION.zip .
RUN unzip instantclient-basic-linux.x64-$ORACLE_INSTANTCLIENT_VERSION.zip &&\
	unzip instantclient-odbc-linux.x64-$ORACLE_INSTANTCLIENT_VERSION.zip &&\
	unzip instantclient-sqlplus-linux.x64-$ORACLE_INSTANTCLIENT_VERSION.zip &&\
	unzip instantclient-tools-linux.x64-$ORACLE_INSTANTCLIENT_VERSION.zip &&\
	chmod -R -x $ORACLE_HOME &&\
	chmod +x $ORACLE_HOME/adrci $ORACLE_HOME/genezi $ORACLE_HOME/sqlplus $ORACLE_HOME/exp* $ORACLE_HOME/imp* $ORACLE_HOME/sqlldr $ORACLE_HOME/wrc &&\
	rm -f instantclient-*.zip
    
ENV LD_LIBRARY_PATH $ORACLE_BASE/$ORACLE_HOME:$LD_LIBRARY_PATH
ENV PATH $ORACLE_BASE/$ORACLE_HOME:$PATH 


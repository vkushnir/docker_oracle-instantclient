FROM vkushnir/oracle-instantclient
MAINTAINER Vladimir Kushnir <v_kushnir@outlook.com>
LABEL description = "Oralce Instantclient with Python2"

RUN apt-get update && \
    apt-get install -y python python-pip && \
    python -m pip install cx_Oracle --upgrade && \
    apt-get purge -y python-pip && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["python2"]

FROM container-registry.oracle.com/database/instantclient
MAINTAINER Vladimir Kushnir <vkushnir@gmail.com>

LABEL \
    version="0.1" \
    description="FreeRADIUS Server with Oralce Instantclient"

ENV NLS_LANG="RUSSIAN_CIS.UTF8"

RUN yum -y install freeradius
RUN yum clean all  
     


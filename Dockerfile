FROM centos:centos7

RUN yum update -y && \
    yum install -y yum-utils wget && \
    pushd /tmp/ >/dev/null && \
    wget https://www.softwarecollections.org/en/scls/rhscl/nodejs010/epel-7-x86_64/download/rhscl-nodejs010-epel-7-x86_64.noarch.rpm && \
    wget https://www.softwarecollections.org/en/scls/rhscl/v8314/epel-7-x86_64/download/rhscl-v8314-epel-7-x86_64.noarch.rpm && \
    rpm -ivh rhscl-nodejs010-epel-7-x86_64.noarch.rpm && \
    rpm -ivh rhscl-v8314-epel-7-x86_64.noarch.rpm && \
    rm -f rhscl-nodejs010-epel-7-x86_64.noarch.rpm && \
    rm -f rhscl-v8314-epel-7-x86_64.noarch.rpm && \
    popd >/dev/null && \
    yum install -y --setopt=tsflags=nodocs nodejs && \
    yum clean all -y

ADD ./nodejs         /opt/nodejs/
ADD ./.sti/bin/usage /opt/nodejs/bin/

ENV STI_SCRIPTS_URL https://raw.githubusercontent.com/jhadvig/nodejs-0-10-centos7/master/.sti/bin

ENV STI_LOCATION /tmp

RUN mkdir -p /opt/nodejs/{run,src}

RUN groupadd -r nodejs -g 433 && \
    useradd -u 431 -r -g nodejs -d /opt/nodejs -s /sbin/nologin -c "NodeJS user" nodejs && \
    chown -R nodejs:nodejs /opt/nodejs

ENV APP_ROOT .
ENV HOME     /opt/nodejs
ENV PATH     $HOME/bin:$PATH

WORKDIR     /opt/nodejs/src

EXPOSE 3000

ADD ./enablenodejs010.sh /etc/profile.d/

CMD ["/opt/nodejs/bin/usage"]
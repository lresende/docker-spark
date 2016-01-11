#####################################
# Basic CentoOS Image
#

FROM centos:6.6
MAINTAINER Luciano Resende lresende@apache.org

USER root

# Clean metadata to avoid 404 erros from yum
#RUN yum clean all

#####################
# security

# install dev tools
RUN yum install -y curl which tar sudo openssh-server openssh-clients rsync | true
RUN yum update -y libselinux | true

# update root password
RUN echo 'root:passw0rd' | chpasswd

# passwordless ssh
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa && \
    cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

ADD ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config && \
    chown root:root /root/.ssh/config

# fix the 254 error code
RUN sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config
RUN echo "UsePAM no" >> /etc/ssh/sshd_config
RUN echo "Port 2122" >> /etc/ssh/sshd_config
    
#####################
# java

RUN curl -LO 'http://download.oracle.com/otn-pub/java/jdk/8u71-b15/jdk-8u71-linux-x64.rpm' -H 'Cookie: oraclelicense=accept-securebackup-cookie' && \
    rpm -i jdk-8u71-linux-x64.rpm && \
    rm jdk-8u71-linux-x64.rpm

ENV JAVA_HOME /usr/java/default
ENV PATH $PATH:$JAVA_HOME/bin

CMD ["/bin/bash.sh", ""]


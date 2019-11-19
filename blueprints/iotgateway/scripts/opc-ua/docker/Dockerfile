FROM centos:centos7
ADD ./work/ /root/work
RUN yum install -y gcc git
RUN yum  groupinstall -y 'Development Tools'
RUN cd /root/work && ls -al && tar xzf cmake-3.15.2.tar.gz && \
    rpm -Uvh scons-2.3.0-1.el7.centos.noarch.rpm && \
    python get-pip.py && \
    cd cmake-3.15.2 && ./bootstrap && \
    make && \
    make install && \
    cd ../protocol-opcua-c/ && \
    ./build.sh

FROM ubuntu:latest
RUN apt update && \
    apt install software-properties-common -y && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt install python3.7 -y && \
    apt install curl -y && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    apt install python3.7-distutils -y && \
    python3.7 get-pip.py && \
    apt install zip unzip

ADD package.sh /
RUN chmod +x ./package.sh

ENTRYPOINT ["/package.sh"]
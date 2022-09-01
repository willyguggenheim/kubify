FROM nvidia/cuda:11.7.1-base-ubuntu20.04
WORKDIR /src/kubify
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt -y install python3-pip make git curl unzip tar docker-compose
RUN curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.14.0/kind-$(uname)-amd64" && chmod +x ./kind && mv ./kind /usr/local/bin/kind
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN git clone https://github.com/tfutils/tfenv.git ~/.tfenv && mv ~/.tfenv/bin/tfenv /usr/local/bin/tfenv && chmod +x /usr/local/bin/tfenv && rm -rf ~/.tfenv
COPY setup.py .
COPY Makefile .
RUN touch README.rst USAGE.rst
RUN make pip
FROM nvidia/cuda:11.7.1-base-ubuntu20.04
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /src/kubify
RUN apt update && apt install -y make sudo
COPY Makefile .
COPY apt.lock .
RUN make apt
COPY setup.py .
COPY Makefile .
COPY README.rst .
COPY USAGE.rst .
COPY .bandit.yml .
RUN pip install --ignore-installed PyYAML
RUN pip install --upgrade pip
COPY kubify/ops/terraform ./ops/terraform
RUN make tfenv tfsec
RUN make security pip package
COPY . .
RUN make develop
FROM zenko/cloudserver AS s3

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends wget build-essential curl libreadline-gplv2-dev libncursesw5-dev \
    libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev -y && wget -q https://www.python.org/ftp/python/3.9.1/Python-3.9.1.tgz && tar xzf Python-3.9.1.tgz && cd Python-3.9.1 && \
    ./configure --enable-optimizations && make install && cd .. && rm Python-3.9.1.tgz && rm -rf Python-3.9.1 && alias pip=pip3 && alias python=python3.9

COPY requirements.txt /tmp/pip-tmp/

RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
   && rm -rf /tmp/pip-tmp 

FROM s3 as tests
ARG src="DevOps in Python"
COPY ${src}.tif .
COPY ${src}.pdf .
COPY app.py /tests/

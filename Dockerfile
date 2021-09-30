FROM debian:bookworm-slim

ARG S6_VERSION
ARG PYTHON_VERSION
ARG ANSIBLE_VERSION

# Install tini
WORKDIR /tmp

# Install s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && \
  # create directories
  mkdir -p /etc/services.d && mkdir -p /etc/cont-init.d && mkdir -p /s6-bin

# Install missing basic system dependecies
RUN apt-get update && apt-get install -y git openssh-client && \
  # python build dependencies
  apt-get install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev curl libbz2-dev && \
  # download and install python
  curl -o /tmp/python.tar.xz https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz && \
  tar -xf /tmp/python.tar.xz -C /tmp && \
  cd /tmp/Python-${PYTHON_VERSION} && \
  ./configure --enable-loadable-sqlite-extensions && \
  make -j 8 && \
  make install && \
  # smoke test
  python3 --version && \
  # get pip
  cd /tmp && \
  curl https://bootstrap.pypa.io/get-pip.py | python3 &&\
  python3 -m pip install --upgrade pip && \
  # install pip dependencies
  pip3 install wheel setuptools setuptools-rust ansible==${ANSIBLE_VERSION} && \
  # clean up
  rm -rf /tmp/*

# Copy scripts
ADD https://gist.githubusercontent.com/cenk1cenk2/e03d8610534a9c78f755c1c1ed93a293/raw/logger.sh /scripts/logger.sh
RUN chmod +x /scripts/*.sh

# Move s6 supervisor files inside the container
COPY ./services.d /etc/services.d
COPY ./cont-init.d /etc/cont-init.d

RUN chmod +x /etc/cont-init.d/*.sh && \
  chmod +x /etc/services.d/*/*

# s6 behaviour, https://github.com/just-containers/s6-overlay
ENV S6_KEEP_ENV 1
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS 2
ENV S6_FIX_ATTRS_HIDDEN 1

WORKDIR /ansible

ENTRYPOINT ["/bin/bash", "-c", "/init"]

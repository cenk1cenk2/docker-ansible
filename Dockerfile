# syntax=docker/dockerfile-upstream:master-labs
ARG PYTHON_VERSION

FROM docker.io/cenk1cenk2/vizier:latest AS vizier

FROM docker.io/library/python:${PYTHON_VERSION}

ARG ANSIBLE_VERSION

WORKDIR /tmp

# Install missing basic system dependecies
RUN apt-get update && apt-get install -y --no-install-recommends git openssh-client vim && \
  git --version && \
  # smoke test for python3
  python3 --version && \
  pip3 --version && \
  # install pip dependencies
  pip3 install --upgrade pip && \
  pip3 install wheel setuptools setuptools-rust ansible==${ANSIBLE_VERSION} ansible-vault ansible-lint && \
  # clean up
  apt-get clean && \
  rm -rf /tmp/*

# Copy scripts
ADD https://gist.githubusercontent.com/cenk1cenk2/e03d8610534a9c78f755c1c1ed93a293/raw/logger.sh /etc/vizier/scripts/logger.sh

COPY ./hostfs /
COPY --from=vizier /usr/bin/vizier /usr/bin/vizier

WORKDIR /ansible

ENTRYPOINT [ "vizier", "--config-file", "/etc/vizier.yml" ]

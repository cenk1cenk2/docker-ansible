ARG NODE_VERSION
ARG PYTHON_VERSION

FROM node:${NODE_VERSION} as nodejs

FROM python:${PYTHON_VERSION}

ARG S6_VERSION
ARG ANSIBLE_VERSION

# Install tini
WORKDIR /tmp

# Install s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && \
  # create directories
  mkdir -p /etc/services.d && mkdir -p /etc/cont-init.d && mkdir -p /s6-bin

COPY --from=nodejs /usr/local/bin/ /usr/local/bin/
COPY --from=nodejs /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=nodejs /opt/ /opt/

# Install missing basic system dependecies
RUN apt-get update && apt-get install -y --no-install-recommends git openssh-client vim && \
  yarn global add pnpm && \
  # smoke test for git
  git --version && \
  # smoke test for python3
  python3 --version && \
  pip3 --version && \
  # smoke test for node binaries
  node -v && \
  npm -v && \
  yarn -v && \
  npx -v && \
  pnpm -v && \
  # install pip dependencies
  pip3 install --upgrade pip && \
  pip3 install wheel setuptools setuptools-rust ansible==${ANSIBLE_VERSION} ansible-vault ansible-lint && \
  # clean up
  apt-get clean && \
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

#!/bin/bash

source /scripts/logger.sh

SCRIPT_NAME="${YELLOW}docker-ansible${RESET}"

## greet
log_this "Starting up..." "${SCRIPT_NAME}" "LIFETIME" "bottom"

log_this "$(python3 --version)" "${CYAN}PYTHON${RESET}"
log_this "$(pip3 --version)" "${CYAN}PIP${RESET}"
log_this "$(ansible --version)" "${CYAN}ANSIBLE${RESET}"
log_this "$(ansible-vault --version)" "${CYAN}ANSIBLE-VAULT${RESET}"
log_this "$(ansible-lint --version)" "${CYAN}ANSIBLE-LINT${RESET}"
log_this "$(node --version)" "${CYAN}NODE${RESET}"
log_this "$(npm --version)" "${CYAN}NPM${RESET}"
log_this "$(yarn --version)" "${CYAN}YARN${RESET}"

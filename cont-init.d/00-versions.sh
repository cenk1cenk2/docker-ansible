#!/bin/bash

source /scripts/logger.sh

SCRIPT_NAME="${YELLOW}docker-ansible${RESET}"

## greet
log_divider

log_this "Starting up..." "${SCRIPT_NAME}" "LIFETIME" "bottom"

log_this "$(python3 --version)" "${CYAN}PYTHON${RESET}" "LIFETIME"
log_this "$(pip3 --version)" "${CYAN}PIP${RESET}" "DEBUG"
log_this "$(ansible --version)" "${CYAN}ANSIBLE${RESET}" "LIFETIME"
log_this "$(ansible-vault --version)" "${CYAN}ANSIBLE-VAULT${RESET}" "DEBUG"
log_this "$(ansible-lint --version)" "${CYAN}ANSIBLE-LINT${RESET}" "DEBUG"
log_this "$(node --version)" "${CYAN}NODE${RESET}" "LIFETIME"
log_this "$(npm --version)" "${CYAN}NPM${RESET}" "DEBUG"
log_this "$(yarn --version)" "${CYAN}YARN${RESET}" "DEBUG"
log_this "$(pnpm --version)" "${CYAN}PNPM${RESET}" "DEBUG"

log_divider

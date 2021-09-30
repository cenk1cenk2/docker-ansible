#!/bin/bash

source /scripts/logger.sh

SCRIPT_NAME="${YELLOW}docker-ansible${RESET}"

## greet
log_this "Starting up..." "${SCRIPT_NAME}" "LIFETIME" "bottom"

log_this "$(ansible --version)" "${CYAN}ANSIBLE${RESET}"
log_this "$(python3 --version)" "${CYAN}PYTHON${RESET}"

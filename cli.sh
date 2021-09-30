#!/bin/bash

VERSION=20210929
CONTAINER_NAME=ansible

source <(curl -s "https://gist.githubusercontent.com/cenk1cenk2/e03d8610534a9c78f755c1c1ed93a293/raw/logger.sh")

SCRIPT_NAME="${YELLOW}run-in-docker${RESET}"

print_header() {
	log_this "${VERSION}" "${SCRIPT_NAME}" "LIFETIME" "bottom"
}

run_cli() {
	RUN_COMMAND="${*:1}"
	PACKAGE_INFO=${RUN_COMMAND}

	trap trap_int INT
	function trap_int() {
		log_interrupt "${PACKAGE_INFO}" "top"
	}

	# run command missing
	if [ -z "${RUN_COMMAND}" ]; then
		log_error "Please state a command to run."
		exit 127
	fi

	docker-compose exec ${CONTAINER_NAME} /bin/bash -c "echo -e '[${GREEN}START${RESET}] ${PACKAGE_INFO}\n${SEPARATOR}'; if [ -f .env ]; then source .env && echo -e '[${YELLOW}env${RESET}] Sourced .env file.\n${SEPARATOR}'; fi && ${RUN_COMMAND} && echo -e '${SEPARATOR}\n[${GREEN}FINISH${RESET}] ${PACKAGE_INFO}' || echo -e '${SEPARATOR}\n[${RED}ERROR${RESET}] ${PACKAGE_INFO}'"
}

print_header
run_cli "${*}"

#!/bin/bash

source /scripts/logger.sh

## initate-variables.sh, version 20210824
# set REQUIRED_VARIABLES_NAME for variables required
# set OPTIONAL_VARIABLES_NAME and OPTIONAL_VARIABLES_DEFAULTS for initiating rest of variables

## required variables
log_start "Testing required environment variables..."

REQUIRED_VARIABLES_NAME=("ANSIBLE_ROLES_FOLDER" "ANSIBLE_ROLES_INSTALL_COMMAND")

for i in "${!REQUIRED_VARIABLES_NAME[@]}"; do
	VALUE=${!REQUIRED_VARIABLES_NAME[$i]}
	[ -z "${VALUE}" ] && log_error "${REQUIRED_VARIABLES_NAME[$i]} is unset." && REQUIRED_VARIABLE_IS_UNSET=true
done

if [ -n "$REQUIRED_VARIABLE_IS_UNSET" ]; then
	log_error "Can not run without the required variables."
	exit 127
else
	log_finish "All required environment variables are in place."
fi

## optional variables
OPTIONAL_VARIABLES_NAME=("ANSIBLE_COLLECTIONS_FOLDER" "ANSIBLE_COLLECTIONS_INSTALL_COMMAND" "SKIP_INSTALL")
OPTIONAL_VARIABLES_DEFAULTS=("" "" "false")

for i in "${!OPTIONAL_VARIABLES_NAME[@]}"; do
	VALUE=${!OPTIONAL_VARIABLES_NAME[$i]}
	if [ -z "${VALUE}" ]; then
		log_debug "${OPTIONAL_VARIABLES_NAME[$i]} is not set using default: ${OPTIONAL_VARIABLES_DEFAULTS[$i]}"
		eval "export ${OPTIONAL_VARIABLES_NAME[$i]}=${OPTIONAL_VARIABLES_DEFAULTS[$i]}"
	fi
done

## END initate-variables.sh

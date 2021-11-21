#!/bin/bash

source /scripts/logger.sh

if [ -n "${SKIP_INSTALL}" ] && [ "${SKIP_INSTALL}" == "true" ]; then
	log_debug "Installing roles is disabled by SKIP_INSTALL environment variable."
else
	cd /ansible

	if [ -n "${ANSIBLE_ROLES_FOLDER}" ] && [ ! -d "/ansible/${ANSIBLE_ROLES_FOLDER}" ]; then
		log_info "Roles are not found in expected folder \"./${ANSIBLE_ROLES_FOLDER}\", will install them first."

		eval "${ANSIBLE_ROLES_INSTALL_COMMAND}"
	fi

	if [ -n "${ANSIBLE_COLLECTIONS_FOLDER}" ] && [ ! -d "/ansible/${ANSIBLE_COLLECTIONS_FOLDER}" ]; then
		log_info "Collections are not found in expected folder \"./${ANSIBLE_COLLECTIONS_FOLDER}\", will install them first."

		if [ -n "${ANSIBLE_COLLECTIONS_INSTALL_COMMAND}" ]; then
			eval "${ANSIBLE_ROLES_INSTALL_COMMAND}"
		else
			log_warn "Install command for collections is optional and not defined. Please define it with ANSIBLE_ROLES_INSTALL_COMMAND environment variable."
		fi
	fi
fi

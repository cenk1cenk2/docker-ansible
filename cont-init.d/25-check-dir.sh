#!/bin/bash

source /scripts/logger.sh

if [ ! -d "/ansible" ]; then
	log_error "Ansible folder is not mounted at expected location: /ansible"

	exit 127
fi

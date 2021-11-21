#!/bin/bash

source /scripts/logger.sh

if [ ! -f /git/.gitconfig ]; then
	log_warn ".gitconfig file can be mounted to directory to use git inside the container: /git"
fi

log_debug "Copying gitconfig to user home."

cp /git/.gitconfig "$HOME/"

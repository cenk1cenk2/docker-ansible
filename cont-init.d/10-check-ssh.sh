#!/bin/bash

source /scripts/logger.sh

if [ ! -d /ssh ]; then
	log_error 'SSH directory of the user has to mounted to "/ssh" to have access to the servers.'
	exit 127
fi

mkdir -p "$HOME/.ssh"
rm -r "$HOME/.ssh/"
cp -r /ssh/ "$HOME/.ssh/"
chmod -R 600 "$HOME/.ssh/"

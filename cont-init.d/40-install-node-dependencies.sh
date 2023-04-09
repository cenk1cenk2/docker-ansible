#!/bin/bash

source /scripts/logger.sh

if [ -n "${SKIP_NODE_INSTALL}" ] && [ "${SKIP_NODE_INSTALL}" == "true" ]; then
	log_debug "Installing node.js dependencies is disabled by SKIP_NODE_INSTALL environment variable."
else
	cd /ansible

	if [ -d "node_modules" ]; then
		log_debug "node.js dependencies are already installed."
	else
		log_info "node.js dependencies will be installed."
		if [ -f "pnpm-lock.yaml" ]; then
			log_debug "\"pnpm-lock.yaml\" file found. node.js dependencies will be installed through pnpm."
			pnpm install
		elif [ -f "yarn.lock" ]; then
			log_debug "\"yarn.lock\" file found. node.js dependencies will be installed through yarn."
			yarn install
		else
			log_debug "node.js dependencies will be installed through npm."
			npm install
		fi
	fi
fi

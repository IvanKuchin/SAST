#!/bin/bash

############
# DEFAULTS #
############
GITHUB_TOKEN="${GITHUB_TOKEN}"
GITHUB_API='https://api.github.com' 		# API url
GITHUB_EVENT_NAME="${GITHUB_EVENT_NAME}"	# push or pull
GITHUB_EVENT_PATH="${GITHUB_EVENT_PATH}"	# The path of the file with the complete webhook event payload.

#########################
# Flawfinder parameters #
#########################
dataonly="${INPUT_dataonly}"            	# Flawfinder --dataonly
source_code="${INPUT_source_code}"      	# Flawfinder source code file or source root directory

#########################
# Source Function Files #
#########################
source "/log.sh"


Header() {
	info "--------------------------------"
	info "----------- Header -------------"
	info "--------------------------------"
}

CheckInputValidity() {
	if [[ -z "$GITHUB_TOKEN" ]]; then
		fatal "The GITHUB_TOKEN is required."
	fi
	
    if [ -z "${dataonly}" ]; then
      error "Failed to get [dataonly]!"
      fatal "[${dataonly}]"
    else
      info "Successfully found:${F[W]}[dataonly]${F[B]}, value:${F[W]}[${dataonly}]"
    fi

    if [ -z "${source_code}" ]; then
      error "Failed to get [source_code]!"
      fatal "[${source_code}]"
    else
      info "Successfully found:${F[W]}[source_code]${F[B]}, value:${F[W]}[${source_code}]"
    fi

    if [ -z "${GITHUB_EVENT_NAME}" ]; then
      error "Failed to get [GITHUB_EVENT_NAME]!"
      fatal "[${GITHUB_EVENT_NAME}]"
    else
      info "Successfully found:${F[W]}[GITHUB_EVENT_NAME]${F[B]}, value:${F[W]}[${GITHUB_EVENT_NAME}]"
    fi

    if [ -z "${GITHUB_EVENT_PATH}" ]; then
      error "Failed to get [GITHUB_EVENT_PATH]!"
      fatal "[${GITHUB_EVENT_PATH}]"
    else
      info "Successfully found:${F[W]}[GITHUB_EVENT_PATH]${F[B]}, value:${F[W]}[${GITHUB_EVENT_PATH}]"
    fi


}

Footer() {
	info "--------------------------------"
	info "----------- Footer -------------"
	info "--------------------------------"
}




Header
Footer

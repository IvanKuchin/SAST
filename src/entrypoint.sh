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

###########
# Globals #
###########
EXIT_CODE=0
OWNER=""
REPO=""
COMMIT_SHA=""

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

CheckPushValidity() {

    if [ -z "${GITHUB_REPOSITORY}" ]; then
      error "Failed to get [GITHUB_REPOSITORY]!"
      fatal "[${GITHUB_REPOSITORY}]"
    else
      info "Successfully found:${F[W]}[GITHUB_REPOSITORY]${F[B]}, value:${F[W]}[${GITHUB_REPOSITORY}]"
    fi

    if [ -z "${GITHUB_SHA}" ]; then
      error "Failed to get [GITHUB_SHA]!"
      fatal "[${GITHUB_SHA}]"
    else
      info "Successfully found:${F[W]}[GITHUB_SHA]${F[B]}, value:${F[W]}[${GITHUB_SHA}]"
    fi

}

BuildShellCommands() {
	info "--------------------------------------------"
	info "----------- BuildShellCommands -------------"
	info "--------------------------------------------"

	shell_command1="flawfinder --dataonly --quiet ${source_code}"

	info "${shell_command1}"
}

SetOwnerVar() {
	info "-------------------------------------"
	info "----------- SetOwnerVar -------------"
	info "-------------------------------------"

	OWNER=${GITHUB_REPOSITORY%%/*}

	info "----------- ${OWNER} --------------"
}

SetRepoVar() {
	info "-------------------------------------"
	info "----------- SetRepoVar --------------"
	info "-------------------------------------"

	REPO=${GITHUB_REPOSITORY##*/}

	info "----------- ${REPO} --------------"
}

SetSHAVar() {
	info "------------------------------------"
	info "----------- SetSHAVar --------------"
	info "------------------------------------"

	COMMIT_SHA=${GITHUB_SHA}

	info "----------- ${COMMIT_SHA} --------------"
}

RunShellCommands() {
	info "------------------------------------------"
	info "----------- RunShellCommands -------------"
	info "------------------------------------------"

	output1=`${shell_command1}`

	debug "${output1}"
}

AddComment() {
	info "------------------------------------"
	info "----------- AddComment -------------"
	info "------------------------------------"

	PAYLOAD=$(echo '{}' | jq --arg body "$output1" '.body = $body')

	if [[ "${GITHUB_EVENT_NAME}" == "pull" ]]; then

		COMMENTS_URL=$(cat $GITHUB_EVENT_PATH | jq -r .pull_request.comments_url)
		curl -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/vnd.github.VERSION.text+json" --data "$PAYLOAD" "$COMMENTS_URL"

	elif [[ "${GITHUB_EVENT_NAME}" == "push" ]]; then

		CheckPushValidity
		SetOwnerVar
		SetRepoVar
		SetSHAVar

		COMMENTS_URL="https://api.github.com/repos/${OWNER}/${REPO}/commits/${COMMIT_SHA}/comments"
		info "------------ ${COMMENTS_URL} ------------"
		curl -S -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/vnd.github.VERSION.text+json" --data "$PAYLOAD" "$COMMENTS_URL"
	else
		fatal "----------- Unknown GITHUB_EVENT_NAME (${GITHUB_EVENT_NAME}) -------------"
	fi
}

Footer() {
	info "--------------------------------"
	info "----------- Footer -------------"
	info "--------------------------------"
}

SetExitCode() {
	###############
	# Flaws found #
	###############
	exit 1
}


Header

CheckInputValidity

BuildShellCommands

RunShellCommands

if [ ${#output1} -gt "20" ]; then
	AddComment

	EXIT_CODE=1
fi

Footer

exit ${EXIT_CODE}

#!/bin/bash

if [[ -z "$INPUT_GITHUB_TOKEN" ]]; then
	echo "The GITHUB_TOKEN is required."
	exit 1
fi

env

ls -la

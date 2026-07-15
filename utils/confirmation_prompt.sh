#!/usr/bin/env bash

parse_yes_no() {
	local REPLY
	REPLY=$(echo "$1" | tr '[:upper:]' '[:lower:]' | grep -E "^(y(es)?|n(o)?)$")

	case $REPLY in
	y | yes) echo 0 ;;
	n | no) echo 1 ;;
	*) echo 2 ;;
	esac
}

confirmation_prompt() {
	local PROMPT="${1:-""}"
	local RETRY_PROMPT="${2:-"Please select, Y/N "}"
	local REPLY
	local PARSED_REPLY

	read -rp "${PROMPT:+$PROMPT }" REPLY
	PARSED_REPLY=$(parse_yes_no "$REPLY")

	while [[ $PARSED_REPLY -eq 2 ]]; do
		read -rp "$RETRY_PROMPT" REPLY
		PARSED_REPLY=$(parse_yes_no "$REPLY")
	done

	return "$PARSED_REPLY"
}

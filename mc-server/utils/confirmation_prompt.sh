#!/bin/bash

confirmation_prompt() {
	local PROMPT=$1
	local REPLY
	local VALID_REPLY

	while [ -z "$VALID_REPLY" ]; do
		read -rp "$PROMPT, Y/N: " REPLY
		REPLY=$(echo "$REPLY" | tr '[:upper:]' '[:lower:]')
		VALID_REPLY=$(echo "$REPLY" | grep -E "^(y|n)$")
	done

	echo "$VALID_REPLY"
}

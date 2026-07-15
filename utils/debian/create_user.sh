#!/usr/bin/env bash
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

main() {
	local USERNAME=${1:?"Username not set"}
	local USERNAME_FIRST_LETTER=${USERNAME:0:1}
	local USERNAME_CAPITALIZED=${USERNAME_FIRST_LETTER^^}${USERNAME:1}
	local COMMENT=${2:-$USERNAME_CAPITALIZED}
	local PASSWORD
	# TODO: make password optional or prompt for an automatically generated one
	# TODO: make the generated password have an option for human readable with random words from dict
	PASSWORD=$(openssl rand -base64 15)

	adduser "$USERNAME" --disabled-password --comment "$COMMENT"
	# can also do passwd -d $username

	usermod -a -G sudo "$USERNAME"
	"$PROJECT_ROOT"/set_user_password.exp "$USERNAME" "$PASSWORD"
}

main "$@"
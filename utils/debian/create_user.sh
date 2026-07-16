#!/usr/bin/env bash
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

configure_user() {
	local USERNAME=$1
	local PASSWORD=$2
	local USERNAME_FIRST_LETTER=${USERNAME:0:1}
	local USERNAME_CAPITALIZED=${USERNAME_FIRST_LETTER^^}${USERNAME:1}

	adduser "$USERNAME" --disabled-password --comment "$USERNAME_CAPITALIZED"
	usermod -a -G sudo "$USERNAME"
	"$PROJECT_ROOT"/set_user_password.exp "$USERNAME" "$PASSWORD"
}

main() {
	local USERNAME=${1:?"Username not set"}
	local PASSWORD=$2

	if [ -z "$PASSWORD" ]; then
		# TODO: make password optional or prompt for an automatically generated one
		# TODO: make the generated password have an option for human readable with random words from dict
		PASSWORD=$(openssl rand -base64 24)
		configure_user "$USERNAME" "$PASSWORD"
		echo Your password is "$PASSWORD", you can change it by typing passwd once logged in
	else
		configure_user "$USERNAME" "$PASSWORD"
	fi
}

main "$@"

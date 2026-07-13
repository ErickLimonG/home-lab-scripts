#!/usr/bin/env bash

source "$PROJECT_ROOT/utils/sudo.sh" || exit 1

_get_minecraft_server_pid() {
	local SERVER_PID
	SERVER_PID=$(fuser /var/lock/mc_server_running_lock 2>&- | grep -o '[0-9]*')
	echo "$SERVER_PID"
}

main() {
	sudo kill "$(_get_minecraft_server_pid)"
}

if [ "$0" = "${BASH_SOURCE[0]}" ]; then
	main "$@"
fi

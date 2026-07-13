#!/usr/bin/env bash
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

source "$PROJECT_ROOT/utils/sudo.sh" || exit 1

#TODO: add flag to force shutdown
_get_minecraft_server_pid() {
	local SERVER_PID
	SERVER_PID=$(fuser /var/lock/mc_server_running_lock 2>&- | grep -o '[0-9]*')
	echo "$SERVER_PID"
}

_is_mcrcon_installed() {
	if [ -e /usr/local/bin/mcrcon ] && [ -e /usr/local/share/man/man1/mcrcon.1 ]; then
		return 0
	else
		return 1
	fi
}

_stop_minecraft_server() {
	local RCON_ENABLED
	local RCON_PASSWORD
	local RCON_PORT

	RCON_ENABLED=$(grep enable-rcon <server/server.properties | cut -d "=" -f 2)
	RCON_PASSWORD=$(grep rcon.password <server/server.properties | cut -d "=" -f 2)
	RCON_PORT=$(grep rcon.port <server/server.properties | cut -d "=" -f 2)

	if ! _is_mcrcon_installed; then
		echo "ERROR: mcrcon is not installed" 1>&2
		exit 1
	fi

	if [ "$RCON_ENABLED" != "true" ]; then
		echo "ERROR: rcon is not enabled" 1>&2
		exit 1
	fi

	mcrcon -P "$RCON_PORT" -p "$RCON_PASSWORD" stop
}

main() {
	_stop_minecraft_server
}

if [ "$0" = "${BASH_SOURCE[0]}" ]; then
	main "$@"
fi

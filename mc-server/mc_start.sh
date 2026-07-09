#!/usr/bin/env bash
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

source "$PROJECT_ROOT/utils/confirmation_prompt.sh" || exit 1
source "$PROJECT_ROOT/utils/sudo.sh" || exit 1

_start_minecraft_server() {
	(
		[ -e "$PROJECT_ROOT/.server_has_run_once" ]
		local SERVER_HAS_RUN_ONCE=$?

		local MIN_MEMORY="${1:-1024}M"
		local MAX_MEMORY="${2:-2048}M"
		local SERVER_DIR="$PROJECT_ROOT/server"
		local START_MINECRAFT_SERVER_COMMAND="java -Xms$MIN_MEMORY -Xmx$MAX_MEMORY -jar server.jar --nogui"

		cd "$SERVER_DIR" || exit 1
		echo "Starting minecraft server with command: "
		"$START_MINECRAFT_SERVER_COMMAND"
		
		if [ "$SERVER_HAS_RUN_ONCE" ]; then
			# TODO: use flock to only allow one instance to run
			nohup java -Xms"$MIN_MEMORY" -Xmx"$MAX_MEMORY" -jar server.jar --nogui &
		else
			java -Xms"$MIN_MEMORY" -Xmx"$MAX_MEMORY" -jar server.jar --nogui
			# will close cause eula has not been accepted
			touch "$PROJECT_ROOT/.server_has_run_once"
		fi
	)
}

_eula_prompt() {
	local SERVER_DIR="$PROJECT_ROOT/server"
	local EULA="$SERVER_DIR/eula.txt"

	if grep -q "eula=true" "$EULA"; then
		return 2
	elif grep -q "eula=false" "$EULA"; then
		echo "Would you like to accept the Minecraft eula?, Y/N"
		echo "You can read it here https://account.mojang.com/documents/minecraft_eula"

		if confirmation_prompt; then
			sed -i "s/eula=false/eula=true/g" "$EULA"
		fi
	else
		echo "Error: $EULA not found"
		exit 1
	fi

}

_add_server_properties() {
	local SERVER_CONFIG="$PROJECT_ROOT/server/server.properties"
	local KEY=$1
	local VALUE=$2
	echo "$KEY=$VALUE" >>"$SERVER_CONFIG"
}

_configure_minecraft_rcon() {
	#https://minecraft.wiki/w/RCON
	local SERVER_CONFIG="$PROJECT_ROOT/server/server.properties"
	local PROMPT="Would you like to enable RCON?"
	if confirmation_prompt "$PROMPT"; then
		_add_server_properties "enable-rcon" "true"

		read -rsp "Please set a password" RCON_PASSWORD
		_add_server_properties "rcon.password" "$RCON_PASSWORD"

		read -rp "Select port from 1 to 65535, press Enter to select default (25575)" PORT
		_add_server_properties "rcon.port" "${PORT:-25575}"

		_add_server_properties "broadcast-rcon-to-ops" "false"
	fi
}

main() {
	local MIN_MEMORY="$1"
	local MAX_MEMORY="$2"

	_start_minecraft_server "$MIN_MEMORY" "$MAX_MEMORY"

	_eula_prompt
	EULA_PROMPT_EXIT_CODE=$?

	if $EULA_PROMPT_EXIT_CODE && [ -e "$PROJECT_ROOT/server/eula.txt" ] ; then
		_configure_minecraft_rcon
		_start_minecraft_server "$MIN_MEMORY" "$MAX_MEMORY"
	fi
}

if [ "$0" = "${BASH_SOURCE[0]}" ]; then
	main "$@"
fi

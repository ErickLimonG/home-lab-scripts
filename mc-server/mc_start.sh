#!/bin/bash
LOCAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$LOCAL_DIR/utils/confirmation_prompt.sh"
source "$LOCAL_DIR/utils/sudo.sh"

start_minecraft_server() {
	local MIN_MEMORY="${1:-1024}M"
	local MAX_MEMORY="${2:-2048}M"
	local SERVER_DIR="$LOCAL_DIR/server"

	cd "$SERVER_DIR" || exit
	echo "Starting minecraft server with"
	nohup java -Xms"$MIN_MEMORY" -Xmx"$MAX_MEMORY" -jar server.jar --nogui
}

eula_prompt() {
	local SERVER_DIR="$LOCAL_DIR/server"
	local EULA="$SERVER_DIR/eula.txt"

	if grep -q "eula=true" "$EULA"; then
		exit 0
	fi

	if [[ -e "$EULA" ]]; then
		echo "Would you like to accept the Minecraft eula?, Y/N"
		echo "You can read it here https://account.mojang.com/documents/minecraft_eula"

		if confirmation_prompt; then
			sed -i "s/eula=false/eula=true/g" "$SERVER_DIR/eula.txt"
		fi
	else
		echo "$EULA not found"
		exit 0
	fi
}

configure_minecraft_rcon() {
	#https://minecraft.wiki/w/RCON
	# TODO: add rcon keys in server.config
	echo "pending"
}

main() {
	local MIN_MEMORY="$1"
	local MAX_MEMORY="$2"
	start_minecraft_server "$MIN_MEMORY" "$MAX_MEMORY"
	eula_prompt
}

main "$@"

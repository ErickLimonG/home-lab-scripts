#!/usr/bin/env bash
PROJECT_ROOT="$(git rev-parse --show-toplevel)/mc-server"

source "$PROJECT_ROOT/tests/test-helper/close_non_std_fds.bash" || exit 1

start_minecraft_server() {
	(
		flock -n 200 || exit 1
		local MIN_MEMORY="${1:-1024}M"
		local MAX_MEMORY="${2:-2048}M"
		local SERVER_DIR="$PROJECT_ROOT/server"
		local START_MINECRAFT_SERVER_COMMAND="java -Xms$MIN_MEMORY -Xmx$MAX_MEMORY -jar server.jar --nogui"

		cd "$SERVER_DIR" || exit 1
		echo "Starting minecraft server with command: "
		echo "$START_MINECRAFT_SERVER_COMMAND"
		
		java -Xms"$MIN_MEMORY" -Xmx"$MAX_MEMORY" -jar server.jar --nogui
	) 200>/var/lock/mc_server_running_lock

	if [ $? -ne 0 ]; then
		echo "Error: A server instance is already running"
	fi
}

if [ "$0" = "${BASH_SOURCE[0]}" ]; then
	start_minecraft_server
fi
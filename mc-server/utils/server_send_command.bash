#!/usr/bin/env bash
PROJECT_ROOT="$(git rev-parse --show-toplevel)"
MC_SERVER_ROOT="$PROJECT_ROOT/mc-server"

source "$MC_SERVER_ROOT/utils/load_dotenv.bash" || exit 1

server_send_command() {
	local RECEIVED_COMMAND="${1:?ERROR: send_command command needed and got nothing}"
	local TERMINAL_COUNT
	local TERMINAL_NAME
	TERMINAL_COUNT=$(screen -ls | grep -c "$SERVER_TERMINAL_ENV")

	if ((TERMINAL_COUNT>1)); then
		echo "Error: minecraft server terminal count is larger than 1" >&2
		exit 1
	fi

	TERMINAL_NAME=$(screen -ls | grep "$SERVER_TERMINAL_ENV" | awk '{print $1}')

	screen -S "$TERMINAL_NAME" -p0 -X stuff "$RECEIVED_COMMAND\n"
}

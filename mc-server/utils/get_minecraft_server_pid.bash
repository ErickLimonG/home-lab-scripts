#!/usr/bin/env bash

get_minecraft_server_pid() {
	local SERVER_PID
	SERVER_PID=$(fuser /var/lock/mc_server_running_lock 2>&- | grep -o '[0-9]*')
	echo "$SERVER_PID"
}


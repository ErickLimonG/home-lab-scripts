#!/bin/bash
LOCAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVER_DIR="$LOCAL_DIR/server"

# Source: https://askubuntu.com/a/937596
# and: https://nickjanetakis.com/blog/ignore-sudo-in-a-shell-script-if-you-are-running-as-root
sudo() {
	[[ "${EUID}" == 0 ]] || set -- command sudo "${@}"
	"${@}"
}

download_mcrcon() {
	(
		cd "$LOCAL_DIR" || exit
		local RELEASE_FILE="mcrcon-0.7.2-linux-x86-64-static"
		curl -OLs https://github.com/Tiiffi/mcrcon/releases/download/v0.7.2/$RELEASE_FILE.zip

		rm -rf mcrcon # remove extracted folder
		unzip $RELEASE_FILE.zip
		rm -f $RELEASE_FILE.zip
		mv $RELEASE_FILE mcrcon
	)
}

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

download_java() {
	if [ -z "$(command -v java)" ]; then
		ANSWER=$(confirmation_prompt "No jre instalation found, would you like to install it?")
		if [ $ANSWER = 'y' ]; then
			# https://adoptium.net/installation/linux/
			# TODO: Select jre automatically or let the user choose (maybe even give suggestions)
			# TODO: Detect linux distro and automatically download the package accordingly (or install the binary directly)
			sudo apt install -y wget apt-transport-https gpg
			wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/adoptium.gpg >/dev/null
			echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
			sudo apt update
			sudo apt install temurin-25-jre
		fi
	fi
}

download_server_jar() {
	local MINECRAFT_VERSION=$1
	local MC_SERVER_LIST_URL
	local MC_SERVER_LIST
	local MC_SERVER_LIST_FORMATTED
	local SERVER_URL

	if [ -z "$MINECRAFT_VERSION" ]; then
		echo "Write minecraft server version you would like to download ex. 1.7.10"
		read -r MINECRAFT_VERSION
	fi

	# minecraft server jars
	# pulled from https://gist.github.com/cliffano/77a982a7503669c3e1acb0a0cf6127e9
	MC_SERVER_LIST_URL="https://gist.githubusercontent.com/cliffano/77a982a7503669c3e1acb0a0cf6127e9/raw/3b92a48d565403a877ebc8209357b59870b9cb6c/minecraft-server-jar-downloads.md"
	
	MC_SERVER_LIST=$(curl -s $MC_SERVER_LIST_URL | tail -n +3)
	MC_SERVER_LIST_FORMATTED=$(echo "$MC_SERVER_LIST" | cut -d '|' -f 2,3)
	SERVER_URL=$(echo "$MC_SERVER_LIST_FORMATTED" | grep "^\s*$MINECRAFT_VERSION\s" | cut -d '|' -f 2 | tr -d ' \t\n')

	if [ -z "$SERVER_URL" ]; then
		echo "Error: Minecraft version not found, try another version"
		exit 1
	fi

	mkdir -p $SERVER_DIR
	rm -f "$SERVER_DIR/server.jar"
	curl -s -o "$SERVER_DIR/server.jar" "$SERVER_URL"
}

main() {
	download_server_jar "$@"
	download_java
	download_mcrcon
}

main "$@"

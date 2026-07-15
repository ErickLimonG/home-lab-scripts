#!/usr/bin/env bash

_sshd_config_add_key() {
	local KEY=$1
	local VALUE=$2
	local SSHD_CONFIG="/etc/ssh/sshd_config"

    if sudo grep -q "^#*$KEY " "$SSHD_CONFIG"; then
        sudo sed -i "s/^#*$KEY .*/$KEY $VALUE/" "$SSHD_CONFIG"
    else
        echo "$KEY $VALUE" | sudo tee -a "$SSHD_CONFIG" > /dev/null
    fi
}

main() {
	_sshd_config_add_key PermitRootLogin no
	_sshd_config_add_key PubkeyAuthentication yes
	_sshd_config_add_key PasswordAuthentication yes
	_sshd_config_add_key KbdInteractiveAuthentication yes
	sudo systemctl restart ssh
}

main "$@"
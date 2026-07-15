#!/usr/bin/env bash

check_root_permission() {
	if [ $(id -u) -ne 0 ]; then
		echo "ERROR: You need sudo or root to run this script"
		exit 1
	fi
}

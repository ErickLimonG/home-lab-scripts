#!/usr/bin/env bash
# Source: https://askubuntu.com/a/937596
# and: https://nickjanetakis.com/blog/ignore-sudo-in-a-shell-script-if-you-are-running-as-root
sudo() {
	[[ "${EUID}" == 0 ]] || set -- command sudo "${@}"
	"${@}"
}

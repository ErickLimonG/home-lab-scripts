#!/usr/bin/env bash

uninstall_mcrcon() {
    sudo rm -rf /usr/local/bin/mcrcon /usr/local/share/man/man1/mcrcon.1
}

remove_sever_files() {
	(    
        cd "$PROJECT_ROOT" || exit 1
        rm -rf server mcrcon
    )	
}

cleanup-install(){
	uninstall_mcrcon
	remove_sever_files
	# TODO: add stop server (when the timeout and retries are implemented)
}
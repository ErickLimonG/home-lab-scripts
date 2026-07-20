#!/usr/bin/env bash
shopt -s extglob

uninstall_mcrcon() {
    rm -rf /usr/local/bin/mcrcon /usr/local/share/man/man1/mcrcon.1
}

remove_sever_files() {
	(    
        cd "$PROJECT_ROOT" || exit 1
        rm -rf server/!(server.jar)
    )	
}

cleanup-install(){
	uninstall_mcrcon
	remove_sever_files
	# TODO: add stop server (when the timeout and retries are implemented)
}
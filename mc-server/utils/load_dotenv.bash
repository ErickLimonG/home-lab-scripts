#!/usr/bin/env bash
PROJECT_ROOT="$(git rev-parse --show-toplevel)"
MC_SERVER_ROOT="$PROJECT_ROOT/mc-server"
# based on https://gist.github.com/mihow/9c7f559807069a03e302605691f85572

set -a 
SERVER_TERMINAL_ENV=mc_server_terminal
LOG_FILE_ENV="$MC_SERVER_ROOT"/server/mc_server_log.txt
set +a
#!/usr/bin/env bats
setup() {
    load "test_helper/common-setup"
    _common_setup
    source "$PROJECT_ROOT/mc-start.sh"
}

teardown() {
    rm -rf "$PROJECT_ROOT/server"
}

@test "_configure_minecraft_rcon" {
    [[ true ]]
}
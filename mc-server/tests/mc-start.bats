#!/usr/bin/env bats
shopt -s extglob

cleanup() {
    cd "$PROJECT_ROOT" || exit 1
    rm -rf server/!(server.jar)
}

setup() {
    load "test_helper/common-setup"
    common_setup
    rm -rf "$PROJECT_ROOT/server/!(server.jar)"
    ( cleanup )
}

teardown() {
    ( cleanup )
}

@test "1 - e2e " {
    run mc_start_first_run_e2e.exp
    assert_success
}
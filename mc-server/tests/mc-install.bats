#!/usr/bin/env bats

setup() {
    load "test_helper/common-setup"
    load "test_helper/cleanup-install.bash"
    
    common_setup
    cleanup-install
}

teardown() {
    cleanup-install
}

@test "1 - Run mc_install script" {
    run "$PROJECT_ROOT/tests/mc_install.exp"
    assert_success
    assert_file_exists "$PROJECT_ROOT"/server/server.jar
    assert_file_exists /usr/local/bin/mcrcon
    assert_file_exists /usr/local/share/man/man1/mcrcon.1
}
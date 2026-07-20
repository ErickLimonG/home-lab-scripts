#!/usr/bin/env bats

setup_file() {
    load "test-helper/cleanup-install"

    cleanup-install
}

setup() {
    load "test-helper/common-setup"
    
    common_setup
}

teardown_file() {
    load "test-helper/cleanup-install"
    
    cleanup-install
}

@test "1 - Run mc_install" {
    run mc_install.exp
    assert_success
    assert_file_exists "$PROJECT_ROOT"/server/server.jar
    assert_file_exists /usr/local/bin/mcrcon
    assert_file_exists /usr/local/share/man/man1/mcrcon.1
}

@test "2 - Run mc_start " {
    run mc_start.exp
    assert_success
    assert_file_contains "$PROJECT_ROOT"/server/eula.txt 'eula=true'
    assert_file_exists "$PROJECT_ROOT"/server/server.properties
}
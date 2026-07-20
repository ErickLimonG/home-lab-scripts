#!/usr/bin/env bats

setup() {
    load "test-helper/common-setup"
    load "test-helper/cleanup-install.bash"
    
    common_setup
    cleanup-install
    bash mc_install.exp
}

teardown() {
    cleanup-install
}

@test "1 - pending " {
    run mc_start.exp
    assert_success
}
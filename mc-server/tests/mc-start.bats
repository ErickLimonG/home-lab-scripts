#!/usr/bin/env bats

setup() {
    load "test_helper/common-setup"
    load "test_helper/cleanup-install.bash"
    
    common_setup
    cleanup-install
    bash mc_install.exp
}

teardown() {
    cleanup
}

@test "1 - pending " {
    run mc_start.exp
    assert_success
}
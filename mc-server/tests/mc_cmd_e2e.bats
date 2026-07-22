#!/usr/bin/env bats

setup_file() {
    load "test-helper/cleanup-install"
    load "test-helper/common-setup"
    bash mc_stop
}

setup() {
    load "test-helper/common-setup"
    
    common_setup
}

teardown_file() {
    bash mc_stop
}

@test "1 - Run mc_install" {
    if [ -d "$PROJECT_ROOT/server" ]; then
        sed -i 's/eula=true/eula=false/' "$PROJECT_ROOT"/server/eula.txt
        skip "Server directory already exists"
    fi

    run mc_install.exp
    assert_success

    assert_file_exists "$PROJECT_ROOT"/server/server.jar
    assert_file_exists /usr/local/bin/mcrcon
    assert_file_exists /usr/local/share/man/man1/mcrcon.1
}

@test "2 - Run mc_start " {
    source "$PROJECT_ROOT/utils/get_minecraft_server_pid.bash"

    run mc_start.exp
    assert_success
    
    assert_file_contains "$PROJECT_ROOT"/server/eula.txt 'eula=true'
    assert_file_exists "$PROJECT_ROOT"/server/server.properties
    # check if the minecraft server is running
    run get_minecraft_server_pid
    assert_output
}
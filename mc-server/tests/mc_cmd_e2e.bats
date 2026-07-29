#!/usr/bin/env bats

setup_file() {
    load "test-helper/common_setup"
    bash mc_stop
}

setup() {
    load "test-helper/common_setup"
    
    common_setup
}

@test "1 - Run mc_install" {
    if [ -d "$MC_SERVER_ROOT/server" ]; then
        sed -i 's/eula=true/eula=false/' "$MC_SERVER_ROOT"/server/eula.txt
        skip "Server directory already exists"
    fi

    run mc_install.exp
    assert_success

    assert_file_exists "$MC_SERVER_ROOT"/server/server.jar
    assert_file_exists /usr/local/bin/mcrcon
    assert_file_exists /usr/local/share/man/man1/mcrcon.1
}

@test "2 - Run mc_start" {
    source "$MC_SERVER_ROOT/utils/get_minecraft_server_pid.bash"
    run mc_start.exp
    assert_success
    
    assert_file_contains "$MC_SERVER_ROOT"/server/eula.txt 'eula=true'
    assert_file_exists "$MC_SERVER_ROOT"/server/server.properties
    # check if the minecraft server is running
    run get_minecraft_server_pid
    assert_output
}

@test "3 - Run mc_stop" {
    source "$MC_SERVER_ROOT/utils/get_minecraft_server_pid.bash"
    run mc_stop
    assert_success
}

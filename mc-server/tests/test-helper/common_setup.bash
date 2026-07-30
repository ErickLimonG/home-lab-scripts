#!/usr/bin/env bash

common_setup() {
	# get the containing directory of this file
	# use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
	# as those will point to the bats executable's location or the preprocessed file respectively
	PROJECT_ROOT="$(git rev-parse --show-toplevel)"
	MC_SERVER_ROOT="$PROJECT_ROOT/mc-server"
	BATS_LIBS="$PROJECT_ROOT/test"

	# make executables in src/ visible to PATH
	PATH="$MC_SERVER_ROOT:$PATH"
	PATH="$MC_SERVER_ROOT/tests:$PATH"

    load "$BATS_LIBS/bats-support/load"
    load "$BATS_LIBS/bats-assert/load"
	load "$BATS_LIBS/bats-file/load"
}

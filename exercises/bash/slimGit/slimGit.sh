#!/bin/bash

# Some global variables...
tracker_file=.tracker
branch_dir=.slimGit-

# Display how to use the program.
function usage {
    cat <<EOF

    Welcome to slimGit, a slim, mini, micro, tiny, pocket-sized,
    liliputian version control system implemented in bash.

    Here's how to use it:

    init: start the version control of a project
    $0 init

    commit: save a version of you project
    $0 commit "commit message"

    log: display the version of your project
    $0 log

    ohMaGodIFuckedUp: revert to an older version of your project
    $0 ohMaGodIFuckedUp commitNumber

    branch: create a new branch of your project
    $0 branch branchName

    checkout: switch between branches
    $0 checkout branchName

    merge: merge two branches together
    $0 merge branchName

    clean: delete every files / directories used for the slimGit repository
    $0 clean

    Thank you for choosing slimGit.

EOF
    exit
}

# Display a specific error message
# and end the script
function error {
    echo "Error: $1"
    exit 1
}

## Core functions

function init {
    echo "INIT"
}

function commit {
    echo "COMMIT"
}

function log {
    echo "LOG"
}

function ohMaGodIFuckedUp {
    echo "OHMAGODIFUCKEDUP"
}

function branch {
    echo "BRANCH"
}

function checkout {
    echo "CHECKOUT"
}

function merge {
    echo "MERGE"
}

function clean {
    echo "CLEAN"
}

## Program entry point

# If there's no argument, call the usage function.
[[ $# -eq 0 ]] && usage

# Getting the command to execute
com=$1
shift # the shift command discard the first arg. now $1 = $2

case $com in
    init)
        init "$@"
        ;;
    commit)
        commit "$@"
        ;;
    log)
        log "$@"
        ;;
    ohMaGodIFuckedUp)
        ohMaGodIFuckedUp "$@"
        ;;
    branch)
        branch "$@"
        ;;
    checkout)
        checkout "$@"
        ;;
    merge)
        merge "$@"
        ;;
    clean)
        clean "$@"
        ;;
    *)
        usage
        ;;
esac

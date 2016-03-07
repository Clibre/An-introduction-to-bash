#!/bin/bash

# Some global variables...
tracker_file=.tracker

# Display how to use the program.
function usage {
    cat <<EOF

    Welcome to slimGit, a slim, mini, micro, tiny, pocket-sized,
    liliputian version control system implemented in bash.

    Here's how to use it:

    init: start the version control of a project
    ./slimGit.sh init

    commit: save a version of you project
    ./slimGit.sh commit "commit message"

    log: display the version of your project
    ./slimGit.sh log

    ohMaGodIFuckedUp: revert to an older version of your project
    ./slimGit.sh ohMaGodIFuckedUp commitNumber

    branch: create a new branch of your project
    ./slimGit.sh branch branchName

    checkout: switch between branches
    ./slimGit.sh checkout branchName

    merge: merge two branches together
    ./slimGit.sh merge branchName

    Thank you for choosing slimGit.

EOF
    exit
}

# Display a specific error message
function error {
    echo "Error: $1"
    exit
}

# Check for the existence of the .tracker file and at least
# one .slimGit/ directory. Exit the program if they dont exist.
function validate_structure {
    [[ -f ".tracker" ]] || error "There's no slimGit repository in this directory"
    [[ -d ".slimGit" ]] || error "There's no slimGit repository in this directory"
}

function delete_current_flag {
    sed -i 's/\([^%]*\)%\([^%]*\)%\([^%]*\)%current$/\1%\2%\3/' $tracker_file
}

## Core functions

function init {
    echo "This is an init!"
    [[ -f ".tracker" ]] && error "There's already a slimGit repository in this directory"
    [[ -d ".slimGit" ]] && error "There's already a slimGit repository in this directory"
    touch .tracker
    mkdir .slimGit
    commit "initial commit"
}

function commit {
    echo "This is a commit!"
    validate_structure 

    # Check that the number of args is OK.
    [[ $# -eq 1 ]] || (echo "The commit option take one arg: the commit message." && usage)

    commit_message=$1

    # Check that the commit message isn't empty
    [[ $commit_message ]] || echo "The commit message must not be empty."

    # Look for the current branch
    branch=$(awk -F% '/current$/ {print $3}' $tracker_file)

    # if it's the initial commit, branch variable will be empty
    # and the commit number will have to be 1 on branch master.
    if [[ -z $branch ]]; then
        echo "1%$commit_message%master%current" > $tracker_file
    else
        # look for the next commit number
        commit_number=$(awk -F% "/.*%.*%$branch%/ {print \$1}" $tracker_file |
            sort -r |
            head --lines=1)
        (( commit_number=$commit_number + 1))

        delete_current_flag

        # add a record with the current flag
        echo "$commit_number%$commit_message%$branch%current" >> $tracker_file
    fi
}

function log {
    echo "This is a log!"
    validate_structure 
}

function ohMaGodIFuckedUp {
    echo "This is an ohMaGodIFuckedUp!"
    validate_structure 
}

function branch {
    echo "This is a branch!"
    validate_structure 
}

function checkout {
    echo "This is a checkout!"
    validate_structure 
}

function merge {
    echo "This is a merge!"
    validate_structure 
}




## Program entry point

# If there's no argument, call the usage function.
[[ $# -eq 0 ]] && usage

# Getting the command to execute
com=$1
shift # the shift command discard the first arg. now $1 = $2

case $com in
    init)
        init
        ;;
    commit)
        commit $@
        ;;
    log)
        log
        ;;
    ohMaGodIFuckedUp)
        ohMaGodIFuckedUp
        ;;
    branch)
        branch
        ;;
    checkout)
        checkout
        ;;
    merge)
        merge
        ;;
    *)
        usage
        ;;
esac

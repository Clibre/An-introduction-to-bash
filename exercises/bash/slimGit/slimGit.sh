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
# and end the script
function error {
    echo "Error: $1"
    exit
}

# Check for the existence of the .tracker file and at least
# one .slimGit/ directory. Exit the program if they dont exist.
function validate_structure {
    [[ -f ".tracker" ]] || error "There's no slimGit repository in this directory"
    [[ -d ".slimGit-master" ]] || error "There's no slimGit repository in this directory"
}

function delete_current_flag {
    sed -i 's/\([^%]*\)%\([^%]*\)%\([^%]*\)%current$/\1%\2%\3/' $tracker_file
}

# Copy the content of directory $1 to directory $2
# Except for the .tracker file, the slimGit.sh file and
# the .slimGit-branchName/ directories
function cp_directory_to {
    src=$1
    dest=$2
    # loop through every files of the src directory
    # wihtout the .tracker, slimGit.sh and .slimGit-branchName/
    for file in $(ls -A $src | sed -r '/^(\.tracker|(\.slimGit-[a-z]*|slimGit.sh))$/d'); do
        # copy recursively every file / directories
        cp -r $src/$file $dest/$file
    done
    
    # delete the vim .swp files
    rm -rf $dest/.*.*.swp
}

# Remove the content of the dir $1
function rm_dir_content {
    dir=$1
    # loop through every files of the src directory
    # wihtout the .tracker, slimGit.sh and .slimGit-branchName/
    for file in $(ls -A $src | sed -r '/^(\.tracker|(\.slimGit-[a-z]*|slimGit.sh))$/d'); do
        # delete recursively every file / directories
        rm -rf $dir/$file
    done
}

## Core functions

function init {
    # Check that the number of args is OK.
    [[ $# -eq 0 ]] || usage

    # Make sure there's not already a slimGit repository.
    [[ -f ".tracker" ]] && error "There's already a slimGit repository in this directory"
    [[ -d ".slimGit-master" ]] && error "There's already a slimGit repository in this directory"

    # create the structure of the slimGit repository.
    touch .tracker
    mkdir .slimGit-master

    # doing the initial commit.
    commit "initial commit"
}

function commit {
    validate_structure 

    # Check that the number of args is OK.
    [[ $# -eq 1 ]] || usage

    commit_message=$1

    # Check that the commit message isn't empty
    [[ $commit_message ]] || error "The commit message must not be empty."

    # Look for the current branch
    branch=$(awk -F% '/current$/ {print $3}' $tracker_file)

    # if it's the initial commit, branch variable will be empty
    # and the commit number will have to be 1 on branch master.
    if [[ -z $branch ]]; then
        commit_number=1
        branch=master
    else
        # look for the next commit number
        commit_number=$(awk -F% "/^[^%]*%[^%]*%$branch%?/ {print \$1}" $tracker_file |
            sort -rn |
            head --lines=1)
        (( commit_number=$commit_number + 1))

        delete_current_flag
    fi

    # add a record with the current flag
    echo "$commit_number%$commit_message%$branch%current" >> $tracker_file

    # create the commit directory
    commit_dir=.slimGit-$branch/commit$commit_number
    mkdir $commit_dir

    # copy the content of the directory
    cp_directory_to "." $commit_dir
}

function log {
    validate_structure 

    # Check that the number of args is OK.
    [[ $# -eq 0 ]] || usage

    # look for the current branch
    branch=$(awk -F% '/current$/ {print $3}' $tracker_file)

    # output every commit for the current branch
    format="commit #%s: %s\n\n"
    awk -F% "/^[^%]*%[^%]*%$branch%?/ {printf \"$format\", \$1, \$2}" $tracker_file
}

function ohMaGodIFuckedUp {
    validate_structure 

    # Check that the number of args is OK.
    [[ $# -eq 1 ]] || usage

    commit_number=$1

    # look for the current branch
    branch=$(awk -F% '/current$/ {print $3}' $tracker_file)

    # make sure that the commit number exists.
    grep -Eq "^$commit_number%[^%]*%$branch%?" $tracker_file
    [[ $? -eq 0 ]] || error "The commit #$commit_number doesn't exist on branch $branch"

    rm_dir_content "."

    # copy the content of the commit directory
    commit_dir=.slimGit-$branch/commit$commit_number
    cp_directory_to $commit_dir "."

    # change the current flag
    delete_current_flag
    sed -i "s/^$commit_number%\([^%]*\)%$branch/$commit_number%\1%$branch%current/" $tracker_file
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

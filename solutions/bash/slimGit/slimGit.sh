#!/bin/bash

# Some global variables...
tracker_file=.tracker
branch_dir=.slimGit-
commit_dir=commit
commit_number=1
current_branch=master

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

# Retrieve and put the latest commit number
# for the branch in $1 in the variable commit_number
function get_latest_commit {
    branch=$1
    commit_number=$(awk -F% "/^[^%]*%[^%]*%$branch%?/ {print \$1}" $tracker_file |
        sort -rn |
        head --lines=1)
}

# Retrieve and put the current branch name
# in the variable current_branch
function get_current_branch {
    current_branch=$(awk -F% '/current$/ {print $3}' $tracker_file)
}

# Check for the existence of the .tracker file and at least
# one .slimGit/ directory. Exit the program if they dont exist.
function validate_structure {
    [[ -f $tracker_file ]] || error "There's no slimGit repository in this directory"
    [[ -d ${branch_dir}master ]] || error "There's no slimGit repository in this directory"
}

# move the current flag to the record of
# commit $1 and branch $2
function move_current_flag {
    commit_number=$1
    branch=$2
    delete_current_flag
    sed -i "s/^$commit_number%\([^%]*\)%$branch/$commit_number%\1%$branch%current/" $tracker_file
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
    for file in $(ls -A $src | sed -r '/^(\.tracker|(\.slimGit-[-_a-zA-Z0-9]*|slimGit.sh))$/d'); do
        # copy recursively every file / directories
        cp -r $src/$file $dest/$file
    done
    
    # delete the vim .swp files
    rm -rf $dest/.*.*.swp
    rm -rf $dest/.*.swp
}

# Remove the content of the dir $1
function rm_dir_content {
    dir=$1
    # loop through every files of the src directory
    # wihtout the .tracker, slimGit.sh and .slimGit-branchName/
    for file in $(ls -A $src | sed -r '/^(\.tracker|(\.slimGit-[-_a-zA-Z0-9]*|slimGit.sh))$/d'); do
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
    touch $tracker_file
    mkdir ${branch_dir}master

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

    get_current_branch

    # if it's the initial commit, branch variable will be empty
    # and the commit number will have to be 1 on branch master.
    if [[ -z $current_branch ]]; then
        current_branch=master
    else
        # look for the next commit number
        get_latest_commit $current_branch
        (( commit_number=$commit_number + 1))

        delete_current_flag
    fi

    # add a record with the current flag
    echo "$commit_number%$commit_message%$current_branch%current" >> $tracker_file

    # create the commit directory
    commit_path=${branch_dir}$current_branch/${commit_dir}$commit_number
    mkdir $commit_path

    # copy the content of the directory
    cp_directory_to "." $commit_path
}

function log {
    validate_structure 

    # Check that the number of args is OK.
    [[ $# -eq 0 ]] || usage

    get_current_branch

    # output every commit for the current branch
    format="commit #%s: %s\n\n"
    awk -F% "/^[^%]*%[^%]*%$current_branch%?/ {printf \"$format\", \$1, \$2}" $tracker_file
}

function ohMaGodIFuckedUp {
    validate_structure 

    # Check that the number of args is OK.
    [[ $# -eq 1 ]] || usage

    commit_number=$1

    get_current_branch

    # make sure that the commit number exists.
    grep -Eq "^$commit_number%[^%]*%$current_branch%?" $tracker_file
    [[ $? -eq 0 ]] || error "The commit #$commit_number doesn't exist on branch $current_branch"

    rm_dir_content "."

    # copy the content of the commit directory
    commit_path=${branch_dir}$current_branch/${commit_dir}$commit_number
    cp_directory_to $commit_path "."

    move_current_flag $commit_number $current_branch
}

function branch {
    validate_structure 

    # Check that the number of args is OK.
    [[ $# -eq 1 ]] || usage

    branch_name=$1

    # make sure that the branch doesn't already exist
    [[ -d ${branch_dir}$branch_name ]] && error "The branch $branch_name already exists"

    # create the directories..
    mkdir ${branch_dir}$branch_name
    commit_path=${branch_dir}$branch_name/${commit_dir}1
    mkdir $commit_path

    cp_directory_to "." $commit_path

    # add a record in the .tracker file
    echo "1%start of branch $branch_name%$branch_name" >> $tracker_file
}

function checkout {
    validate_structure 

    # Check that the number of args is OK.
    [[ $# -eq 1 ]] || usage

    branch_name=$1

    # make sure that the branch exist
    [[ -d ${branch_dir}$branch_name ]] || error "The branch $branch_name doesn't exists"

    get_latest_commit $branch_name

    rm_dir_content "."

    src_path=${branch_dir}$branch_name/${commit_dir}$commit_number
    cp_directory_to $src_path "."

    move_current_flag $commit_number $branch_name
}

function merge {
    validate_structure 

    # Check that the number of args is OK.
    [[ $# -eq 1 ]] || usage

    branch_name=$1

    # make sure that the branch to be merged is not
    # the master branch
    [[ $branch_name != "master" ]] || error "You can't merge the master branch"

    # make sure that the branch to be merged exists
    [[ -d ${branch_dir}$branch_name ]] || error "The branch $branch_name doesn't exist"

    get_current_branch

    # make sure that the current branch is not the branch
    # we want to merge
    [[ $current_branch != $branch_name ]] || error "You can't merge the branch $branch_name with the branch $current_branch"

    get_latest_commit $branch_name

    rm_dir_content "."

    src_path=${branch_dir}$branch_name/${commit_dir}$commit_number
    cp_directory_to $src_path "."

    commit "merge of branch $branch_name to $current_branch"

    # delete recursively the directory of the branch
    # that have been merged
    rm -rf ${branch_dir}$branch_name

    # delete every record of the branch that
    # have been merged
    sed -i "/^[^%]*%[^%]*%$branch_name/d" $tracker_file
}

function clean {
    validate_structure

    # Check that the number of args is OK.
    [[ $# -eq 0 ]] || usage

    # delete everything slimGit related...
    rm -rf ${branch_dir}*
    rm -rf $tracker_file
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

#!/bin/bash

function error {
    echo "Error: $1"
    exit
}

location=$(pwd)
output_file=$(echo $location | sed s/solutions/exercises/)/output.txt

[[ -e $output_file ]] || error "File $output_file doesn't exist"

diff -q $output_file answer.txt

if [[ $? -eq 0 ]];then
    echo "Great job. your answer is right!"
else
    echo "Wrong answer..."
    echo "Your answer is: "
    cat $output_file
    echo ". . . . . . . . . "
    echo "And the answer should be:"
    cat answer.txt
fi

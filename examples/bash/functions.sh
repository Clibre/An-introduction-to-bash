#!/bin/bash

function myFunction {
    [[ $# -eq 0 ]] && echo "I have no friends!" && return
    [[ $# -eq 1 ]] && echo "$1 is my only friend!" && return
    i=1
    (( before_last=$# - 1 ))
    string=""
    for arg in "$@"; do
        if [[ $i -eq $# ]]; then
            string="${string} and ${arg} are my friends"
        elif [[ $i -eq $before_last ]]; then
            string="${string}${arg}"
        else
            string="${string}${arg}, "
        fi
        (( i=$i + 1))
    done
    echo $string
}

myFunction
myFunction Eddie
myFunction Eddie Bruce
myFunction Eddie Bruce Paul

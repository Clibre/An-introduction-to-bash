#!/bin/bash

# if control structure

light=yellow

if [[ $light == red ]]; then
    echo "stop!"
elif [[ $light == green ]]; then
    echo "go!"
else
    echo "caution, the light is turning red!"
fi

# while control structure

myVar=0

while [[ $myVar -lt 5 ]]; do
    echo $myVar
    (( myVar=$myVar + 1 ))
done

myVar=0

while [[ $myVar -lt 5 ]]; do
    echo $myVar
    if [[ $myVar -eq 3 ]]; then
        echo "breaking the loop!"
    fi
    (( myVar=$myVar + 1))
done

# for control structure

for arg in value1 value2 value3; do
    echo $arg
done

for value in $(ls -1); do
    echo $value
done

myArray=(i am beautiful)
for element in ${myArray[*]}; do
    echo $element
done

myArray=(value1 value2 beeep value3 value4)
for arg in ${myArray[*]}; do
    if [[ $arg =~ be+p ]]; then
        continue
    fi
    echo $arg
done

# case control structure

myVar=goat

case $myVar in
    dog)
        echo "woof woof"
        ;;
    cat)
        echo "moew moew"
        ;;
    *)
        echo "insert alien noises [here]!"
        ;;
esac

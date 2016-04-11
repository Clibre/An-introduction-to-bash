#!/bin/bash

# String variables

VARNAME=VARVALUE
mySecondVar="A very long variable"
my_third_var=third
var4=fourth

echo $VARNAME
echo $mySecondVar
echo $my_third_var
echo $var4

# Numeric variables
myVar=5
((myVar=$myVar+5))
echo $myVar

myVar=-4
((myVar=$myVar+2))
echo $myVar

notNumeric="hello"
notNumeric2="World"
numeric=5
((numeric = $notNumeric + $numeric))
echo $numeric
((notNumeric = $notNumeric + $notNumeric2))
echo $notNumeric

# Arrays
myArray=(item1 item2 item3)
echo ${myArray[0]}
echo ${myArray[2]}
echo ${myArray[3]}

declare -a myArray2=(value1 value2 value3)
echo ${myArray2[*]}

declare -a myArray3 # an empty array

echo ${#myArray[*]}
echo ${#myArray3[*]}

myVar="not an array"
myVar[1]="now it's an array"
echo ${#myVar[*]}

myVar2=5
myVar2[1]=10

((myVar2[2] =  ${myVar2[0]} + ${myVar2[1]}))
echo ${myVar2[2]}
echo ${#myVar2[*]}

myArrayLenght=${#myVar2[*]}
echo $myArrayLenght

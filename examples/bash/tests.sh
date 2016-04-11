#!/bin/bash

# bash tests
answer=yes

[[ $answer == yes ]] && echo "answer is yes"
[[ $answer == no ]] && echo "answer is no"
[[ $answer == no ]] || echo "answer is still yes"
[[ $answer == yes ]] || echo "answer is no, once again"

echo ""

# tests on strings
string="Hola muchacho!"

[[ $string ]] && echo "string is not empty"
[[ -z $string ]] || echo "string is still not empty"
[[ $string == "Hola muchacho!" ]] && echo "string is equals to 'Holla muchacho!'"
[[ $string != "Hola senior!" ]] && echo "string is not equals to 'Hola senior!'"
[[ $string =~ mucha ]] && echo "string matches 'mucha'"

echo ""

# tests on file

file="tests.sh"

[[ -e $file ]] && echo "$file exists"
[[ -d $file ]] || echo "$file is not a directory"
[[ -f $file ]] && echo "$file is a regular file"
[[ -x $file ]] && echo "$file is executable"

echo ""

# tests on number

myNum=23

[[ $myNum -eq 23 ]] && echo "$myNum is equal to 23"
[[ $myNum -le 23 ]] && echo "$myNum is less or equal to 23"
[[ $myNum -ge 23 ]] && echo "$myNum is greater or equal to 23"
[[ $myNum -lt 44 ]] && echo "$myNum is less than 44"
[[ $myNum -gt 12 ]] && echo "$myNum is greater than 12"
[[ $myNum -ne 6 ]] && echo "$myNum is not equal to 6"

[[ 0 -eq "lala" ]] && echo "0 is equal to 'lala'"

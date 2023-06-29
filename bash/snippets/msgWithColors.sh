#!/bin/bash

# Colors
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

#############
# Functions #
#############

draw_line()
{
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}
msgInfo(){
    MSG=${1}
    echo "[II] ${MSG}"
}
msgOK(){
    MSG="$1"
    echo "${green}[OK] ${MSG}${reset}"
}
msgWarning(){
    MSG="$1"
    echo "${yellow}[!!] ${MSG}${reset}"
}
msgError(){
    MSG="$1"
    echo "${red}[EE] ${MSG}${reset}"
}

draw_line
msgInfo "Test"
msgOK "Success"
msgWarning "Oops"
msgError "Critical"
draw_line
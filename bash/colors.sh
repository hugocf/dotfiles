#!/usr/bin/env bash

# Raw escape sequence:  \[\e[1;32m\]
# 
# Examples of using this color aliases:
#   a) '\[\e[${bold}${green}m\] $(command)'
#   b) "\[${color}${bold}${green}m\] \$(command)"
# 
color='\e['

# Formatting effects
reset=';0'
bold=';1'
underline=';4'
inverted=';7'

# Foreground colors
black=';30'
red=';31'
green=';32'
yellow=';33'
blue=';34'
magenta=';35'
cyan=';36'
white=';37'

# Background colors
bblack=';40'
bred=';41'
bgreen=';42'
byellow=';43'
bblue=';44'
bmagenta=';45'
bcyan=';46'
bwhite=';47'

# Sugar syntax for PS1 usage; must be using using syntax b), above
RESET="\[${color}${reset}m\]"
BLACK="\[${color}${black}m\]"
RED="\[${color}${red}m\]"
GREEN="\[${color}${green}m\]"
YELLOW="\[${color}${yellow}m\]"
BLUE="\[${color}${blue}m\]"
MAGENTA="\[${color}${magenta}m\]"
CYAN="\[${color}${cyan}m\]"
WHITE="\[${color}${white}m\]"
BOLD_BLACK="\[${color}${black}${bold}m\]"
BOLD_RED="\[${color}${red}${bold}m\]"
BOLD_GREEN="\[${color}${green}${bold}m\]"
BOLD_YELLOW="\[${color}${yellow}${bold}m\]"
BOLD_BLUE="\[${color}${blue}${bold}m\]"
BOLD_MAGENTA="\[${color}${magenta}${bold}m\]"
BOLD_CYAN="\[${color}${cyan}${bold}m\]"
BOLD_WHITE="\[${color}${white}${bold}m\]"
UNDER_BLACK="\[${color}${black}${underline}m\]"
UNDER_RED="\[${color}${red}${underline}m\]"
UNDER_GREEN="\[${color}${green}${underline}m\]"
UNDER_YELLOW="\[${color}${yellow}${underline}m\]"
UNDER_BLUE="\[${color}${blue}${underline}m\]"
UNDER_MAGENTA="\[${color}${magenta}${underline}m\]"
UNDER_CYAN="\[${color}${cyan}${underline}m\]"
UNDER_WHITE="\[${color}${white}${underline}m\]"

#!/usr/bin/env bash
# Created by Hugo Ferreira <hugo@mindclick.info> on 2010-11-02.
# Copyright (c) 2010 Mindclick. All Rights Reserved.
# Licensed under the BSD License: http://creativecommons.org/licenses/BSD

readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
readonly CALLDIR=$(pwd)                         # where it was called from

# Warn if the target file already exists
safelink () {
    src=$1; tgt=$2
    if [[ ! -a $tgt || -h $tgt ]]
    then
        ln -nfs $src $tgt
        ls -l $tgt
    else
        echo "ERROR: Found a `file -bi $tgt` named '$tgt' and stopped before overriding it."
        echo "       Remove the `file -bi $tgt` or move it aside and try again."
        exit 1
    fi
}

# Move aside and timestamp a target file for backup if it already exists
safecopy () {
    src=$1; tgt=$2
    if [[ -a $tgt ]]
    then
        TIMESTAMP=`date +%Y%m%dT%H%M%S-$$`
        mv $tgt $tgt.$TIMESTAMP
        ls -l $tgt.$TIMESTAMP
    fi
    cp $src $tgt
    ls -l $tgt
    echo
    diff -u $tgt.$TIMESTAMP $tgt
}

# Central access reference
safelink $BASEDIR ~/.dotfiles

# Git specific
safelink ~/.dotfiles/gitconfig ~/.gitconfig

# Install local dotfiles with sensitive information
if [[ -d $BASEDIR/../dotfiles_local ]]
then
	cd $BASEDIR/../dotfiles_local/
	
	
	./gitconfig.sh
	
fi

unset safelink
unset safecopy

echo
echo =====
echo
echo "The above files were 'installed' successfully."
echo
echo "# STEP 1 #"
echo
echo "Don't forget to configure your own NAME and EMAIL for git to use,"
echo "by customising and issuing the following commands:"
echo
echo '      git config --global user.name "Your Name"'
echo '      git config --global user.email you@mindclick.info'
echo
echo "# STEP 2 #"
echo
echo "Get your GitHub API token[1] and configure access for non-SSH tools:"
echo '  [1] https://github.com/account#admin_bucket'
echo
echo '      git config --global github.user username'
echo '      git config --global github.token 0123456789abcdef0123456789abcdef'
echo
echo "# STEP 3 #"
echo
echo "Follow the tutorial[1] to generate SSH keys[2] for GitHub access:"
echo '  [1] http://help.github.com/mac-key-setup/'
echo '  [2] https://github.com/account#ssh_bucket'


# ———————————————————————
# HF: R&D sudo detections
# ———————————————————————

# SOLUTION?
# 
# macbookpro: ~
# admin$ dscl . read /groups/admin GroupMembership | grep $USER &> /dev/null ; echo $?
# 0
# 
# macbookpro: ~
# admin$ dscl . read /groups/admin GroupMembership | grep admin &> /dev/null ; echo $?
# 0
# 
# macbookpro: ~
# admin$ dscl . read /groups/admin GroupMembership | grep hugo &> /dev/null ; echo $?
# 1


# 
# dscl . append /Groups/admin GroupMembership hugo
# 
# sudo chgrp admin /etc/hosts
# 
# [[ -w /etc/hosts ]] && echo yep, i can write on the file
# 
# 
# http://stackoverflow.com/questions/1133364/fastest-way-to-determine-user-permissions-in-etc-sudoer
# 
# macbook: hugo$ sudo -v ; echo $?
# Sorry, user hugo may not run sudo on macbook.
# 1
# 
# macbook: admin$ sudo -v ; echo $?
# 0


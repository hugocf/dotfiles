#!/usr/bin/env bash
set -u  # treat unset variables as errors

readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
readonly CALLDIR=$(pwd)                         # where it was called from

relpath() {
    local path=$1
    cd "$(dirname "$0")/$path" && pwd
}

link_files() {
    echo -e "\n=== Link config dotfiles ==="
    local path=$(relpath ../../dotfiles.git)
    ln -nfs $path ~/.dotfiles
    ln -nfs ~/.dotfiles/bash/bash_aliases   ~/.bash_aliases
    ln -nfs ~/.dotfiles/bash/bash_profile   ~/.bash_profile
    ln -nfs ~/.dotfiles/bash/colors.sh      ~/.colors.sh
    ln -nfs ~/.dotfiles/git/gitconfig       ~/.gitconfig
    ln -nfs ~/.dotfiles/mate/tm_properties  ~/.tm_properties
}

link_local() {
    echo -e "\n=== Link local dotfiles ==="
    local path=$(relpath ../../dotfiles_local.git)
    ln -nfs $path ~/.dotfiles_local
    ln -nfs ~/.dotfiles_local/aws           ~/.aws
    ln -nfs ~/.dotfiles_local/bash_history  ~/.bash_history
    ln -nfs ~/.dotfiles_local/github/token  ~/.github
    ln -nfs ~/.dotfiles_local/ssh           ~/.ssh
}

link_system() {
    echo -e "\n=== Link system dotfiles ==="
    local path=$(relpath ../../dotfiles_local.git)
    sudo ln -nfs $path/etc/hosts /etc/hosts
}

# Do the work
link_files
link_local
link_system

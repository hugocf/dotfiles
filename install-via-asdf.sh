#!/usr/bin/env bash
# Created by Hugo Ferreira <hugo@ferreira.cc> on 2018-03-02
# Licensed under the MIT License: https://opensource.org/licenses/MIT

set -u  # treat unset variables as errors

heading () {
    local -r msg="$*"
    echo
    echo "=== $msg ==="
}

update_asdf () {
    heading "asdf"
    [[ ! -d ~/.asdf ]] && git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.4.2
    asdf update

    heading "plugins"
    asdf plugin-update --all
}

install () {
    local -r name=$1
    local -r global=$2
    local -r others=${@:3:$#}   # from 3rd until the last one

    heading "$name"
    asdf plugin-add $name
    for v in $global $others; do
        asdf install $name $v
    done
    asdf global $name $global
}

set_local () {
    local -r name=$1
    local -r version=$2
    local -r folder=$3
    cd "$folder"
    asdf local $name $version
    echo "(set $version => $folder)"
}

# Do the work
update_asdf

# Install packages
install java        8.161   9.0.4
install kops        1.7.1
install kubectl     1.9.3
install minikube    0.24.1
install nodejs      9.7.1
install python      2.7.14
install terraform   0.10.4  0.8.8

# Set local versions
set_local terraform 0.8.8   "$UX_CODE"/uxforms-infra-live/provisioning/
set_local terraform 0.10.4  "$UX_CODE"/uxforms-infra-live/kubernetes/provision/

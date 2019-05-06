#!/usr/bin/env bash
set -u  # treat unset variables as errors

# https://asdf-vm.com/#/core-manage-asdf-vm
if [[ ! -d ~/.asdf ]]; then
    echo -e "\n=== Install asdf ==="
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf
    cd ~/.asdf
    git checkout "$(git describe --abbrev=0 --tags)"
fi

install () {
    local -r name=$1
    local -r global_version=$2
    local -r other_versions=${@:3:$#}   # from 3rd until the last one

    echo -e "\n=== $* ==="
    asdf plugin-add $name
    for version in $global_version $other_versions; do
        asdf install $name $version
    done
    asdf global $name $global_version
}

install_plugins () {
    # install java        oracle-8.191
    install kops        1.11.1.z
    install kubectl     1.14.1
    install minikube    1.0.1
    install nodejs      12.1.0
    # install python      3.7.3       2.7.16
    install terraform   0.11.13
}

setup_config () {
    kubectl completion bash > $(brew --prefix)/etc/bash_completion.d/kubectl
    minikube completion bash > $(brew --prefix)/etc/bash_completion.d/minikube
}

deprecate () {
    :
}

# Do the work
echo -e "\n=== Install asdf apps ==="
install_plugins
setup_config
deprecate

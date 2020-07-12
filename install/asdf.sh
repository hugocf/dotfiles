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
    install ruby        2.6.3
    install sbt         1.3.9       1.2.8
    install terraform   0.12.28
}

setup_config () {
    :
}

deprecate () {
    asdf plugin-remove golang
    asdf plugin-remove kops
    asdf plugin-remove kubectl
    asdf plugin-remove minikube
    asdf plugin-remove nodejs
}

# Do the work
echo -e "\n=== Install asdf apps ==="
install_plugins
setup_config
deprecate

#!/usr/bin/env bash

# https://asdf-vm.com/#/core-manage-asdf-vm?id=remove
echo -e "\n=== Uninstalling asdf ==="
read -p "Are you sure? [y/N] " answer
if [[ "$answer" == "y" ]]; then
    rm -v -rf ~/.asdf ~/.tool-versions
else
    echo "Skipping..."
fi

# https://docs.brew.sh/FAQ#how-do-i-uninstall-homebrew
echo -e "\n=== Uninstalling brew ==="
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"

#!/usr/bin/env bash
set -euo pipefail

# When .Spotlight-V100 becomes huge with 100s of GB
# [macos - Can I delete the .Spotlight-V100 file - Ask Different](https://apple.stackexchange.com/q/437245)

main() {
    show_index_size
    echo
    read -r -n1 -p "Do you want ot reset and clear the Spotlight index? [y/N] " answer < /dev/tty
    echo
    if [[ "$answer" == "y" ]]; then
        clear_index_data
        echo
        show_index_size
    else
        echo "Skipping... no changes made"
    fi
}

show_index_size() {
    echo "Current size of the Spotlight index:"
    sudo du -h -d0 /System/Volumes/Data/.Spotlight-V100
}

clear_index_data() {
    stop_indexing
    start_indexing
}

stop_indexing() {
    echo "Stopping..."
    sudo mdutil -a -i off
}

start_indexing() {
    echo "Starting..."
    sudo mdutil -a -i on
}

main "$@"

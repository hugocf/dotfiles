#!/usr/bin/env bash

# Makes sure the local development environment up-to-date
# and properly configured.

# packges to install
PYTHON="mercurial pep8 virtualenv virtualenvwrapper"
RUBY="compass"
BREW="autojump bash bash-completion exiftool gist git-flow lorem mr nginx node
rmtrash testdisk tree vcprompt wget xdebug"

# python packages
PATH=/usr/local/bin:/usr/local/share/python:$PATH
brew install python
easy_install pip
for package in $PYTHON; do
    pip install $package
done

# brew packages
brew install git
for package in $BREW; do
    brew install $package
done
for package in $BREW; do
    echo
    echo ==================================================
    echo
    brew info $package
done

# generic environment tweaks
su admin -c "
    # mysql
    sudo ln -nfs /tmp/mysql.sock /var/mysql/mysql.sock
    sudo cat .mysql/my.cnf-debug >> /etc/my.cnf
    sudo mkdir /var/log/mysql && sudo chmod a+w /var/log/mysql && sudo chmod a+r /var/log/mysql/*
    # php
    sudo cp .php/php.ini-development /etc/php.ini
"


##########
##########

# TODO: include Ruby configuration to the latest versions

# Consider using RVM or Cinderella to manage Ruby environments:
#   * RVM: http://rvm.beginrescueend.com/
#   * Cinderella: http://www.atmos.org/cinderella

# https://github.com/mxcl/homebrew/wiki/Gems%2C-Eggs-and-Perl-Modules
# brew install ruby
# gem install sqlite3


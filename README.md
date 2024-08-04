# dotfiles 

Local configuration files, preferences, and installation scripts to easily setup and replicate perferred options accross different machines.

This uses [Yet Another Dotfiles Manager - yadm](https://yadm.io/) to manage the headless git repo setup more easily.

## Inception

On a new machine, run the following in a temporary directory (e.g. `~/Desktop`):

```shell
git clone https://github.com/hugocf/dotfiles.git
dotfiles/.config/yadm/bootstrap
rm -rf dotfiles
```

## Updates

On an ongoing basis, run the following to receive updates and ensure all is setup correctly:

```shell
yadm pull
yadm bootstrap
```

*(see more [Common Commands - yadm](https://yadm.io/docs/common_commands))*

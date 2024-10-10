# `zsh` startup files

`zsh` start files are queried according to the following list, first the general environment version (`/env/<file>`) and then the user specific version (`${ZDOTDIR:-HOME}/.<file>`), for each type:

| # | `<file>`   | Runs for …           |
| - | ---------- | -------------------- |
| 1 | `zshenv`   | All shells (usually) |
| 2 | `zprofile` | Login shells         |
| 3 | `zshrc`    | Interactive shells   |
| 4 | `zlogin`   | Login shells         |
| *(on exit)*                           |
| 5 | `zlogout`  | Login shells         |

See details in [ZSH - THE Z SHELL](https://zsh.sourceforge.io/) documentation:

* [2.2: All the startup files](https://zsh.sourceforge.io/Guide/zshguide02.html#l9).
* [An Introduction to the Z Shell - Startup Files](https://zsh.sourceforge.io/Intro/intro_3.html)
* [zsh: 5 Files](https://zsh.sourceforge.io/Doc/Release/Files.html)

## Symlinks instead `$ZDOTDIR`

In `zsh`, the `ZDOTDIR` variable allows to set [the directory to search for shell startup files, if not `$HOME`](https://zsh.sourceforge.io/Doc/Release/Parameters.html#index-ZDOTDIR).

Unfortunately there are a few drawbacks to using `ZDOTDIR` to have the startup files under `.config/zsh/`:

1. ❌ State files like `.zsh_history` would also be moved, which is not my intention
2. ❌ Would still need a `$HOME/.zshenv` to set the variable, so it’s influence only the followig startup files
3. ❌ The `$HOME` location is so common that 3rd party tools and scripts might not even consider the `$ZDOTDIR` variable at all

Using symlinks circumvents all those drawbacks:

* ✅ Lets centralise all config in under `.config/zsh/` in an universally compatible way

Also, having *empty placeholders* for all the startup files that I'm not using allows for easy detection when any rogue tool adds something to them.
# tmux-git

[![Gitter](https://img.shields.io/gitter/room/nwjs/nw.js.svg)](https://gitter.im/drmad/tmux-git)

`tmux-git` shows information about the [git](https://git-scm.com/) repo (current branch, *dirtiness*,
stash status, etc.) under the working directory using the [tmux][3] status bar.

## Overview

There are many solutions to integrate the current Git branch on your Linux terminal
prompt (like [this one][1] and [this one][2], from where I borrowed most parts of
this script), but I don't like to bloat my prompt.

So I was thinking where can I put that information, and then I remembered the
fabulous [tmux][3]. `tmux` is a powerful and really cool client-server terminal
multiplexer, but it also provides a nice status bar.

This script scans the current working directory and upwards for a `git` repo.
If it founds one, puts information about it in the status bar, like:

* Project name (actually, is the `git` repo directory name)
* Active branch
* 'Dirty' status (i.e., there are pending modifications to be committed)
* Stashed changes

## Installation

Clone this project in your home directory with a dot-prefixed name, so it stays
hidden:

    git clone https://github.com/drmad/tmux-git.git ~/.tmux-git

Then, execute this line in a shell to add the script in the Bash initialization
file (usually `.bashrc`, replace if needed):

    echo "if [[ \$TMUX ]]; then source ~/.tmux-git/tmux-git.sh; fi" >> ~/.bashrc

Now run `tmux`, `cd` to a Git repo, and enjoy :)

**Note for OSX users**: You'll need to install `coreutils`:

    brew install coreutils

## Configuration

The configuration is stored in the file `~/.tmux-git.conf`, created at the first
run of the script with default values. Just edit it, and reload `tmux`.

### Variables and functions

* `TMUX_STATUS_LOCATION`: Position of the status on tmux bar: `left` or `right`
* `TMUX_OUTREPO_STATUS`: Tmux status for when you're out of a repo. Set by
  default to your pre-existing status line.
* `TMUX_STATUS_DEFINITION()`: This function sets the `TMUX_STATUS` variable, which
  is shown in the tmux bar. You can use any variable used across the script for
  creating this variable.

## En español

He realizado un post en español de las instrucciones de instalación en mi blog:

https://drmad.org/blog/branch-de-git-en-tmux.html

[1]: https://github.com/jimeh/git-aware-prompt
[2]: http://aaroncrane.co.uk/2009/03/git_branch_prompt/
[3]: https://github.com/tmux/tmux

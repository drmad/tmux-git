Git branch in Tmux
==================
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/drmad/tmux-git?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

`tmux-git` shows information about the `git` repo of the current directory in 
`tmux` status bar, like current branch, *dirtiness*, stash, etc.

## Overview

There are many solutions to integrate the current Git branch on your Linux terminal
prompt (like [this one][1] and [this one][2], from where I borrowed most parts of
this script), but I don't like to bloat my prompt. 

So I was thinking where can I put that information, and then I remembered the
fabulous [Tmux][3]. `tmux` is a powerful and really cool client-server terminal 
multiplexer, but it also provides a nice status bar. 

This script scans the current `bash` directory for a `git` repo. If it's found, 
then puts information about it in the status bar, like:

* Project name (actually, is the `git` repo directory name)
* Active branch 
* 'Dirty' status (i.e., there are pending modifications to be committed) 
* Stashed changes

## Installation

Clone this project in your home directory, renaming the folder with a preceding
dot for hiding it:

    git clone git://github.com/drmad/tmux-git.git ~/.tmux-git
  
Then, execute this line in a shell to add the script in the Bash initialization 
file (usually `.bashrc`, replace if needed):

    echo "if [[ \$TMUX ]]; then source ~/.tmux-git/tmux-git.sh; fi" >> ~/.bashrc

Run `tmux`, `cd` to a Git repo, and enjoy :)

**Note for OSX users**: You'll need to install `coreutils`:

    brew install coreutils

## Configurarion

The configuration is stored in the file `~/.tmux-git.conf`, created at the first
run of the script with default values. Just edit it, and reload `tmux`.

### Variables and functions

* `TMUX_STATUS_LOCATION`: Position of the status on Tmux bar: `left` or `right`
* `TMUX_OUTREPO_STATUS`: Tmux status for when you're out of a repo. Set by 
  default to your pre-existing status line. 
* `TMUX_STATUS_DEFINITION()`: This function sets the `TMUX_STATUS` variable, which
  is shown in the `tmux` bar. You can use any variable used across the script for
  creating this variable.
  
## En español

He realizado un post en español de las instrucciones de instalación en mi blog:

http://drmad.org/blog/branch-de-git-en-tmux.html

[1]: https://github.com/jimeh/git-aware-prompt
[2]: http://aaroncrane.co.uk/2009/03/git_branch_prompt/
[3]: http://tmux.sourceforge.net/

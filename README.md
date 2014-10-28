Git branch in Tmux
==================

There are many solutions to integrate the current Git branch on your Linux terminal
prompt (like [this one][1] and [this one][2], from where I borrowed most parts of
this script), but I don't like to bloat my prompt. 

So I was thinking where can I put that information, and then I remembered the
fabulous [Tmux][3].

`Tmux` is a powerful and really cool client-server terminal multiplexer, but it
also provides a nice status bar. This script puts the Git branch of the current
directory (if it is inside a Git repo) on the right side of the Tmux status bar.

Also, the branch name turns bright when the repo is 'dirty' (i.e., there are 
pending modifications to be committed)

**Update:** Now the status shows if there are stashed changes inside the repo.

## Installation

Clone this project in your home directory, renaming the folder with a starting
dot for hiding it:

    git clone git://github.com/drmad/tmux-git.git ~/.tmux-git
  
Then, execute this line to add the script in the Bash initialization file:

    echo ". ~/.tmux-git/tmux-git.sh" >> ~/.bashrc
  
Run `tmux`, `cd` to a Git repo, and enjoy :)

## Hacking

**Update:** The script is pretty simple. At the top, there are a few variables 
(and a function) for configuring the script behavior:

* `TMUX_STATUS_LOCATION`: Position of the status on Tmux bar: `left` or `right`
* `TMUX_OUTREPO_STATUS`: Tmux status for when you're out of a repo. 
* `TMUX_STATUS_DEFINITION()`: This function sets the `TMUX_STATUS` variable, which
  is shown in the Tmux bar.

## En español

He realizado un post en español de las instrucciones de instalación en mi blog:

http://drmad.org/blog/branch-de-git-en-tmux.html

[1]: https://github.com/jimeh/git-aware-prompt
[2]: http://aaroncrane.co.uk/2009/03/git_branch_prompt/
[3]: http://tmux.sourceforge.net/

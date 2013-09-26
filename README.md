Git branch in Tmux
==================

There are many solutions to integrate the actual Git branch on your Linux terminal
prompt (like [this one][1]), but I don't like to bloat my prompt. So I was thinking
where can I put that information. And then I remembered the fabulous [Tmux][2].

`Tmux` is a powerful and really cool client-server terminal multiplexer, but also 
provides a nice status bar. This script puts the current directory Git branch (if
the current directory is inside a Git repo) on the right side of the status bar.

Also, the branch name turns bright when the repo is 'dirty' (i.e., there are pending
modifications to be committed)

## Installation

Clone this project in your home directory. Rename the folder with a starting dot for
hide it:

    git clone git://github.com/drmad/tmux-git.git .tmux-git
  
Then, execute this line to add the script in the Bash initialization file:

    echo ". ~/.tmux-git/tmux-git.bash" >> ~/.bashrc
  
Run `tmux`, `cd` to a git repo, and enjoy :)

## Hacking

The script is prety simple. Basic hacking includes modifying the `LOCATION` (`left`
or `right`) and `STATUS` (the actual text to be written) variables inside the 
`update_tmux` function for changing the script beavior.

[1]: https://github.com/jimeh/git-aware-prompt
[2]: http://tmux.sourceforge.net/

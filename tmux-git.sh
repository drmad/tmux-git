# tmux-git
# Script for showing current Git branch in Tmux status bar
#
# Created by Oliver Etchebarne - http://drmad.org/ with contributions
# from many github users. Thank you all.

CONFIG_FILE=~/.tmux-git.conf

# Use a different readlink according the OS.
# Kudos to https://github.com/npauzenga for the PR
if [[ `uname` == 'Darwin' ]]; then
    # Mac
    READLINK='greadlink -e'
else
    # Linux
    READLINK='readlink -e'
fi

# Check for a configuration file.
# Idea from https://github.com/michael-coleman
if [ ! -f $CONFIG_FILE ]; then
    # Doesn't exists. Build a new one.
    echo tmux-git: Default config file $CONFIG_FILE created.
    cat <<'EOF' >$CONFIG_FILE
# tmux-git configuration file

# Location of the status on tmux bar: left or right
TMUX_STATUS_LOCATION='right'

# Status for where you are out of a repo. Default is your pre-existing status 
# line. 
# Kudos to https://github.com/danarnold for the idea.
TMUX_OUTREPO_STATUS=`tmux show -vg status-$TMUX_STATUS_LOCATION`

# Function to build the status line. You need to define the $TMUX_STATUS 
# variable.
TMUX_STATUS_DEFINITION() {
    # You can use any tmux status variables, and $GIT_BRANCH, $GIT_DIRTY, 
    # $GIT_FLAGS ( which is an array of flags ), and pretty much any variable
    # used in this script :-)
    
    GIT_BRANCH="`basename "$GIT_REPO"` | branch: $GIT_BRANCH"
    
    TMUX_STATUS="$GIT_BRANCH$GIT_DIRTY"
    
    if [ ${#GIT_FLAGS[@]} -gt 0 ]; then
        TMUX_STATUS="$TMUX_STATUS [`IFS=,; echo "${GIT_FLAGS[*]}"`]"
    fi

}
EOF
fi

# Load the config file.
. $CONFIG_FILE

# Taken from http://aaroncrane.co.uk/2009/03/git_branch_prompt/
find_git_repo() {
    local dir=.
    until [ "$dir" -ef / ]; do
        if [ -f "$dir/.git/HEAD" ]; then
            GIT_REPO=`$READLINK $dir`/
            return
        fi
        dir="../$dir"
    done
    GIT_REPO=''
    return
}

find_git_branch() {
    head=$(< "$1/.git/HEAD")
    if [[ $head == ref:\ refs/heads/* ]]; then
        GIT_BRANCH=${head#*/*/}
    elif [[ $head != '' ]]; then
        GIT_BRANCH='(detached)'
    else
        GIT_BRANCH='(unknown)'
    fi
}

# Taken from https://github.com/jimeh/git-aware-prompt
find_git_dirty() {
  local status=$(git status --porcelain 2> /dev/null)
  if [[ "$status" != "" ]]; then
    GIT_DIRTY='*'
  else
    GIT_DIRTY=''
  fi
}

find_git_stash() {
    if [ -e "$1/.git/refs/stash" ]; then    
        GIT_STASH='stash'
    else
        GIT_STASH=''
    fi
}

update_tmux() {

    # The trailing slash is for avoiding conflicts with repos with 
    # similar names. Kudos to https://github.com/tillt for the bug report
    CWD=`$READLINK "$(pwd)"`/

    LASTREPO_LEN=${#TMUX_GIT_LASTREPO}

    if [[ $TMUX_GIT_LASTREPO ]] && [ "$TMUX_GIT_LASTREPO" = "${CWD:0:$LASTREPO_LEN}" ]; then
        GIT_REPO="$TMUX_GIT_LASTREPO"

        # Get the info
        find_git_branch "$GIT_REPO"
        find_git_stash "$GIT_REPO"
        find_git_dirty

        GIT_FLAGS=($GIT_STASH)
        
        TMUX_STATUS_DEFINITION
        
        if [ "$GIT_DIRTY" ]; then 
            tmux set-window-option status-$TMUX_STATUS_LOCATION-attr bright > /dev/null
        else
            tmux set-window-option status-$TMUX_STATUS_LOCATION-attr none > /dev/null
        fi
        
        tmux set-window-option status-$TMUX_STATUS_LOCATION "$TMUX_STATUS" > /dev/null            

    else
        find_git_repo
        
        if [[ $GIT_REPO ]]; then
            export TMUX_GIT_LASTREPO="$GIT_REPO"
            update_tmux
        else
            # Be sure to unset GIT_DIRTY's bright when leaving a repository.
            # Kudos to https://github.com/danarnold for the idea
            tmux set-window-option status-$TMUX_STATUS_LOCATION-attr none > /dev/null

            # Set the out-repo status
            tmux set-window-option status-$TMUX_STATUS_LOCATION "$TMUX_OUTREPO_STATUS" > /dev/null
        fi
    fi

}

# Update the prompt for execute the script
PROMPT_COMMAND="update_tmux; $PROMPT_COMMAND"

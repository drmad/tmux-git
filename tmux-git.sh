# Taken from http://aaroncrane.co.uk/2009/03/git_branch_prompt/
find_git_branch() {
    local dir=. head
    until [ "$dir" -ef / ]; do
        if [ -f "$dir/.git/HEAD" ]; then
            head=$(< "$dir/.git/HEAD")
            if [[ $head == ref:\ refs/heads/* ]]; then
                git_branch=${head#*/*/}
            elif [[ $head != '' ]]; then
                git_branch='(detached)'
            else
                git_branch='(unknown)'
            fi
            return
        fi
        dir="../$dir"
    done
    git_branch=''
}

# Taken from https://github.com/jimeh/git-aware-prompt
find_git_dirty() {
  local status=$(git status --porcelain 2> /dev/null)
  if [[ "$status" != "" ]]; then
    git_dirty='*'
  else
    git_dirty=''
  fi
}

function update_tmux {
    # Check for tmux session
    if [ -n "$TMUX" ]; then 

        find_git_branch
        find_git_dirty
    
        # Let's add a nice text, if there is a branch
        if [ -n "$git_branch" ]; then
            git_branch="Git branch: $git_branch"
        fi

        
        #### This is the message location: left/right
        LOCATION=right

        #### This is the status message definition. 
        STATUS="$git_branch$git_dirty "

        # Are we inside a Git project?        
        if [ -n "$git_branch" ]; then

            if [ -n "$git_dirty" ]; then 
                tmux set-window-option status-$LOCATION-attr bright > /dev/null
            else
                tmux set-window-option status-$LOCATION-attr none > /dev/null
            fi
        fi


  
        tmux set-window-option status-$LOCATION "$STATUS" > /dev/null
    fi
}
PROMPT_COMMAND="update_tmux; $PROMPT_COMMAND"

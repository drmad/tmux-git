#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

find_git_dirty() {
   local status=$(git --git-dir="$1/.git" status --porcelain 2> /dev/null)
   if [[ "$status" != "" ]]; then
     GIT_DIRTY='*'
   else
     GIT_DIRTY=''
   fi
}

main() {
    find_git_repo "$1"
    find_git_dirty "$GIT_REPO"
    echo "$GIT_DIRTY"
}

main $1

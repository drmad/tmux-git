#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

find_git_stash() {
    if [ -e "$1/.git/refs/stash" ]; then
        GIT_STASH='stash'
    else
        GIT_STASH='no-stash'
    fi
}

main() {
    find_git_repo "$1"
    find_git_stash "$GIT_REPO"
    echo "$GIT_STASH"
}
main $1

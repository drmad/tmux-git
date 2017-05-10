#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

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

main() {
    find_git_repo "$1"
    find_git_branch "$GIT_REPO"
    echo "$GIT_BRANCH"
}
main $1

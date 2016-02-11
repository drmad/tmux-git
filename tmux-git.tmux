#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

git_branch="#($CURRENT_DIR/scripts/git_branch.sh #{pane_current_path})"
git_branch_interpolation="\#{git_branch}"
git_repo="#($CURRENT_DIR/scripts/git_repo.sh #{pane_current_path})"
git_repo_interpolation="\#{git_repo}"
git_dirty="#($CURRENT_DIR/scripts/git_dirty.sh #{pane_current_path})"
git_dirty_interpolation="\#{git_dirty}"
git_stash="#($CURRENT_DIR/scripts/git_stash.sh #{pane_current_path})"
git_stash_interpolation="\#{git_stash}"

get_tmux_option() {
    local option="$1"
    local default_value="$2"
    local option_value="$(tmux show-option -gqv "$option")"
    if [ -z "$option_value" ]; then
        echo "$default_value"
    else
        echo "$option_value"
    fi
}

set_tmux_option() {
    local option="$1"
    local value="$2"
    tmux set-option -gq "$option" "$value"
}

do_interpolation() {
    local string="$1"
    local git_branch_interpolated="${string/$git_branch_interpolation/$git_branch}"
    local git_repo_interpolated="${git_branch_interpolated/$git_repo_interpolation/$git_repo}"
    local git_dirty_interpolated="${git_repo_interpolated/$git_dirty_interpolation/$git_dirty}"
    local git_all_interpolated="${git_dirty_interpolated/$git_stash_interpolation/$git_stash}"
    echo "$git_all_interpolated"
}

update_tmux_option() {
    local option="$1"
    local option_value="$(get_tmux_option "$option")"
    local new_option_value="$(do_interpolation "$option_value")"
    set_tmux_option "$option" "$new_option_value "
}

main() {
    update_tmux_option "status-right"
    update_tmux_option "status-left"
}
main

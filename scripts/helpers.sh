# Linux
READLINK='readlink -e'
find_git_repo() {
    local dir="$1"
    until [ "$dir" -ef / ]; do
        echo "$dir"  > ~/debug
        if [ -f "$dir/.git/HEAD" ]; then
            GIT_REPO=`$READLINK $dir`/
            return
        fi
        dir="$dir/.."
    done
    GIT_REPO=''
    return
}

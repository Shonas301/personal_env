# function definitions
function pygrep() {
    grep -n $1 **/*.py
}

function default_arg() {
    if [ -n "$2" ]; then
        local arg="$2"
    else
        local arg="$1"
    fi
    echo "$arg"
}

function root() {
    cd `git rev-parse --show-toplevel`
}

function todo() {
    grep -n "TODO" **/*.*
}

function push() {
    branch=`git branch | grep \* | cut -d ' ' -f2`
    echo $branch
    message="$1"
    git commit -am $message
    if test -z $2; then
        git push origin $branch
    else
        remote=$2
        git push $remote $branch
    fi
    echo "Commited and pushed"
}

function itest() {
    root
    repo_name=$(basename `git rev-parse --show-toplevel`)
    docker build --rm -f integration-tests.Dockerfile -t "${repo_name}:latest" .
    back
}

function utest() {
    root
    repo_name=$(basename `git rev-parse --show-toplevel`)
    docker build --rm -f unit-tests.Dockerfile -t "${repo_name}:latest" .
    back
}

function get-functions() {
    print -l ${(ok)functions} | grep -v "_"
}

function master() {
    git checkout master
    git pull upstream master
    git push origin master
}

function ghead() {
    git rev-list master..HEAD | tail -1
}

function fixup() {
    if test -z $1; then
        commit=$(ghead)
    fi
    git commit -a --fixup $commit
}

function auto-rebase() {
    local source_branch=`default_arg "master" $1 `
    git rebase -i --autosquash $source_branch
}

function fvim() {
    vim `find . -name $1`
}

function dpylint() {
    py_files=`gitn diff master --name-only | grep .py | tr '\n' ' '`
    docker build -f pylint.dockerfile . --build-arg py_files=$py_files
}

function clean-docker() {
    docker rm $(docker ps -q -f "status=exited")
    docker rmi $(docker images -q -f "dangling=true")
    docker volume rm $(docker volume ls -qf dangling=true)
}


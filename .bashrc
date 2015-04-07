# isort function
function do_isort () {
        for file in `git diff --name-only`
        do
                if [[ $file =~ \.py$ ]]
                then
                        isort $file -a "from __future__ import absolute_import"$
                        echo 'isorted: ' $file
                fi
        done
}

# show git branch
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

. ~/.bash_aliases
. ~/.git-completion.bash
# git completion for alias "g"
__git_complete g __git_main

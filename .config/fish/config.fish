# show git branch
set fish_git_dirty_color red
set fish_git_not_dirty_color blue

function parse_git_branch
  set -l branch (git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')
  set -l git_diff (git diff)

  if test -n "$git_diff"
    echo (set_color $fish_git_dirty_color)"($branch)"(set_color normal)
  else
    echo (set_color ffe700)"($branch)"(set_color normal)
  end
end

function parse_virtualenv_name
  set env_name (basename "$VIRTUAL_ENV")

  if [ "$VIRTUAL_ENV" = "" ]
    set -e env_name
    echo ''
  else
    echo (set_color $fish_git_not_dirty_color)"($env_name)"(set_color normal)
  end

end

function new
  eval ~/dev/new/new $argv
end

function fish_prompt
  set -l git_dir (git rev-parse --git-dir 2> /dev/null)
  if test -n "$git_dir"

    if [ "$VIRTUAL_ENV" = "" ]
      printf '%s@%s %s%s%s %s> ' (whoami) (hostname|cut -d . -f 1) (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) (parse_git_branch)
    else
      printf '%s%s@%s %s%s%s %s> ' (parse_virtualenv_name) (whoami) (hostname|cut -d . -f 1) (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) (parse_git_branch)
    end

  else
    printf '%s@%s %s%s%s> ' (whoami) (hostname|cut -d . -f 1) (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
  end
end

set -x WORKON_HOME $HOME/.virtualenvs
set -x PROJECT_HOME $HOME/dev
set -x PYTHONDONTWRITEBYTECODE true
set -U fish_user_abbreviations 'g=git' 'v=vagrant'

source ~/.config/fish/completions/git.fish

#sudo pip install virtualfish
eval (python -m virtualfish compat_aliases 2> /dev/null)


# Docker commands

function dkill
  docker kill (docker ps -q)
end

function dlog
  docker logs -f (docker ps -q --filter name=$argv)
end

function drm
  docker kill (docker ps -q --filter name=$argv)
end

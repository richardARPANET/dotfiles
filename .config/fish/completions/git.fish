#!fish

for prefix in /usr /usr/local
  if test -f $prefix/share/fish/completions/git.fish
    . $prefix/share/fish/completions/git.fish
    break
  end
end

if not functions -q __fish_git_branches
  echo \nError: git completion not found >&2
  exit
end

## Support functions

function __fish_git_flow_using_command
  set cmd (commandline -opc)
  set subcommands 'flow' $argv
  if [ (count $cmd) = (math (count $subcommands) + 1) ]
    for i in (seq (count $subcommands))
      if not test $subcommands[$i] = $cmd[(math $i + 1)]
        return 1
      end
    end
    return 0
  end
  return 1
end

function __fish_git_flow_prefix
  git config "gitflow.prefix.$argv[1]" 2> /dev/null; or echo "$argv[1]/"
end

function __fish_git_flow_branches
  set prefix (__fish_git_flow_prefix $argv[1])
  __fish_git_branches | grep --color=never "^$prefix" | sed "s,^$prefix,," | sort
end

function __fish_git_flow_remote_branches
  set prefix (__fish_git_flow_prefix $argv[1])
  set origin (git config gitflow.origin 2> /dev/null; or echo "origin")
  git branch -r 2> /dev/null | sed "s/^ *//g" | grep --color=never "^$origin/$prefix" | sed "s,^$origin/$prefix,," | sort
end

function __fish_git_flow_untracked_branches
  set branches (__fish_git_flow_branches $argv[1])
  for branch in (__fish_git_flow_remote_branches $argv[1])
    if not contains $branch $branches
      echo $branch
    end
  end
end

function __fish_git_flow_unpublished_branches
  set branches (__fish_git_flow_remote_branches $argv[1])
  for branch in (__fish_git_flow_branches $argv[1])
    if not contains $branch $branches
      echo $branch
    end
  end
end




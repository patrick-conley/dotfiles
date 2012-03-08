# Check the status of the git repository
# Adapted from sjl's fork of oh-my-zsh
#
# Note: I have taken pains to minimize the number of calls to git needed by
# these function: they will run fine if called without arguments, but it may
# be faster to use a single call to
#
# $ git rev-parse --show-toplevel
# to check if we are in a git repo, get the repo name, and call
# git_prompt_prefix, and a single call to
#
# $ git status
# to call both git_prompt_branch and git_prompt_status

# Checks if there are commits ahead from remote
function git_prompt_ahead() {
  if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    echo "$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
}

# Function : git_prompt_prefix
# Arguments: (optional) absolute path to the repo root with
#            $ git rev-parse --show-toplevel
# Purpose  : Return a shortened version of $PWD, just going back to the repo's
#            root (non-inclusive)
function git_prompt_prefix
{
   if [[ $# -eq 1 ]]
   then
      echo ${$(pwd)#$1}
   else
      echo $(git rev-parse --show-prefix 2> /dev/null)
   fi
}

# Function : git_prompt_branch
# Arguments: (optional) results of
#            $ git status
# Purpose  : Get the name of the checked out branch
function git_prompt_branch
{
   if [[ $# -eq 1 ]]; then
      echo $1 | sed -n -e 's/# On branch //p'
   else
      refs=$(git symbolic-ref HEAD 2> /dev/null) || return
      echo ${refs#refs/heads/}
   fi
}
   
# Function : git_prompt_status
# Arguments: (optional) result of
#            $ git status
# Purpose  : Get the status of the working tree
function git_prompt_status
{

   if [[ $# -eq 1 ]]; then
      gitstat=$1
   else
      gitstat=$(git status 2> /dev/null | grep '# \(Untracked\|Changes\)' )
   fi

   stat_string=''

   if [[ -n $ZSH_THEME_REPO_DIRTY && $(echo ${gitstat} | grep -c "^# Changes to be committed:$" ) > 0 ]]; then
      stat_string=$stat_string$ZSH_THEME_REPO_DIRTY
   fi

   if [[ -n $ZSH_THEME_REPO_UNTRACKED && $(echo ${gitstat} | grep -c "^# \(Untracked files\|Changed but not updated\|Changes not staged for commit\):$" ) > 0 ]]; then
      stat_string=$stat_string$ZSH_THEME_REPO_UNTRACKED
   fi

   if [[ -n $ZSH_THEME_REPO_CLEAN && ( $(echo ${gitstat} | grep -v '^$' | wc -l | tr -d ' ') == 0 ) ]]; then
      stat_string=$stat_string$ZSH_THEME_REPO_CLEAN
   fi

   if [[ -n $stat_string ]]; then
      echo -n "$stat_string"
   else
      echo -n "$ZSH_THEME_REPO_CLEAN"
   fi
}

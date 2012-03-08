# Check the status of a subversion repo.
# Extensively adapted from robbyrussell's oh-my-zsh
#
# Note: I have taken pains to minimize the number of calls to svn needed by
# these function: they will run fine if called without arguments, but it may
# be faster to use a single call to
#
# $ svn info
# to check if we are in an svn repo, get the repository name, and call
# svn_prompt_prefix

# Function : svn_prompt_prefix
# Arguments: (optional) name of the svn repo (may save time)
# Purpose  : Return a shortened version of $PWD, just going back to the repo's
#            root (non-inclusive)
function svn_prompt_prefix
{

   [[ -e $ZSH_PROMPT_IGNORE && $( grep -c "^\(all\|prefix\)" $ZSH_PROMPT_IGNORE ) -gt 0 ]] && return

   [[ $# -eq 0 ]] && ( 1=$(svn info 2> /dev/null | sed -n -e 's/^Repository Root: .*\///p' ) || return )

   echo -n ${$(pwd)#*/$1*}
}

# Function : svn_prompt_status
# Arguments: N/A
# Purpose  : Check whether the repo has uncommitted changes
function svn_prompt_status
{
   [[ -e $ZSH_PROMPT_IGNORE && $( grep -c "^\(all\|status\)" $ZSH_PROMPT_IGNORE ) -gt 0 ]] && echo -n $ZSH_THEME_REPO_UNKNOWN && return

   svnstat=$(svn status 2>/dev/null) || return

   stat_string=''

   [[ -n $ZSH_THEME_REPO_DIRTY && $( echo $svnstat | grep -c '^\s*[ACDM!]' ) > 0 ]] && stat_string+=$ZSH_THEME_REPO_DIRTY

   [[ -n $ZSH_THEME_REPO_UNTRACKED && $( echo $svnstat | grep -c '^\s*?' ) > 0 ]] && stat_string+=$ZSH_THEME_REPO_UNTRACKED

   if [[ -n $stat_string ]]; then
      echo -n "$stat_string"
   else
      echo -n "$ZSH_THEME_REPO_CLEAN"
   fi

   unset svnstat

}

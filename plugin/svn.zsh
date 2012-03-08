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

   if [[ $# -eq 1 ]]
   then
      echo -n ${$(pwd)#*/$1*}
   else
      svn_root=$(svn info 2> /dev/null | sed -n -e 's/^Repository Root: *\///p' ) || return
      echo -n ${$(pwd)#*/$svn_root*}
   fi
}

# Function : svn_prompt_status
# Arguments: N/A
# Purpose  : Check whether the repo has uncommitted changes
function svn_prompt_status
{
   svnstat=$(svn status 2>/dev/null) || return

   stat_string=''

   if [[ $( echo $svnstat | grep -c '^\s*[ACDM!]' ) > 0 ]]; then
      stat_string=$stat_string$ZSH_THEME_REPO_DIRTY
   fi

   if [[ $( echo $svnstat | grep -c '^\s*?' ) > 0 ]]; then
      stat_string=$stat_string$ZSH_THEME_REPO_UNTRACKED
   fi

   if [[ -n $stat_string ]]; then
      echo -n "$stat_string"
   else
      echo -n "$ZSH_THEME_REPO_CLEAN"
   fi

}

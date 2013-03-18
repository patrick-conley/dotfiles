function __prompt_check_cwd --description "Check whether the CWD has changed"

   # If the CWD is not a repository, reuse the last prompt (__prompt_set_cwd
   # will set __prompt_vcs_type if the CWD changes to a repo)
   if not set -q __prompt_vcs_type
      return

   # If the CWD is a git repo, check its status and update the prompt if it's
   # changed
   else if test $__prompt_vcs_type = "git"
      __pconley_git_prompt

   # If the CWD is a mercurial repo, go as with git
   else if test $__prompt_vcs_type = "hg"
      set -l temp_status (hg status -q ^/dev/null)

      if test "$temp_status" != "$__prompt_vcs_last_stat"
         set -g __prompt_cwd (__pconley_hg_prompt $temp_status)
         set -g __prompt_vcs_last_stat "$temp_status"
      end

   end
end


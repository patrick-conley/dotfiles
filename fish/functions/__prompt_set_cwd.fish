# Every time the prompt is displayed, check if the CWD should be updated:
# - if we are known to be in a vcs repo (__prompt_vcs_type is true), get
#   the repo's status and compare it to __prompt_vcs_last_stat. If they
#   differ, call that vcs's redraw function, with the new status as an
#   argument
# - if the directory changes, call all the vcs functions until one matches,
#   and fall back to displaying pwd (--on-variable). Reset
#   __prompt_vcs_type and __prompt_vcs_last_stat
# - if a vcs command is called (eg., `git`), call the appropriate vcs's redraw
#   function. May be possible with --on-event), or I may wrap functions
#   around all the vcs commands that call __prompt_set_cwd

touch /home/pconley/temp/fish-reload

# reset everything 
function __prompt_set_cwd --on-variable PWD --description "Event handler: reset the cwd"

   # Check if this is a git repo
   set -l temp_status (git status --short --branch ^/dev/null)

   if test (count $temp_status) -gt 0
      set -g __prompt_vcs_type "git"
      set -g __prompt_cwd (__pconley_git_prompt $temp_status)
      set -g __prompt_vcs_last_stat "$temp_status"
      return
   end

   # Check if it is a mercurial repo
   if not test -z (hg root ^/dev/null)
      set -g __prompt_vcs_type "hg"
      set -g __prompt_cwd (__pconley_hg_prompt)
      return
   end

   set -g __prompt_vcs_type ""
   set -g __prompt_vcs_last_stat ""

   set -g __prompt_cwd "$__prompt_colour_pwd " (pwd | sed -e "s-^$HOME-~-" )
end

function __prompt_check_cwd

   # If the CWD is not a repository, reuse the last prompt (__prompt_set_cwd
   # will set __prompt_vcs_type if the CWD changes to a repo)
   if not set -q __prompt_vcs_type
      return

   # If the CWD is a git repo, check its status and update the prompt if it's
   # changed
   else if test $__prompt_vcs_type = "git"
      set -l temp_status (git status --short --branch ^/dev/null)

      if test "$temp_status" != "$__prompt_vcs_last_stat"
         set -g __prompt_cwd (__pconley_git_prompt $temp_status)
         set -g __prompt_vcs_last_stat "$temp_status"
      end

   # If the CWD is a mercurial repo, go as with git
   else if test $__prompt_vcs_type = "hg"
      set -l temp_status (hg status ^/dev/null)

      if test "$temp_status" != "$__prompt_vcs_last_stat"
         set -g __prompt_cwd (__pconley_hg_prompt $temp_status)
         set -g __prompt_vcs_last_stat "$temp_status"
      end

   end
end

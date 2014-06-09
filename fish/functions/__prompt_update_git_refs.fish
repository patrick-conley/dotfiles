function __prompt_update_git_refs --description 'Update the remote refs'

   set -l timefile (git rev-parse --git-dir)"/refs/last_remote_update"

   if not test -f $timefile
      touch --date="" $timefile
   end

   if not test (stat -c "%Y" $timefile ^/dev/null) -ge \
         (date --date="$__prompt_vcs_update_interval minutes ago" "+%s")
      touch $timefile
      git remote update ^&1 >/dev/null &
   end

   #if not set -q __prompt_saved_vcs_next_update
      #set __prompt_saved_vcs_next_update (date --date="$__prompt_vcs_update_interval minutes" "+%s")
   #end

   #if test (date "+%s") -lt $__prompt_saved_vcs_next_update
      ##git remote update ^&1 >/dev/null &
      #set __prompt_saved_vcs_next_update (date --date="$__prompt_vcs_update_interval minutes" "+%s")
   #end

end

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

end

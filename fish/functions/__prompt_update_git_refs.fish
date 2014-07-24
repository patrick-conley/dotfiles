function __prompt_update_git_refs --description 'Update the remote refs'

   set -l gitdir (git rev-parse --git-dir --show-toplevel)

   set -l timefile $gitdir[1]/refs/last_remote_update

   if test ! -f $timefile -o \
         (stat -c "%Y" $timefile ^/dev/null) -lt \
         (date --date="$__prompt_vcs_update_interval minutes ago" "+%s")
      touch $timefile
      git remote update ^&1 >/dev/null &
      ctags --tag-relative --recurse --exclude=$gitdir[1] -f $gitdir[1]/tags $gitdir[2] &
   end

   return 0

end

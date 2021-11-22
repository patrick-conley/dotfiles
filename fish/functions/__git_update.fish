function __git_update \
   --description "Update remotes and ctags if they haven't been updated lately"

   set -l vcs_paths
   if test (count $argv) -gt 0
      set vcs_paths $argv
   else
      set vcs_paths (git rev-parse --git-dir --show-toplevel --short HEAD)
   end

   touch --date="$__prompt_vcs_update_interval minutes ago" \
      $vcs_paths[1]/fish_prompt_time

   # Update the remote refs
   if command test \
         -f $vcs_paths[1]/FETCH_HEAD -a \
         $vcs_paths[1]/FETCH_HEAD -ot $vcs_paths[1]/fish_prompt_time
      git remote update 2>&1 >/dev/null &
   end

   # Update tags
   # FIXME this apparently never terminates... and I don't use ctags much
   #if command test $vcs_paths[1]/tags -ot $vcs_paths[1]/fish_prompt_time
      #ctags --tag-relative --recurse --exclude=$vcs_paths[1] \
         #-f $vcs_paths[1]/tags \
         #$vcs_paths[2] 2>&1 >/dev/null &
   #end

end

function fish_greeting

   __greeting_git_status

end

function __greeting_git_status

   echo "Status of git repos:"

   set -l cwd (pwd)

   # list common repos (.vim, .dotfiles) that should be pulled
   for repo in $HOME/.vim $HOME/.dotfiles
      cd $repo

      __git_update

      set -l git_status (__git_status)
      set -l has_printed 0

      switch (__git_origin_status $git_status)
         case 'ahead'
            echo -n "   $repo is ahead of origin"
            set has_printed 1
         case 'behind'
            echo -n "   $repo is behind origin"
            set has_printed 1
         case 'diverge'
            echo -n "   $repo has diverged from origin"
            set has_printed 1
      end

      if __git_local_status $git_status | grep "unmerged\|dirty" >/dev/null
         if test $has_printed -eq 1
            echo " and has local changes"
         else
            echo "   $repo has local changes"
         end
      end

   end

   cd $cwd
end

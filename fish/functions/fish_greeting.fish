function fish_greeting

   __greeting_git_status

end

function __greeting_git_status

   set -l has_printed_header 0
   set -l cwd (pwd)

   # list common repos (.vim, .dotfiles) that should be pulled
   for repo in $HOME/.vim $HOME/.dotfiles
      cd $repo

      __git_update

      set -l git_status (__git_status)
      set -l origin_status (__git_origin_status $git_status)
      set -l local_status (__git_local_status $git_status | grep "unmerged\|dirty")

      if begin
              test $has_printed_header -eq 0
              and test -n "$origin_status" -o -n "$local_status"
          end
          echo "Status of git repos:"
          set has_printed_header 1
      end

      set -l has_printed_status 0

      switch $origin_status
          case 'ahead'
              echo -n "   $repo is ahead of origin"
              set has_printed_status 1
          case 'behind'
              echo -n "   $repo is behind origin"
              set has_printed_status 1
          case 'diverge'
              echo -n "   $repo has diverged from origin"
              set has_printed_status 1
      end

      if test -n "$local_status"
         if test $has_printed_status -eq 1
            echo " and has local changes"
         else
            echo "   $repo has local changes"
         end
      else if test -n "$origin_status"
         echo ""
      end

   end

   cd $cwd
end

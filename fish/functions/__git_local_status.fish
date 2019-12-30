function __git_local_status --description 'Check the status of files in the repo: untracked; unmerged; dirty (more than one is possible)'

   # Check the status
   set -l dirty
   set -l untracked
   set -l unmerged

   for line in (__git_status $argv)
      switch $line
         case '\?\?*'
            set untracked "untracked"
         case 'U*' '?U*' 'DD*' 'AA*'
            set unmerged "unmerged"
         case '?M*' 'M*' '?A*' 'A*' '?R*' 'R*' '?D*' 'D*' '?C*' 'C*'
            set dirty "dirty"
      end
   end

   echo $untracked $unmerged $dirty
end

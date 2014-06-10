touch $__prompt_reload_file

function __prompt_vcs --description 'Draw VCS branch name & status'

   switch "$__prompt_saved_vcs_type"
      case "git"
         # TODO: check submodules periodically (print <-)
         set -l vcs_status (git status --short --branch --ignore-submodules ^/dev/null); or return

         if not test "$__prompt_saved_vcs_status" = "$vcs_status"
            __prompt_git $vcs_status
            set -g __prompt_saved_vcs_status $vcs_status
         end

         echo -n -s $__prompt_saved_vcs_info
      case "hg"
         #__prompt_vcs_hg
   end

end

function __prompt_git --description 'Draw the git branch'
   set vcs_status $argv

   # Draw repo ID
   set -l git_prompt $__prompt_char_git[$__prompt_use_utf8] " "

   # Check the status
   set -l dirty 0
   set -l untracked 0
   set -l unmerged 0

   for line in $vcs_status
      switch $line
         case '\?\?*'
            set untracked 1
         case 'U*' '?U*' 'DD*' 'AA*'
            set unmerged 1
            set dirty 1
         case '?M*' 'M*' '?A*' 'A*' '?R*' 'R*' '?D*' 'D*' '?C*' 'C*'
            set dirty 1
      end
   end

   if test $dirty -eq 1
      set git_prompt $git_prompt $__prompt_colour_vcs_dirty
   else
      set git_prompt $git_prompt $__prompt_colour_vcs_clean
   end

   # Draw the branch name
   # time: 1.3s to echo; 1.7s to set
   switch $vcs_status[1]
      case '## Initial commit on *'
         set git_prompt $git_prompt \
            (echo -n $vcs_status[1] | sed 's/^## Initial commit on \(.*\)$/\1/')
      case '## HEAD (no branch)'
         set git_prompt $git_prompt 'no branch'
      case '*'
         ## <branch-name> ...
         ## <branch-name>...origin/<branch-name> ...
         set git_prompt $git_prompt \
            (echo -n $vcs_status[1] | sed -e 's/^## \(\S\+\)/\1/' -e 's/\.\.\..*//')
   end

   if test $untracked -eq 1
      set git_prompt $git_prompt \
         $__prompt_colour_vcs_untracked \
         $__prompt_vcs_status_untracked
   end
   if test $unmerged -eq 1
      set git_prompt $git_prompt \
         $__prompt_colour_vcs_unmerged \
         $__prompt_vcs_status_unmerged
   end

   set git_prompt $git_prompt $__prompt_colour_normal

   # Draw the position relative to origin
   switch $vcs_status[1]
      case '* [ahead *, behind *]'
         set git_prompt $git_prompt \
            $__prompt_vcs_status_ahead[$__prompt_use_utf8] \
            $__prompt_vcs_status_behind[$__prompt_use_utf8]
      case '* [*ahead *]'
         set git_prompt $git_prompt $__prompt_vcs_status_ahead[$__prompt_use_utf8]
      case '* [behind *]'
         set git_prompt $git_prompt $__prompt_vcs_status_behind[$__prompt_use_utf8]
   end

   set -g __prompt_saved_vcs_info $git_prompt

   # Update the remote refs (periodically)
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

touch $__prompt_reload_file

# Requires:
#  - exuberant ctags

function __prompt_git --description 'Check git statuses'

   # TODO: check submodules periodically (print <-)
   set -l vcs_status (git status --short --branch --ignore-submodules --untracked-files=no ^/dev/null); or return
   set -l vcs_paths (git rev-parse --git-dir --show-toplevel --short HEAD)

   if not test "$__prompt_saved_vcs_status" = "$vcs_status"
      set vcs_status[1] (echo $vcs_status[1] | sed -e "s/HEAD (no branch)/detatched at $vcs_paths[3]/")
      __prompt_git_redraw $vcs_status
      set -g __prompt_saved_vcs_status $vcs_status
   end

   echo -n -s $__prompt_saved_vcs_info

   # TODO: keep this time in .git
   touch --date="$__prompt_vcs_update_interval minutes ago" /tmp/fish_prompt_time

   # Update the remote refs
   if command test -f $vcs_paths[1]/FETCH_HEAD -a $vcs_paths[1]/FETCH_HEAD -ot /tmp/fish_prompt_time
      git remote update ^&1 >/dev/null &
   end

   # Update tags
   if command test $vcs_paths[1]/tags -ot /tmp/fish_prompt_time
      ctags --tag-relative --recurse --exclude=$vcs_paths[1] -f $vcs_paths[1]/tags $vcs_paths[2] ^ /dev/null &
   end

end

function __prompt_git_redraw --description 'Draw the git branch'
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
      case '*'
         ## <branch-name> ...
         ## <branch-name>...origin/<branch-name> ...
         set git_prompt $git_prompt \
            (echo -n $vcs_status[1] | sed -e 's/^## \([^\.]*\).*$/\1/')
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

end

touch $__prompt_reload_file

# Requires:
#  - hg prompt extension
#  - exuberant ctags

function __prompt_hg --description 'Check mercurial statuses'

   set -l vcs_status (echo -e (hg prompt "{root|root}\n{branch}\n{+mod{status|modified}}\n{+new{status|unknown}}\n{+out{outgoing}}\n{+in{incoming}}" ^/dev/null)); or return
   set -l vcs_paths $vcs_status[1]
   set vcs_status $vcs_status[2..-1]

   if not test "$__prompt_saved_vcs_status" = "$vcs_status"
      __prompt_hg_redraw $vcs_status
      set -g __prompt_saved_vcs_status $vcs_status
   end

   echo -n -s $__prompt_saved_vcs_info

   touch --date="$__prompt_vcs_update_interval minutes ago" /tmp/fish_prompt_time

   if command test $vcs_paths/.hg/tags -ot /tmp/fish_prompt_time
      ctags --tag-relative --recurse --exclude=$vcs_paths/.hg -f $vcs_paths/.hg/tags $vcs_paths ^ /dev/null &
   end

end

function __prompt_hg_redraw --description 'Draw the mercurial branch'
   set vcs_status $argv

   # Draw repo ID
   set -l hg_prompt $__prompt_char_hg[$__prompt_use_utf8] " "

   # Check for modified files
   if contains "+mod" $vcs_status
      set hg_prompt $hg_prompt $__prompt_colour_vcs_dirty
   else
      set hg_prompt $hg_prompt $__prompt_colour_vcs_clean
   end

   # Draw the branch name
   set hg_prompt $hg_prompt $vcs_status[1]

   # Check for untracked files
   if contains "+new" $vcs_status
      set hg_prompt $hg_prompt \
         $__prompt_colour_vcs_untracked \
         $__prompt_vcs_status_untracked
   end

   set hg_prompt $hg_prompt $__prompt_colour_normal

   # Draw the position relative to origin
   if contains "+out" $vcs_status
      set hg_prompt $hg_prompt $__prompt_vcs_status_ahead[$__prompt_use_utf8]
   end
   if contains "+in" $vcs_status
      set hg_prompt $hg_prompt $__prompt_vcs_status_behind[$__prompt_use_utf8]
   end

   set -g __prompt_saved_vcs_info $hg_prompt

end

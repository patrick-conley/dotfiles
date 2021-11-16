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

   __git_update $vcs_paths >/dev/null &

end

function __prompt_git_redraw --description 'Draw the git branch'
   set vcs_status $argv

   # Draw repo ID
   set -l git_prompt $__prompt_char_git[$__prompt_use_utf8] " "

   # Check the status
   set -l local_status (__git_local_status $vcs_status)

   # Draw the branch name
   # time: 1.3s to echo; 1.7s to set
   switch $vcs_status[1]
      case '## Initial commit on *'
         set git_prompt $git_prompt $__prompt_colour_vcs_dirty \
            (echo -n $vcs_status[1] | sed 's/^## Initial commit on \(.*\)$/\1/')
      case '*'

         ## <branch-name> ...
         ## <branch-name>...origin/<branch-name> ...
         set -l branch_name
         if echo $vcs_status[1] | grep -q "\.\.\."
            set branch_name \
               (echo -n $vcs_status[1] | sed -e 's/^## \(\S*\)\.\.\..*/\1/')
         else
            set branch_name \
               (echo -n $vcs_status[1] | sed -e 's/^## \(\S*\).*/\1/')
         end
            #(echo -n $vcs_status[1] | sed -e 's/^## \([^\.]*\).*$/\1/')

         if begin;
               test $branch_name = master
               and echo $local_status | grep -q "unmerged\|dirty"
            end
            set git_prompt $git_prompt $__prompt_colour_vcs_dirty_master
         else if echo $local_status | grep -q "unmerged\|dirty"
            set git_prompt $git_prompt $__prompt_colour_vcs_dirty
         else
            set git_prompt $git_prompt $__prompt_colour_vcs_clean
         end

         set git_prompt $git_prompt $branch_name
   end

   if echo $local_status | grep "untracked" >/dev/null
      set git_prompt $git_prompt \
         $__prompt_colour_vcs_untracked \
         $__prompt_vcs_status_untracked
   end
   if echo $local_status | grep "unmerged" >/dev/null
      set git_prompt $git_prompt \
         $__prompt_colour_vcs_unmerged \
         $__prompt_vcs_status_unmerged
   end

   set git_prompt $git_prompt $__prompt_colour_normal

   # Draw the position relative to origin
   switch (__git_origin_status $vcs_status[1])
      case 'ahead'
         set git_prompt $git_prompt $__prompt_vcs_status_ahead[$__prompt_use_utf8]
      case 'behind'
         set git_prompt $git_prompt $__prompt_vcs_status_behind[$__prompt_use_utf8]
      case 'diverge'
         set git_prompt $git_prompt \
            $__prompt_vcs_status_ahead[$__prompt_use_utf8] \
            $__prompt_vcs_status_behind[$__prompt_use_utf8]
   end

   set -g __prompt_saved_vcs_info $git_prompt

end

touch $__prompt_reload_file

function __prompt_svn --description 'Print svn status'

   ## this is expensive
   #set -l vcs_status (svn status -q ^/dev/null); or return

   #if not test "$__prompt_saved_vcs_status" = "$vcs_status"
      #__prompt_svn_redraw $vcs_status
      #set -g __prompt_saved_vcs_status $vcs_status
   #end

   if test -z "$__prompt_saved_vcs_status"
      __prompt_svn_redraw
   end

   echo -n -s $__prompt_saved_vcs_info
end

function __prompt_svn_redraw --description 'Regenerate svn status'
   set vcs_status $argv

   # Draw repo ID
   set -l svn_prompt $__prompt_char_svn[2] " "

   ## Check for modified files
   ## Check the status
   set -l dirty 0
   set -l untracked 0
   set -l unmerged 0

   #for line in $vcs_status
      #switch $line
         #case '\?\?*'
            #set untracked 1
         #case 'U*' '?U*' 'DD*' 'AA*'
            #set unmerged 1
            #set dirty 1
         #case '?M*' 'M*' '?A*' 'A*' '?R*' 'R*' '?D*' 'D*' '?C*' 'C*'
            #set dirty 1
      #end
   #end

   if test $dirty -eq 1
      set svn_prompt $svn_prompt $__prompt_colour_vcs_dirty
   else
      set svn_prompt $svn_prompt $__prompt_colour_vcs_clean
   end

   # Draw the branch name
   set svn_prompt $svn_prompt (svn info --show-item relative-url)

   # draw the status
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


   set svn_prompt $svn_prompt $__prompt_colour_normal

   set -g __prompt_saved_vcs_info $svn_prompt
end

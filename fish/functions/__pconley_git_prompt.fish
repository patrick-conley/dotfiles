# Closely based on __terlar_git_prompt.fish
#
# NOTE: To minimize the number of calls made to git functions, you should
# check whether the CWD is a git repo before calling this function. Use
# something similar to
#
#     set -l git_status (git status --short --branch ^/dev/null)
#     if [ (count $git_status) -gt 0 ]
#        echo (__pconley_git_prompt $git_status)
#     end
#
#     # or
#
#     set -l git_status (git status --short --branch ^/dev/null)
#     if [ $git_status != $last_status ]
#        echo (__pconley_git_prompt $git_status)
#        set -g last_status $git_status
#     end
#
# The --branch flag to git ensures that no repository will return an empty
# string. If checking that the status is non-null, remember that it's an
# array.
#
# It is convenient (and possibly quicker) to use 
#     set -l git_status (git status --short --branch ^/dev/null | sort -u)
# but probably not essential

set -gx __prompt_colour_vcs_toplevel (set_color magenta)
set -gx __prompt_colour_vcs_path (set_color green)
set -gx __prompt_colour_vcs_prefix (set_color yellow)
set -gx __prompt_colour_vcs_clean (set_color green)
set -gx __prompt_colour_vcs_dirty (set_color red)
set -gx __prompt_colour_vcs_normal (set_color normal)

 # set -gx __prompt_colour_vcs_added (set_color green)
 # set -gx __prompt_colour_vcs_modified (set_color blue)
 # set -gx __prompt_colour_vcs_renamed (set_color magenta)
 # set -gx __prompt_colour_vcs_copied (set_color magenta)
 # set -gx __prompt_colour_vcs_deleted (set_color red)
set -gx __prompt_colour_vcs_untracked (set_color yellow)
set -gx __prompt_colour_vcs_unmerged (set_color red)

 # set -gx __prompt_vcs_status_added '✚'
 # set -gx __prompt_vcs_status_modified '*'
 # set -gx __prompt_vcs_status_renamed '➜'
 # set -gx __prompt_vcs_status_copied '⇒'
 # set -gx __prompt_vcs_status_deleted '✖'
set -gx __prompt_vcs_status_untracked '?'
set -gx __prompt_vcs_status_unmerged '!'
set -gx __prompt_vcs_status_ahead '+'

set -gx __prompt_char_git "git" "±"

touch /home/pconley/temp/fish-reload

function __pconley_git_prompt --description 'Write out the git prompt'

   set -l status_order untracked unmerged

   # path to the root, path within the repo, name of the branch
   set -l path (git rev-parse --show-toplevel --show-prefix --abbrev-ref HEAD ^/dev/null)

   # check if we are actually in a git repo
   if test (count $path) -eq 0
      return
   end

   # if the repo has never been committed, there is no branch name to return
   if test $path[(count $path)] = "HEAD"
      set path[(count $path)] "initial commit"
   end

   #
   # Print the path to CWD
   #

   # path to the repo (everything before the repo root)
   # based on prompt_pwd
   set -l path_head (echo $path[1] | sed 's/[^/]*$//') # truncate the root
   set path_head (echo $path_head | sed -e "s-^$HOME-~-" -e 's-\([^/]\{1,4\}\)[^/]*/-\1/-g')

   echo -n "$__prompt_colour_block$__prompt_char_pwdl"
   echo -n $__prompt_colour_vcs_path
   echo -n $path_head

   # repo root
   set -l path_toplevel (echo $path[1] | sed "s/^.*\///")

   echo -n $__prompt_colour_vcs_toplevel
   echo -n $path_toplevel

   # path in the repo
   if test (count $path) -eq 3
      set -l path_tail (echo $path[2] | sed 's/\/$//')

      echo -n $__prompt_colour_vcs_prefix
      echo -n "/$path_tail"
   end
   echo -n "$__prompt_colour_block$__prompt_char_pwdr"

   # print the repo ID
   set_color normal
   echo -n " $__prompt_char_git[$__prompt_has_unicode] " 

   #
   # Test whether the repo is clean
   #

   # get the repo's status
   set -l index ""
   set -l ahead ""

   # get the status
   if test (count $argv) -eq 0
      set index (git status --short --branch ^/dev/null | sort -u)
      set -g __prompt_vcs_last_stat "$index"
   else
      set index $argv
   end

   # check whether local is ahead of origin
   if test (echo $index | grep "^## .* \[ahead [0-9]*\]")
      set ahead 1
   end

   # a clean repo will only have set the branch name
   if test (count $index) -le 1
      echo -n $__prompt_colour_vcs_clean
      echo -n $path[(count $path)]

      # notify if local is ahead of origin
      set_color normal
      if test $ahead
         echo -n $__prompt_vcs_status_ahead
      end
      return
   end

   set -l gs
   set -l dirty 0

   for i in $index
      set i (echo $i | cut -c 1-2) # switch requires only the first word

      if echo $i | grep '^\s*[AMRCD]' >/dev/null
         set dirty 1
      end

      switch $i
 #       case 'A '               ; set gs $gs added
 #       case 'M ' ' M'          ; set gs $gs modified
 #       case 'R '               ; set gs $gs renamed
 #       case 'C '               ; set gs $gs copied
 #       case 'D ' ' D'          ; set gs $gs deleted
        case '\?\?'             ; set gs $gs untracked
        case 'U*' '*U' 'DD' 'AA'; set gs $gs unmerged
      end
   end

   if test $dirty -gt 0
      echo -n $__prompt_colour_vcs_dirty
   else
      echo -n $__prompt_colour_vcs_clean
   end

   #
   # Print the branch and status
   #

   # branch name
   echo -n $path[(count $path)]

   # local ahead of origin
   if test $ahead
      set_color normal
      echo -n $__prompt_vcs_status_ahead
   end

   # repo status
   for i in $status_order
      if contains $i in $gs
        set -l color_name __prompt_colour_vcs_$i
        set -l status_name __prompt_vcs_status_$i

        echo -n $$color_name
        echo -n $$status_name
      end
   end

   set_color normal
end

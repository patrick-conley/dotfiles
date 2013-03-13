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

set -gx __prompt_char_hg "hg" "☿"

touch /home/pconley/temp/fish-reload

function __pconley_hg_prompt --description "Write out the mercurial prompt"

   set -l status_order untracked

   # path to the root
   set -l root (hg root ^/dev/null)

   # check if we are actually in a mercurial repo
   if test -z $root
      return
   end

   # 
   # print the path to CWD
   #

   # path to the repo root
   # based on prompt_pwd
   set -l path_head (echo $root | sed 's/[^/]*$//' | sed -e "s-^$HOME-~-" -e 's-\([^/]\{1,4\}\)[^/]*/-\1/-g')

   echo -n $__prompt_colour_vcs_path
   echo -n $path_head

   # repo root
   echo -n $__prompt_colour_vcs_toplevel
   echo -n (echo $root | sed "s-^.*/--" )

   # path in the repo
   if test $root != $PWD
      echo -n $__prompt_colour_vcs_prefix
      set -l escaped_root ( echo $root | sed -e 's-/-\\\\/-g' )
      echo -n ( echo $PWD | sed "s/$escaped_root//" )
   end

   # print the repo ID
   set_color normal
   echo -n "$__prompt_char_hg[$__prompt_has_unicode] "

   # 
   # Test whether the repo is clean
   #

   # get the repo's status
   # It may have been passed to this function by check_pwd
   set -l index ""

   if test (count $argv) -eq 0
      set index (hg status ^/dev/null)
      set -g __prompt_vcs_last_stat "$index"
   else
      set index $argv
   end

   # a clean repo will have nothing in the status
   if test (count $index) -eq 0
      echo -n $__prompt_colour_vcs_clean
      echo -n (hg branch)
      set_color normal
      return
   end

   set -l gs
   set -l dirty 0

   for i in $index
      set i (echo $i | cut -c 1-2) # switch requires only the status symbols

      if echo $i | grep '^\s*[AMRC]' >/dev/null
         set dirty 1
      end

      switch $i
 #          case 'A '               ; set gs $gs added
 #          case 'M ' ' M'          ; set gs $gs modified
 #          case 'C '               ; set gs $gs copied
 #          case 'R '               ; set gs $gs missing
         case '\?'  ; set gs $gs untracked
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

   echo -n (hg branch)

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

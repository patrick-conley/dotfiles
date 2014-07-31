touch $__prompt_reload_file

function __prompt_cwd --description 'Draw the working directory and VCS info'

   if not set -q __prompt_saved_cwd
      __prompt_set_cwd
   end

   echo -n -s $__prompt_saved_cwd

end

function __prompt_set_cwd --on-variable PWD --description 'Update the cwd when the directory changes'

   # Delimiter characters in variables embedded in sed expressions must be
   # escaped
   set -l escaped_home (echo $HOME | sed 's-/-\\\\/-g')

   # Check if we're in a VCS repository
   # git
   if set vcs_root (git rev-parse --show-toplevel --show-prefix ^/dev/null)
      set -g __prompt_saved_vcs_type "git"

      if test (count $vcs_root) -eq 1
         set vcs_root[2] ""
      end

   # mercurial
   else if set vcs_root (echo -e (hg prompt "{root}\n{root|prefix}"))
      set -g __prompt_saved_vcs_type "hg"

      if test (count $vcs_root) -eq 1
         set vcs_root[2] ""
      end
   else
      set -e __prompt_saved_vcs_type
   end

   if not set -q __prompt_saved_vcs_type

      # TODO: truncate the directory names if the prompt is long
      set -g __prompt_saved_cwd \
         $__prompt_colour_block $__prompt_char_pwd_l \
         $__prompt_colour_pwd (echo $PWD | sed "s/^$escaped_home/~/") \
         $__prompt_colour_block $__prompt_char_pwd_r \
         $__prompt_colour_normal

   else

      # The lengthy var substitution below changes "/home/me" to "~", then
      # truncates each directory above the repo root to its first few
      # characters

      set -l head (echo $vcs_root[1] | \
            sed -e "s/^$escaped_home/~/" -e  's/[^/]*$//' -e "s-\([^/]\{1,4\}\)[^/]*/-\1/-g")
      set -l root (echo $vcs_root[1] | sed 's-.*/--')
      set -l prefix (echo $vcs_root[2] | sed -e 's-^\([^/]\)-/\1-' -e 's-/$--')

      set -g __prompt_saved_cwd \
         $__prompt_colour_block $__prompt_char_pwd_l \
         $__prompt_colour_pwd $head \
         $__prompt_colour_vcs_toplevel $root \
         $__prompt_colour_vcs_prefix $prefix \
         $__prompt_colour_block $__prompt_char_pwd_r \
         $__prompt_colour_normal

      end

end

# FIXME: I don't recall whether this works
#function __prompt_cwd_trunc --description "Limit the length of the CWD string"

   ## tokenize the CWD
   #set -l cwd_tokens (echo $argv[1] | grep -o "[^/]*")

   ## set the maximum allowed length
   #set -g cwd_max_allowed 60
   #if set -q __prompt_cwd_prefix_len
      #set cwd_max_allowed (math (tput cols)-$__prompt_cwd_prefix_len-2)
   #end

   ## Just print the CWD if it's short enough
   #if test (expr length $argv[1]) -le $cwd_max_allowed
      #echo -n $argv[1]
   #else

      ## the last directory in the tree must display in full
      #set -l last_dir_len ( expr length ( echo $argv[1] | grep -o '[^/]*$' ) )

      #set -l cwd_depth (echo $argv[1] | grep -o "/" | wc -l )
      #set -l char_lim (math $cwd_max_allowed-$last_dir_len)

      #set -l max_per_dir (math "$char_lim/$cwd_depth" )

      ## Short directory names give me extra characters to play with
      #for dir in $cwd_tokens
         #if test (expr length $dir) -lt $max_per_dir
            #set char_lim (math $char_lim+$max_per_dir-(expr length $dir))
         #end
      #end

      ## FIXME: if max_per_dir goes over six, then it gets reduced and even 5
      ## or 6-character directories get truncated

      ## Put ellipses in the replacement
      #set max_per_dir (math "$char_lim/$cwd_depth")
      #set repl_char ""
      #if test $max_per_dir -ge 6
         #set max_per_dir (math $max_per_dir-2)
         #set repl_char ".."
      #end

      ## Overflow if we have to, but make sure the directory names are readable
      #if test $max_per_dir -lt 3
         #set max_per_dir 3
      #end

      ## set the path; add ellispes if there's room
      #for dir in $cwd_tokens[1..(math (count $cwd_tokens)-1)]
         #if test (expr length $dir) -gt $max_per_dir
            #echo -n $dir | sed -e "s/\(.\{1,$max_per_dir\}\).*/\1$repl_char/"
            #echo -n "/"
         #else
            #echo -n "$dir/"
         #end
      #end

      #echo -n $cwd_tokens[(count $cwd_tokens)]
   #end

#end

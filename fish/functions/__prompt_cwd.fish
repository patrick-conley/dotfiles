touch $__prompt_reload_file

set -g __prompt_cwd_min_space 30
set -g __prompt_cwd_max_width 100

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
   else if set vcs_root (hg prompt "{root}\n{root|prefix}" ^/dev/null)
      set vcs_root (echo -e $vcs_root)
      set -g __prompt_saved_vcs_type "hg"

      if test (count $vcs_root) -eq 1
         set vcs_root[2] ""
      end
   else
      set -e __prompt_saved_vcs_type
   end

   # FIXME: this step is 15% of the function's running time
   set -l max_width (math "$__prompt_term_cols - $__prompt_cwd_min_space")
   if test $max_width -gt $__prompt_cwd_max_width
      set max_width $__prompt_cwd_max_width
   end

   if not set -q __prompt_saved_vcs_type

      set local_pwd (echo $PWD | sed "s/^$escaped_home/~/")

      # Truncate the directory names if they're too long
      if test (echo $local_pwd | wc -c) -gt $max_width
         set -l nDirs (echo -n $local_pwd | grep -o "/" | wc -l)
         set -l max (math "$max_width / ($nDirs + 1)")

         if test $max -lt 4
            set local_pwd (echo $local_pwd | sed -e "s-\([^/]\{1,4\}\)[^/]*/-\1/-g")
         else
            set local_pwd (echo $local_pwd | sed -e "s-\([^/]\{1,$max\}\)[^/]*/-\1/-g")
         end
      end

      set -g __prompt_saved_cwd \
         $__prompt_colour_block $__prompt_char_pwd_l \
         $__prompt_colour_pwd $local_pwd \
         $__prompt_colour_block $__prompt_char_pwd_r \
         $__prompt_colour_normal

   else

      # Remove unwanted characters (extra "/", /home/username, etc.)
      # Always truncate directory names outside the repository.
      # If the CWD is too long, remove the outside directories entirely, and
      # truncate directory names within the repository as needed.
      set -l head (echo $vcs_root[1] | sed -e "s/^$escaped_home/~/" -e  's/[^/]*$//' -e "s-\([^/]\{1,4\}\)[^/]*/-\1/-g")
      set -l root (echo $vcs_root[1] | sed 's-.*/--')
      set -l prefix (echo $vcs_root[2] | sed -e 's-^\([^/]\)-/\1-' -e 's-/$--')

      if test -n $prefix -a (echo "$head$root$prefix" | wc -c) -gt $max_width
         set head ""

         if test (echo -n "$root$prefix" | wc -c) -gt $max_width
            set -l nDirs (echo -n $prefix | grep -o "/" | wc -l)
            set -l rootLen (echo -n $root | wc -c)
            set -l max (math "($max_width - $rootLen) / $nDirs")

            if test $max -lt 4
               set prefix (echo $prefix | sed -e "s-\([^/]\{1,4\}\)[^/]*/-\1/-g")
            else
               set prefix (echo $prefix | sed -e "s-\([^/]\{1,$max\}\)[^/]*/-\1/-g")
            end
         end
      end

      set -g __prompt_saved_cwd \
         $__prompt_colour_block $__prompt_char_pwd_l \
         $__prompt_colour_pwd $head \
         $__prompt_colour_vcs_toplevel $root \
         $__prompt_colour_vcs_prefix $prefix \
         $__prompt_colour_block $__prompt_char_pwd_r \
         $__prompt_colour_normal

      end

end

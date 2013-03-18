# Every time the prompt is displayed, check if the CWD should be updated:
# - if we are known to be in a vcs repo (__prompt_vcs_type is true), get
#   the repo's status and compare it to __prompt_vcs_last_stat. If they
#   differ, call that vcs's redraw function, with the new status as an
#   argument
# - if the directory changes, call all the vcs functions until one matches,
#   and fall back to displaying pwd (--on-variable). Reset
#   __prompt_vcs_type and __prompt_vcs_last_stat
# - if a vcs command is called (eg., `git`), call the appropriate vcs's redraw
#   function. May be possible with --on-event), or I may wrap functions
#   around all the vcs commands that call __prompt_set_cwd
set -g __prompt_colour_pwd (set_color green)

touch /home/pconley/temp/fish-reload

# reset everything 
# Set __prompt_cwd and __prompt_arrow
function __prompt_set_cwd --on-variable PWD --description "Event handler: reset the cwd"

   # git
   set -l temp_status (git status --short --branch ^/dev/null)
   if test (count $temp_status) -gt 0
      set -g __prompt_vcs_type "git"
      __pconley_git_prompt --force $temp_status

   # mercurial
   else if not test -z (hg root ^/dev/null)
      set -g __prompt_vcs_type "hg"
      set -g __prompt_cwd (__pconley_hg_prompt)

   # not a VCS
   else
      set -g __prompt_vcs_type ""
      set -g __prompt_vcs_last_stat ""

      # derive the prompt manually
      set -l cwd (__prompt_cwd_trunc (pwd | sed -e "s-^$HOME-~-" ))
      set -g __prompt_cwd "$__prompt_colour_block$__prompt_char_pwdl"
      set -g __prompt_cwd "$__prompt_cwd$__prompt_colour_pwd$cwd"
      set -g __prompt_cwd "$__prompt_cwd$__prompt_colour_block$__prompt_char_pwdr"
      set -l stack (__prompt_get_dirs)
      set -g __prompt_cwd "$__prompt_cwd$__prompt_colour_normal$stack"
   end

   # Set the prompt character (depending whether I can write)
   if test -w $PWD
      set -g __prompt_arrow $__prompt_char_arrow[$__prompt_utf8]
   else
      set -g __prompt_arrow $__prompt_char_arrow_nowrite[$__prompt_utf8]
   end

end

function __prompt_get_dirs --description "Check whether pushd has been used"

   # Check the depth of the directory stack
   if test (count (echo (dirs) | sed -e "s/  /\n/g" )) -gt 2
      echo -n "$__prompt_char_pushd[$__prompt_utf8]"
   end

end

# Try to ensure long paths don't overflow the line
function __prompt_cwd_trunc --description "Limit the length of the CWD string"

   # tokenize the CWD
   set -l cwd_tokens (echo $argv[1] | grep -o "[^/]*")

   # set the maximum allowed length
   set -g cwd_max_allowed 60
   if set -q __prompt_cwd_prefix_len
      set cwd_max_allowed (math (tput cols)-$__prompt_cwd_prefix_len-2)
   end

   # Just print the CWD if it's short enough
   if test (expr length $argv[1]) -le $cwd_max_allowed
      echo -n $argv[1]
   else

      # the last directory in the tree must display in full
      set -l last_dir_len ( expr length ( echo $argv[1] | grep -o '[^/]*$' ) )

      set -l cwd_depth (echo $argv[1] | grep -o "/" | wc -l )
      set -l char_lim (math $cwd_max_allowed-$last_dir_len)

      set -l max_per_dir (math "$char_lim/$cwd_depth" )

      # Short directory names give me extra characters to play with
      for dir in $cwd_tokens
         if test (expr length $dir) -lt $max_per_dir
            set char_lim (math $char_lim+$max_per_dir-(expr length $dir))
         end
      end

      # FIXME: if max_per_dir goes over six, then it gets reduced and even 5
      # or 6-character directories get truncated

      # Put ellipses in the replacement
      set max_per_dir (math "$char_lim/$cwd_depth")
      set repl_char ""
      if test $max_per_dir -ge 6
         set max_per_dir (math $max_per_dir-2)
         set repl_char ".."
      end

      # Overflow if we have to, but make sure the directory names are readable
      if test $max_per_dir -lt 3
         set max_per_dir 3
      end

      # set the path; add ellispes if there's room
      for dir in $cwd_tokens[1..(math (count $cwd_tokens)-1)]
         if test (expr length $dir) -gt $max_per_dir
            echo -n $dir | sed -e "s/\(.\{1,$max_per_dir\}\).*/\1$repl_char/"
            echo -n "/"
         else
            echo -n "$dir/"
         end
      end

      echo -n $cwd_tokens[(count $cwd_tokens)]
   end
   
end

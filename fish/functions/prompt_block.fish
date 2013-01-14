set -g __prompt_colour_block (set_color cyan)
set -g __prompt_colour_pwd (set_color green)
set -g __prompt_colour_host (set_color -o red)
set -g __prompt_colour_shlvl (set_color yellow)
set -g __prompt_colour_date (set_color -o yellow)
set -g __prompt_colour_normal (set_color normal)
set -g __prompt_colour_status (set_color red)

set -g __prompt_has_unicode 2
set -g __prompt_char_blockl1 "|" "⎧" # ⎛⎡⎧ ⌠
set -g __prompt_char_blockl3 "|" "⎩" # ⎝⎣⎩ ⌡
set -g __prompt_char_blockr1 "|" "⎫" # ⎞⎤⎫
set -g __prompt_char_blockr2 "|" "⎭" # ⎠⎦⎭
set -g __prompt_char_arrow ">" "≻"
set -g __prompt_char_shell "fish" "♓"

touch /home/pconley/temp/fish-reload

function prompt_block --description 'Two-line prompt with time, host, SHLVL, shell, status, cwd, and vcs info'
   set -l last_status $argv[1]

   # set some variables
   if not set -q __prompt_block_host
      set -g __prompt_block_host (__prompt_set_block_host)
   end

   __prompt_check_cwd

   echo
   
   # upper level
   echo -n "$__prompt_colour_block$__prompt_char_blockl1[$__prompt_has_unicode] "
   echo -n "$__prompt_colour_date"(date "+%d %b at %H:%M")"$__prompt_colour_normal"
   echo -n "$__prompt_colour_block $__prompt_char_blockr1[$__prompt_has_unicode] "

   # display the CWD
   echo -n "$__prompt_cwd"

   echo

   # lower level
   echo -n "$__prompt_colour_block$__prompt_char_blockl3[$__prompt_has_unicode] "
   echo -n $__prompt_block_host
   echo -n "$__prompt_colour_block $__prompt_char_blockr2[$__prompt_has_unicode]"

   # print status
   if not test $last_status -eq 0
      echo -n "$__prompt_colour_normal ($__prompt_colour_status$last_status$__prompt_colour_normal)"
   end

   if test -e "/home/pconley/temp/fish-reload"
      echo -n "$__prompt_colour_status $__prompt_char_arrow[$__prompt_has_unicode] $__prompt_colour_normal"
      rm "/home/pconley/temp/fish-reload"
else
      echo -n "$__prompt_colour_normal $__prompt_char_arrow[$__prompt_has_unicode] $__prompt_colour_normal"
   end

end

function __prompt_set_block_host --description "Set the host area of the prompt"

   # TODO: This length should be global: if the host block is longer than the
   # date block, the date block should be padded.
   # - means the host block must be set before the date block
   # - in case I change the contents of the date block, this function should
   #   have an event trigger to correct itself to the actual length
   set -l len_date 15

   # set & draw the shell depth
   set -l p_shlvl $__prompt_colour_normal
   set -l len_shlvl 0
   if test $SHLVL -gt 1
      set p_shlvl "$__prompt_colour_shlvl$SHLVL$__prompt_colour_normal""x"
      set len_shlvl 2
   end
   echo -n $p_shlvl

   # set & draw the hostname
   set -l p_host (hostname -s)
   set -l len_host (echo $p_host | wc -c)
   echo -n "$__prompt_colour_host$p_host"

   set -l len_upper (math $len_date-$len_shlvl-$len_host)

   for i in (seq $len_upper )
      echo -n " "
   end

   # TODO: use 'fish' as the ASCII shell ID. Account for that in the length
   echo -n "$__prompt_colour_normal$__prompt_char_shell[$__prompt_has_unicode]"
end

function prompt_unicode_disable
   set -g __prompt_has_unicode 1
   __prompt_reset
end

function prompt_unicode_enable
   set -g __prompt_has_unicode 2
   __prompt_reset
end

function __prompt_reset --description "Reset all parts of the prompt"
   __prompt_set_cwd
   set -g __prompt_block_host (__prompt_set_block_host)
end

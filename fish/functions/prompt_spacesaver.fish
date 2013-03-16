set -g __prompt_colour_block (set_color cyan)
set -g __prompt_colour_pwd (set_color green)
set -g __prompt_colour_host (set_color -o red)
set -g __prompt_colour_shlvl (set_color yellow)
set -g __prompt_colour_arrow (set_color -o red)
set -g __prompt_colour_date (set_color -o yellow)
set -g __prompt_colour_normal (set_color normal)
set -g __prompt_colour_status (set_color red)

set -g __prompt_utf8 2
set -g __prompt_char_blockl1 "|" "⎧" # ⎛⎡⎧ ⌠
set -g __prompt_char_blockl2 "|" "⎨" # ⎧⎨⎩⎫⎭
set -g __prompt_char_blockl3 "|" "⎩" # ⎝⎣⎩ ⌡
set -g __prompt_char_blockr1 "|" "⎫" # ⎞⎤⎫
set -g __prompt_char_blockr2 "|" "⎭" # ⎠⎦⎭
set -g __prompt_char_arrow ">" "≻"
set -g __prompt_char_shell "fish" "♓"

touch /home/pconley/temp/fish-reload

function prompt_spacesaver --description 'Three-line prompt with time, shell, status, cwd, and vcs info'
   set -l last_status $argv[1]

   # set some variables
   if test -z "$__prompt_cwd"
      set -g __prompt_cwd (__prompt_set_cwd)
   end

   if test -z "$__prompt_ss_host"
      set -g __prompt_ss_host (__prompt_ss_set_host)
   end

   if test -z "$__prompt_tail_middle"
      set -g __prompt_tail_middle (__prompt_ss_set_tail_middle)
   end

   __prompt_check_cwd

   echo
   
   # upper level
   echo -n "$__prompt_colour_block$__prompt_char_blockl1[$__prompt_utf8] "
   echo -n "$__prompt_colour_date"(date "+%d %b at %H:%M")"$__prompt_colour_normal"
   echo -n "$__prompt_colour_block $__prompt_char_blockr1[$__prompt_utf8] "

   # display the CWD
   echo -n "$__prompt_cwd"

   echo

   # middle level
   echo -n "$__prompt_colour_block$__prompt_char_blockl2[$__prompt_utf8] "
   echo -n $__prompt_ss_host
   echo -n "$__prompt_colour_block $__prompt_char_blockr2[$__prompt_utf8] "

   echo -n "$__prompt_tail_middle"

   echo

   # lower level
   echo -n "$__prompt_colour_block$__prompt_char_blockl3[$__prompt_utf8] "
   if not test $last_status -eq 0
      echo -n "$__prompt_colour_normal($__prompt_colour_status$last_status$__prompt_colour_normal) "
   end

   if test -e "/home/pconley/temp/fish-reload"
      echo -n "$__prompt_colour_status$__prompt_char_arrow[$__prompt_utf8] $__prompt_colour_normal"
      rm "/home/pconley/temp/fish-reload"
   else
      echo -n "$__prompt_colour_normal$__prompt_char_arrow[$__prompt_utf8] $__prompt_colour_normal"
   end

end

function __prompt_ss_set_host --description "Set the centre line of the prompt block (called once)"

   set -l len_date 15

   set -l p_host (hostname -s)
   set -l len_host (echo $p_host | wc -c)
   set len_host (math "$len_host-1")
   set -l p_host "$__prompt_colour_host$p_host$__prompt_colour_normal"

   set -l os (uname)
   if test $os = "Linux" -a $__prompt_utf8 -eq 2
      set -l os (cat /etc/issue)
      if test (echo $os | grep "Ubuntu")
         set p_host "$p_host"""
         set len_host (math "$len_host+1")
      end
      set p_host "$p_host"""
      set len_host (math "$len_host+1")
   else if test $os = "Darwin"
      set p_host "$p_host""⌘ "
      set len_host (math "$len_host+1")
   end

   echo -n $p_host

   set -l remaining_len (math $len_date-$len_host)
   for i in (seq $remaining_len)
      echo -n " "
   end
end

function __prompt_ss_set_tail_middle --on-variable SHLVL --description "Event handler: set the shell level etc."

   echo -n "$__prompt_colour_normal$__prompt_char_shell[$__prompt_utf8]"

   if test $SHLVL -gt 1
      echo -n "$__prompt_colour_normal in $__prompt_colour_shlvl$SHLVL"
      echo -n "$__prompt_colour_normal"
   end
end

function prompt_unicode_disable
   set -g __prompt_utf8 1
   __prompt_reset
end

function prompt_unicode_enable
   set -g __prompt_utf8 2
   __prompt_reset
end

function __prompt_reset --description "Reset all parts of the prompt"
   __prompt_set_cwd
   set -g __prompt_ss_host (__prompt_ss_set_host)
end

set -g __prompt_colour_block (set_color cyan)
set -g __prompt_colour_pwd (set_color green)
set -g __prompt_colour_host (set_color -o red)
set -g __prompt_colour_normal (set_color normal)
set -g __prompt_colour_status (set_color red)

set -g __prompt_has_unicode 2
set -g __prompt_char_blockl1 "|" "⎧" # ⎛⎡⎧ ⌠
set -g __prompt_char_blockl3 "|" "⎩" # ⎝⎣⎩ ⌡
set -g __prompt_char_arrow ">" "≻"
set -g __prompt_char_shell "fish" "♓"
set -g __prompt_char_linux " (linux)" "" # Tux (fonts-linuxlibertine)
set -g __prompt_char_mac " (os x)" "⌘ "
set -g __prompt_char_ubuntu "" "" # Ubuntu logo (ubuntu font)

touch /home/pconley/temp/fish-reload

function prompt_timeless --description 'Two-line prompt with host, SHLVL, shell, status, cwd, and vcs info'
   set -l last_status $argv[1]

   # set some variables
   if not set -q __prompt_timeless_host
      set -g __prompt_timeless_host (__prompt_set_timeless_host)
   end

   __prompt_check_cwd

   echo
   
   # upper level
   echo -n "$__prompt_colour_block$__prompt_char_blockl1[$__prompt_has_unicode] "
   echo -n $__prompt_timeless_host
   echo -n " "

   # display the CWD
   echo -n "$__prompt_cwd"

   echo

   # lower level
   echo -n "$__prompt_colour_block$__prompt_char_blockl3[$__prompt_has_unicode] "

   echo -n "$__prompt_colour_normal$__prompt_char_shell[$__prompt_has_unicode] "

   # print status
   if not test $last_status -eq 0
      echo -n "$__prompt_colour_normal($__prompt_colour_status$last_status$__prompt_colour_normal) "
   end

   if test -e "/home/pconley/temp/fish-reload"
      echo -n "$__prompt_colour_status$__prompt_char_arrow[$__prompt_has_unicode] $__prompt_colour_normal"
      rm "/home/pconley/temp/fish-reload"
   else
      echo -n "$__prompt_colour_normal$__prompt_char_arrow[$__prompt_has_unicode] $__prompt_colour_normal"
   end

end

function __prompt_set_timeless_host --description "Set the host area of the prompt"

   # set & draw the hostname
   set -l p_host (hostname)
   set -l len (expr length $p_host)
   echo -n "$__prompt_colour_host$p_host$__prompt_colour_normal"

   # set & draw the shell depth
   if test $SHLVL -gt 1
      echo -n "+"
      set len (math $len+1)
   end

   set -l os (uname)
   if test $os = "Linux"
      set -l os (cat /etc/issue)
      if test (echo $os | grep "Ubuntu")
         echo -n "$__prompt_char_ubuntu[$__prompt_has_unicode]"
         set len (math $len+(expr length $__prompt_char_ubuntu[$__prompt_has_unicode]))
      end
      echo -n "$__prompt_char_linux[$__prompt_has_unicode]"
      set len (math $len+(expr length $__prompt_char_linux[$__prompt_has_unicode]))
   else if test $os = "Darwin"
      echo -n "$__prompt_char_mac[$__prompt_has_unicode]"
      set len (math $len+(expr length $__prompt_char_mac[$__prompt_has_unicode]))
   end

   set -g __prompt_cwd_prefix_len $len

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
   set -g __prompt_timeless_host (__prompt_set_timeless_host)
end

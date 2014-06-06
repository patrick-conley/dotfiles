set -g __prompt_colour_normal (set_color normal)
set -g __prompt_colour_block (set_color cyan)
set -g __prompt_colour_pwd (set_color green)
set -g __prompt_colour_host (set_color -o red)
set -g __prompt_colour_status (set_color red)
set -g __prompt_colour_shlvl (set_color normal)

set -g __prompt_colour_vcs_toplevel (set_color magenta)
set -g __prompt_colour_vcs_path (set_color green)
set -g __prompt_colour_vcs_prefix (set_color yellow)
set -g __prompt_colour_vcs_clean (set_color green)
set -g __prompt_colour_vcs_dirty (set_color red)
set -g __prompt_colour_vcs_normal (set_color normal)
set -g __prompt_colour_vcs_detatched (set_color magenta)

 # set -gx __prompt_colour_vcs_added (set_color green)
 # set -gx __prompt_colour_vcs_modified (set_color blue)
 # set -gx __prompt_colour_vcs_renamed (set_color magenta)
 # set -gx __prompt_colour_vcs_copied (set_color magenta)
 # set -gx __prompt_colour_vcs_deleted (set_color red)
set -g __prompt_colour_vcs_untracked (set_color yellow)
set -g __prompt_colour_vcs_unmerged (set_color red)

 # set -gx __prompt_vcs_status_added '✚'
 # set -gx __prompt_vcs_status_modified '*'
 # set -gx __prompt_vcs_status_renamed '➜'
 # set -gx __prompt_vcs_status_copied '⇒'
 # set -gx __prompt_vcs_status_deleted '✖'
set -g __prompt_vcs_status_untracked '?'
set -g __prompt_vcs_status_unmerged '!'
set -g __prompt_vcs_status_ahead "+" "↑"
set -g __prompt_vcs_status_behind "-" "↓"

set -g __prompt_char_git "git" "±"
set -g __prompt_char_hg "hg" "☿"

# Time since origin has last been checked
set -g __prompt_vcs_update_time 5

set -g __prompt_char_shlvl "" # "+"
set -g __prompt_char_pwd_l "("
set -g __prompt_char_pwd_r ")"
set -g __prompt_char_pushd "+" "+"

set -g __prompt_use_utf8 2
set -g __prompt_char_block_l1 "|" "⎧" # ⎛⎡⎧ ⌠
set -g __prompt_char_block_l2 "|" "⎪" # ⎛⎡⎧ ⌠
set -g __prompt_char_block_l3 "|" "⎩" # ⎝⎣⎩ ⌡
set -g __prompt_char_block_r1 "|" "⎫" # ⎛⎡⎧ ⌠
set -g __prompt_char_block_r2 "|" "⎪" # ⎛⎡⎧ ⌠
set -g __prompt_char_block_r3 "|" "⎭" # ⎝⎣⎩ ⌡
set -g __prompt_char_arrow ">" "≻"
set -g __prompt_char_arrow_nowrite ">" "⊁"
set -g __prompt_char_shell "fish" "♒"
set -g __prompt_char_linux " (linux)" "" # "" # Tux (fonts-linuxlibertine - installed with LaTeX)
set -g __prompt_char_mac " (os x)" "" # "⌘ "
set -g __prompt_char_ubuntu "" "" # "" # Ubuntu logo (ubuntu font)

touch $__prompt_reload_file

function prompt_timeless --description 'Two-line prompt with host, SHLVL, shell, status, cwd, and vcs info'
   set -l last_status $argv[1]

   echo

   # upper level
   echo -n -s \
      (__prompt_block l1) " " \
      (__prompt_host) " " \
      (__prompt_dir_stack) (__prompt_cwd) " " \
      (__prompt_vcs) \

   echo

   # lower level
   echo -n \
      (__prompt_block l3) \
      (__prompt_shell) \
      (__prompt_status $last_status) \
      (__prompt_arrow) \
      ""

end

function prompt_unicode_disable
   set -g __prompt_use_utf8 1
   __prompt_reset
end

function prompt_unicode_enable
   set -g __prompt_use_utf8 2
   __prompt_reset
end

function __prompt_reset --description "Reset all parts of the prompt"
   __prompt_set_cwd
   set -g __prompt_timeless_host (__prompt_set_timeless_host)
end

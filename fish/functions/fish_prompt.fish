set -g __prompt_reload_file "/tmp/fish-reload"

if not set -q prompt_name
   set -x prompt_name 'timeless'
end

touch $__prompt_reload_file

function fish_prompt --description 'Write out the prompt'
   set -l last_status $status

   if not set -q __prompt_colour_normal
      __prompt_load_symbols
   end

   # Try to use the default first: the time needed to run the test is
   # negligible, while that for eval is large
   if test $prompt_name = "timeless"
      prompt_timeless $last_status
   else
      eval prompt_$prompt_name $last_status
   end
end

function set_prompt --description 'Set the prompt type'
   if test (count $argv) -eq 0
      echo "Prompts available:"
      for name in (ls $HOME/.config/fish/functions/prompt*.fish)
         echo
         set name (echo $name | sed 's/\.fish$//')
         set name (echo $name | sed "s-^.*/--")
         echo -n "   $name:"
         eval $name
         echo
      end
   else
      set -x prompt_name $argv[1]
   end
end

function prompt_unicode_disable
   set -g __prompt_use_utf8 1
   __prompt_reset
end

function prompt_unicode_enable
   set -g __prompt_use_utf8 2
   __prompt_reset
end

function __prompt_load_symbols --description 'Load mnemonic characters and colours'
   set -g __prompt_use_utf8 2

   set -g __prompt_colour_normal (set_color normal)
   set -g __prompt_colour_block (set_color cyan)
   set -g __prompt_colour_pwd (set_color green)
   set -g __prompt_colour_host (set_color -o red)
   set -g __prompt_colour_status (set_color red)
   set -g __prompt_colour_shlvl (set_color normal)
   set -g __prompt_colour_date (set_color -o yellow)

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
   set -g __prompt_char_svn "svn" "𝓢"

   # Time since origin has last been checked
   set -g __prompt_vcs_update_interval 15

   set -g __prompt_char_pwd_l "("
   set -g __prompt_char_pwd_r ")"
   set -g __prompt_char_pushd "+" "+"

   set -g __prompt_char_block_l1 "|" "⎧" # ⎛⎡⎧ ⌠
   set -g __prompt_char_block_l2 "|" "⎪" # ⎛⎡⎧ ⌠
   set -g __prompt_char_block_l3 "|" "⎩" # ⎝⎣⎩ ⌡
   set -g __prompt_char_block_r1 "|" "⎫" # ⎛⎡⎧ ⌠
   set -g __prompt_char_block_r2 "|" "⎪" # ⎛⎡⎧ ⌠
   set -g __prompt_char_block_r3 "|" "⎭" # ⎝⎣⎩ ⌡
   set -g __prompt_char_arrow ">" "≻"
   set -g __prompt_char_arrow_nowrite ">" "⊁"
   #set -g __prompt_char_shell "fish" "♒"# in my vm this messes up line length
   set -g __prompt_char_shell "fish" "f"
   set -g __prompt_char_shlvl "+"
   set -g __prompt_char_linux " (linux)" "" # "" # Tux (fonts-linuxlibertine - installed with LaTeX)
   set -g __prompt_char_mac " (os x)" "⌘" # "⌘ "
   set -g __prompt_char_ubuntu "" "" # "" # Ubuntu logo (ubuntu font)
end

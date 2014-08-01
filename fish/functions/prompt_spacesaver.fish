touch $__prompt_reload_file

function prompt_spacesaver --description 'Three-line prompt with time, shell, status, cwd, and vcs info'
   set -l last_status $argv[1]

   # set some variables
   if not set -q __prompt_ss_host
      set -g __prompt_ss_host (__prompt_ss_set_host)
   end

   echo

   echo -n -s \
      (__prompt_block l1) " " \
      (__prompt_date) \
      (__prompt_block r1) " " \
      (__prompt_dir_stack) (__prompt_cwd) " " (__prompt_vcs)

   echo

   echo -n \
      (__prompt_block l2) \
      $__prompt_ss_host \
      (__prompt_block r3) \
      (__prompt_status $last_status) \
      (__prompt_shell) \

   echo

   echo -n \
      (__prompt_block l3) \
      (__prompt_arrow) \
      ""
end

function __prompt_ss_set_host --description "Set the centre line of the prompt block (called once)"

   set -l len_date 15

   set -l len_shlvl 0
   if test -z $TMUX -a $SHLVL -gt 1 -o $SHLVL -gt 2
      set len_shlvl (echo -n $__prompt_char_shlvl | wc -m)
   end

   set -l len_hostname (hostname -s | wc -m)

   set -l host (__prompt_os_symbol)
   set -l len_host (echo -n $host | wc -m)

   echo -n -s \
      (__prompt_shlvl) \
      (__prompt_host)

   set -l remaining_len (math $len_date-$len_shlvl-$len_hostname-$len_host)
   for i in (seq $remaining_len)
      echo -n " "
   end

   echo -n $host
end

function __prompt_reset --description "Reset all parts of the prompt"
   __prompt_set_cwd
   set -g __prompt_ss_host (__prompt_ss_set_host)
end

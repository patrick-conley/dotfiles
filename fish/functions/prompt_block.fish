touch $__prompt_reload_file

function prompt_block --description 'Two-line prompt with time, host, SHLVL, shell, status, cwd, and vcs info'
   set -l last_status $argv[1]

   # set some variables
   if not set -q __prompt_block_host
      set -g __prompt_block_host (__prompt_set_block_host)
   end

   echo

   echo -n -s \
      (__prompt_block l1) " " \
      (__prompt_date) \
      (__prompt_block r1) " " \
      (__prompt_dir_stack) (__prompt_cwd) " " (__prompt_vcs)

   echo

   echo -n \
      (__prompt_block l3) \
      $__prompt_block_host \
      (__prompt_block r3) \
      (__prompt_status $last_status) \
      (__prompt_arrow) \
      ""

end

function __prompt_set_block_host --description "Set the host area of the prompt"

   # TODO: This length should be global: if the host block is longer than the
   # date block, the date block should be padded.
   # - means the host block must be set before the date block
   # - in case I change the contents of the date block, this function should
   #   have an event trigger to correct itself to the actual length
   set -l len_date 15

   # Get the length - in visible characters - of symbols in the block
   # Can't use the result of __prompt_host, etc., as colours are several bytes
   # long
   set -l len_shlvl 0
   if test -z $TMUX -a $SHLVL -gt 1 -o $SHLVL -gt 2
      set len_shlvl (echo -n $__prompt_char_shlvl | wc -m)
   end

   set -l len_host (hostname -s | wc -c)
   set -l len_shell (echo -n $__prompt_char_shell[$__prompt_use_utf8] | wc -m)

   set -l len_diff (math "$len_date-$len_shlvl-$len_host-$len_shell")

   echo -n -s (__prompt_shlvl) (__prompt_host)
   for i in (seq $len_diff)
      echo -n " "
   end
   echo -n (__prompt_shell)

end

function __prompt_reset --description "Reset all parts of the prompt"
   __prompt_set_cwd
   set -g __prompt_block_host (__prompt_set_block_host)
end

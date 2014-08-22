touch $__prompt_reload_file

function prompt_timeless --description 'Two-line prompt with host, SHLVL, shell, status, cwd, and vcs info'
   set -l last_status $argv[1]

   echo

   # upper level
   echo -n -s \
      (__prompt_block l1) " " \
      (__prompt_host) " " \
      (__prompt_dir_stack) (__prompt_cwd)

   echo

   # lower level
   echo -n -s \
      (__prompt_block l3) " " \
      (__prompt_status $last_status) \
      (__prompt_shell) " " \
      (__prompt_arrow) " " \

end

function prompt_timeless_right --description 'Put VCS info on the RHS to save space'
   echo -n -s (__prompt_vcs)
end

function __prompt_reset --description "Reset all parts of the prompt"
   __prompt_set_cwd
end

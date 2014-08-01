touch $__prompt_reload_file

# Required argument: status of the last command before the prompt
function __prompt_status --description 'Draw the status of the last command'

   if not test $argv[1] -eq 0
      echo -n -s \
         "(" \
         $__prompt_colour_status \
         $argv[1] \
         $__prompt_colour_normal \
         ")"
   end

end

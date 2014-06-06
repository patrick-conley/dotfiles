touch $__prompt_reload_file

function __prompt_shlvl --description 'Indicate whether there are nested shells'

   # set & draw the shell depth
   if test $SHLVL -gt 1
      echo -ns $__prompt_colour_shlvl \
         $__prompt_char_shlvl \
         $__prompt_colour_normal
   end

end

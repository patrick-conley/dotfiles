touch $__prompt_reload_file

function __prompt_shlvl --description 'Indicate whether there are nested shells'

   # set & draw the shell depth
   if test -z $TMUX -a $SHLVL -gt 1 -o $SHLVL -gt 2
      echo -n -s $__prompt_colour_shlvl \
         $__prompt_char_shlvl \
         $__prompt_colour_normal
   end

end

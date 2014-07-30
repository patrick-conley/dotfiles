touch $__prompt_reload_file

function __prompt_arrow --description 'Draw the prompt arrow'

   # touch the file described by $__prompt_reload_file to get an update when
   # fish reloads its functions. Handy only for debugging prompts
   if test -e $__prompt_reload_file
      echo -n $__prompt_colour_status
      rm -f $__prompt_reload_file
   end

   if test -w $PWD
      echo -n $__prompt_char_arrow[$__prompt_use_utf8]
   else
      echo -n $__prompt_char_arrow_nowrite[$__prompt_utf8]
   end

   echo -n $__prompt_colour_normal

end

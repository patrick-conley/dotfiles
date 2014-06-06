touch $__prompt_reload_file

function __prompt_host --description 'Draw the hostname'

   # Store the host: it can't change, and it's ~3x faster to do this than
   # requery
   if not set -q __prompt_saved_host
      set -g __prompt_saved_host (hostname)
   end

   echo -n -s \
      $__prompt_colour_host \
      $__prompt_saved_host \
      $__prompt_colour_normal

end

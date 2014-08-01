touch $__prompt_reload_file

function __prompt_date --description 'Print the date'

   echo -n -s $__prompt_colour_date (date "+%d %b at %H:%M") $__prompt_colour_normal

end

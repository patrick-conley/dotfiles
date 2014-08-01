touch $__prompt_reload_file

# Argument: block position
function __prompt_block --description 'Does nothing: autoloads the file'
   set position $argv[1]

   echo -n $__prompt_colour_block

   switch $position
      case "l1"
         echo -n $__prompt_char_block_l1[$__prompt_use_utf8]
      case "l2"
         echo -n $__prompt_char_block_l2[$__prompt_use_utf8]
      case "l3"
         echo -n $__prompt_char_block_l3[$__prompt_use_utf8]
      case "r1"
         echo -n $__prompt_char_block_r1[$__prompt_use_utf8]
      case "r2"
         echo -n $__prompt_char_block_r2[$__prompt_use_utf8]
      case "r3"
         echo -n $__prompt_char_block_r3[$__prompt_use_utf8]
   end

   echo -n $__prompt_colour_normal

end

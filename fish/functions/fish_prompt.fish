set -g __prompt_reload_file "/tmp/fish-reload"

set -g prompt_name 'timeless'

touch $__prompt_reload_file

function fish_prompt --description 'Write out the prompt'
   set -l last_status $status

   # Try to use the default first: the time needed to run the test is
   # negligible, while that for eval is large
   if test $prompt_name = "timeless"
      prompt_timeless $last_status
   else
      eval prompt_$prompt_name $last_status
   end
end

function set_prompt --description 'Set the prompt type'
   if test (count $argv) -eq 0
      echo "Prompts available:"
      for name in (ls $HOME/.config/fish/functions/prompt*.fish)
         echo
         set name (echo $name | sed 's/\.fish$//')
         set name (echo $name | sed "s-^.*/--")
         echo -n "   $name:"
         eval $name
         echo
      end
   else
      set -g prompt_name $argv[1]
   end
end

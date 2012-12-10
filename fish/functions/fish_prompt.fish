set -g prompt_name 'timeless'

touch /home/pconley/temp/fish-reload

function fish_prompt --description 'Write out the prompt'
   # Try to use the default first: the time needed to run the test is
   # negligible, while that for eval is large
   if test $prompt_name = "timeless"
      prompt_timeless
   else
      eval prompt_$prompt_name
   end
end

function set_prompt --description 'Set the prompt type'
   if test (count $argv) -eq 0
      echo "Prompts available:"
      for name in (ls $HOME/Documents/projects/2012/dotfiles/fish/functions/prompt*.fish)
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

if not set -q prompt_name
   set -x prompt_name 'timeless'
end

touch $__prompt_reload_file

function fish_right_prompt --description 'Write out the prompt'

   if test $prompt_name = "timeless"
      prompt_timeless_right $last_status
   else if test -f "prompt_$prompt_name""_right"
      eval "prompt_$prompt_name""_right"
   end
end

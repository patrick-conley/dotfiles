touch $__prompt_reload_file

function __prompt_dir_stack --description 'Draw the directory stack from pushd/popd'

   if not set -q __prompt_saved_dirstack
      __prompt_set_dir_stack
   end

   echo -n $__prompt_saved_dirstack
end

function __prompt_set_dir_stack --on-variable PWD --description 'Update directory stack info'

   # 'dirs' returns the stack using "  " as a separator. Convert it to an
   # array. There will be a trailing, empty element
   set -l stack (dirs | sed "s/  /\n/g")

   # NB: popd temporarily leaves a copy of the original directory on the stack.
   # Dunno why.
   if test (count $stack) -gt 2 -a $stack[1] != $stack[2]
      set -g __prompt_saved_dirstack $__prompt_char_pushd[$__prompt_use_utf8]
   else
      set -g __prompt_saved_dirstack ""
   end

end

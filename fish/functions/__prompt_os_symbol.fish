touch $__prompt_reload_file

function __prompt_os_symbol --description 'Display a character for the current system'

   # Store the OS: it can't change, and it's faster to do this than requery
   if not set -q __prompt_saved_os_symbol
      set -l os (uname)

      if test $os = "Linux"
         set -l distro (cat /etc/issue)

         # Ubuntu's the only distro I know a symbol for
         if test (echo $os | grep "Ubuntu")
            set -g __prompt_saved_os_symbol \
               $__prompt_char_ubuntu[$__prompt_use_utf8] $__prompt_char_linux[$__prompt_use_utf8]
         else
            set -g __prompt_saved_os_symbol $__prompt_char_linux[$__prompt_use_utf8]
         end

      else if test $os = "Darwin"
         set -g __prompt_saved_os_symbol $__prompt_char_mac[$__prompt_use_utf8]
      end
   end

   echo -n $__prompt_saved_os_symbol

end

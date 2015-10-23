function svn

   function less
      /usr/bin/env less -XF $argv
   end

   function svn_builtin
      /usr/bin/env svn $argv
   end

   if contains "diff" $argv \
      and not contains "--diff-cmd" $argv

      svn_builtin $argv | less
      return

   else if contains "status" $argv \
      and not contains "-v" $argv \
      and not contains "-q" $argv \
      and not contains "--ignore-externals" $argv

      # Exclude status flags that are always printed for external directories,
      # but include info on modified files
      svn_builtin $argv | grep -v -e "^\s*X" -e "^Performing status" -e '^\s*$' | less
      return

   else
      for i in "status" "log" "blame" "help" "praise" "propget"
         if contains $i $argv

            svn_builtin $argv | less
            return

         end
      end
   end

   svn_builtin $argv
end

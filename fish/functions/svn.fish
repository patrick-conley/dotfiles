function svn

   function l_less
      /usr/bin/env less -XF
   end

   function l_svn
      /usr/bin/env svn $argv
   end

   if contains "diff" $argv \
      and not contains "--diff-cmd" $argv

      l_svn $argv | l_less
      return

   else if contains "status" $argv \
      and not contains "-v" $argv \
      and not contains "-q" $argv \
      and not contains "--ignore-externals" $argv

      # Exclude status flags that are always printed for external directories,
      # but include info on modified files
      l_svn $argv | grep -v -e "^\s*X" -e "^Performing status" -e '^\s*$' | l_less
      return

   else
      for i in "status" "log" "blame" "help" "praise" "propget"
         if contains $i $argv

            l_svn $argv | l_less
            return

         end
      end
   end

   l_svn $argv
end

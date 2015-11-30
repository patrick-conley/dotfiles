function see

   if test (count $argv) -eq 0
      set argv[1] "."
   end

   if test -f $argv[1]
      less $argv
   else
      ls $argv[1]
   end

end


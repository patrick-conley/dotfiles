function see

   if test (count $argv) -ge 1 -a -f $argv[1]
      less $argv
   else
      ls $argv[1]
   end

end


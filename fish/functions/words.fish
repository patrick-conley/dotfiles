function words

   set -l n 4

   if set -q argv[1]
      set n $argv[1]
   end


   cat /usr/share/dict/words | shuf -n $n | tr '\n' ' '
end


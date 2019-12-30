function __git_origin_status --description 'Check the status of this repo relative to its origin: head; behind; diverge'

   # copied from __prompt_git.fish
   switch (__git_status $argv)[1]
      case '* [ahead *, behind *]'
         echo "diverge"
      case '* [*ahead *]'
         echo "ahead"
      case '* [*behind *]'
         echo "behind"
      case '*'
         set -l stat (__git_status)
         echo $git_status
   end

end

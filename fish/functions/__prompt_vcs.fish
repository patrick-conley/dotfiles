touch $__prompt_reload_file

function __prompt_vcs --description 'Draw VCS branch name & status'


   switch "$__prompt_saved_vcs_type"
      case "git"
         __prompt_git

      case "hg"
         __prompt_hg

   end

end

function __git_status

   if test (count $argv) -gt 0
      printf "%s\n" $argv
   else
      git status --short --branch --ignore-submodules --untracked-files=no 2>/dev/null
   end

end

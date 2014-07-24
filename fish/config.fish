if status --is-interactive
   fish_prompt >/dev/null
   __prompt_cwd >/dev/null

   set TERM xterm-256color
end

if status --is-login
   set PATH $HOME/bin $HOME/bin/scripts $PATH
end

function perlmod
   h2xs -AX $argv
end

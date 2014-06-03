touch /tmp/fish-reload

if status --is-interactive
   # Prompts call __prompt_set_cwd only when dir changes: must be set explicitly
   # Draw the prompt first to set global variables
   fish_prompt > /dev/null
   set -g prompt_cwd (__prompt_set_cwd)
end

if status --is-login
   set PATH $HOME/bin $HOME/bin/scripts $PATH
end

function perlmod
   h2xs -AX $argv
end

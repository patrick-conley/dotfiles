# Prompts call this only on changes to CWD: must be set explicitly
set -g prompt_cwd (__prompt_set_cwd)

if status --is-login
   set PATH $HOME/bin/scripts $PATH
end

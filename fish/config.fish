if status --is-interactive
   fish_prompt >/dev/null
   __prompt_cwd >/dev/null

   set TERM xterm-256color
end

if status --is-login
   set PATH \
      $HOME/bin/link \
      $HOME/bin/scripts \
      $PATH
end

# disable copy-on-delete
set FISH_CLIPBOARD_CMD "cat" # https://github.com/fish-shell/fish-shell/issues/772

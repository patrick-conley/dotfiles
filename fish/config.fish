# disable GREP_OPTIONS, which produces a warning
set -x GREP_OPTIONS

if status --is-interactive
   fish_prompt >/dev/null
   __prompt_cwd >/dev/null

   set TERM xterm-256color
end

if status --is-login
   set PATH \
      $HOME/bin \
      $HOME/bin/java-scripts \
      $HOME/bin/scripts \
      $HOME/.local/bin \
      $PATH
end

if command -s lesspipe >/dev/null
   set -x LESSOPEN "| /usr/bin/lesspipe %s"
   set -x LESSCLOSE "/usr/bin/lesspipe %s %s"
end

# disable copy-on-delete
set FISH_CLIPBOARD_CMD "cat" # https://github.com/fish-shell/fish-shell/issues/772

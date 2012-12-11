# 
# Link this file to ~/.zshrc
#

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' max-errors 1
zstyle :compinstall filename '/home/pconley/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

setopt interactive_comments # allow comments in interactive shells
setopt rm_star_silent       # do not query on rm *
setopt hist_ignore_dups     # do not duplicate history entries
setopt auto_param_slash     # add trailing slash when expanding path to a dir

export XDG_CONFIG_HOME=$HOME/.config

export EDITOR="/usr/bin/vim"
WORDCHARS=${WORDCHARS//[\/]} # wordbreak on slashes

path=( $HOME/bin
       $HOME/bin/scripts
       ./scripts # include any scripts in the current folder
       $path
     )

PERL5LIB="$PERL5LIB:$HOME/perl/lib/perl5"
PERL5LIB="$PERL5LIB:$HOME/perl/share/perl"
PERL5LIB="$PERL5LIB:$HOME/perl/lib/perl/5.12.4"
export PERL5LIB

# Set the prompts
autoload -U colors && colors
setopt prompt_subst

ZSH_CONF_ROOT=~/.dotfiles/zsh
source $ZSH_CONF_ROOT/prompt/timeless

source $ZSH_CONF_ROOT/plugin/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Make less more friendly to pdfs
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Functions {{{1
eps2pdf() # epstopdf on multiple files) {{{2
{
   for file in $@
   do
      epstopdf $file
   done
}

catpdf() # concatenate pdfs {{{2
{
   # usage: catpdf in1 in2 in3 out
   gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$@[-1] $@[1,-2]
}

open() # run gnome-open on several input files {{{2
{
   if [[ $# -eq 1 ]]
   then
      gnome-open "$1" 2> /dev/null
   else
      for file in $@
      do
         gnome-open $file 2> /dev/null
      done
   fi
}

greppdf() # run grep on text in pdf files{{{2
{
   for file in $@[2,-1]
   do
      echo "   $file"
      pdftotext $file - | grep $1
   done
}

play() # play a music file from the terminal
{
   file=$( readlink -f $1 )

   if [[ $file =~ ".ogg" ]]
   then
      gst-launch-0.10 playbin uri="file://$file"
   elif [[ $file =~ "mp3" ]]
   then
      mpg123 $file
   else
      echo "No appropriate plugin exists for ${file##*.} files"
   fi

}

# Aliases {{{1

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias la='ls -a'
alias ll='ls -lh'
alias du='du -sh'
alias gcc='gcc -std=c99 -O -Wall'
alias perlmod="h2xs -AX"

# }}}1

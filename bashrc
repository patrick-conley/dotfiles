# .bashrc (config. shared between machines)
# See also ~/.bashrc, ~/.bashrc_local
# Patrick Conley pconley@uvic.ca
# Last modified: 2012 Dec 10

# colourscheme (&tmux) require explicit 256-colour terminal to work
export TERM=xterm-256color

# Set the path
PATH=$PATH:$HOME/bin

# Set the history to not show repeated commands
HISTCONTROL=ignoredups

# Set the editor to use for eg. svn
export EDITOR='/usr/bin/vim'

##############################################################################
#      Commands below here should only be run in an interactive session      #
##############################################################################

[ -z "$PS1" ] && return

# Some useful aliases

# mkcdir {{{1
function mkcdir()
{
   if (( $# == 1 ))
   then
      mkdir $1
      cd $1
   else
      mkdir $@
   fi
}

# rmcdir {{{1
function rmcdir()
{
   if [[ "$1" == "." ]]
   then
      thisDir=$( pwd )
      cd ..
      rmdir $thisDir
   else
      rmdir $@
   fi
}

# epstopdf with multiple files {{{1
if [[ -n "$( alias | grep 'epstopdf' )" ]]; then unalias epstopdf; fi
function eps2pdf()
{
   for file in $@
   do
      epstopdf $file
   done
}
alias epstopdf='eps2pdf'

# cd and writewd {{{1
if [[ -n "$( alias | grep 'cd' )" ]]; then unalias cd; fi
function cd_writepath()
{
   cd "$@"
   writewd
}
# alias cd='cd_writepath'

# ssh with default servers {{{1
if [[ -n "$( alias | grep 'ssh' )" ]]; then unalias ssh; fi
function ssh_defaults()
{
   if [[ "$1" == "uvic" ]]
   then
      ssh "unix.uvic.ca"
   elif [[ "$1" == "juggling" ]]
   then
      ssh "juggling@unix.uvic.ca"
   else
      ssh $@
   fi
}
alias ssh='ssh_defaults'

 # # always always always run unison on Athena before Iris {{{1
 # function unison_iris()
 # {
 #    if [[ "$1" == "iris" ]]
 #    then
 #       unison
 #       unison $@
 #    else
 #       unison $@
 #    fi
 # }
 # alias unison='unison_iris'

# Souped-up du {{{1
function dusort()
{
   du -s $* | sort -nr
}

# }}}1

# Alter the primary prompt {{{1
colour_black="\e[0;30m"
colour_black_bold="\e[1;30m"
colour_red="\e[0;31m"
colour_red_bold="\e[1;31m"
colour_green="\e[0;32m"
colour_green_bold="\e[1;32m"
colour_yellow="\e[0;33m"
colour_yellow_bold="\e[1;33m"
colour_blue="\e[0;34m"
colour_blue_bold="\e[1;34m"
colour_magenta="\e[0;35m"
colour_magenta_bold="\e[1;35m"
colour_cyan="\e[0;36m"
colour_cyan_bold="\e[1;36m"
colour_white="\e[0;37m"
colour_white_bold="\e[1;37m"
colour_normal="\e[0m"

# shell level
shlvl_char=""
if [[ $SHLVL -gt 1 ]]; then
   shlvl_char="+"
fi

# host type
os_char=""
if [[ $(uname) == "Linux" ]]; then
   if [[ $(cat /etc/issue | grep "Ubuntu") ]]; then
      os_char="${os_char}"
   fi
   os_char="${os_char}"
elif [[ $(uname) == "Darwin" ]]; then
   os_char="${os_char}⌘ "
fi

PS1="\n${colour_cyan}⎧ "
PS1="${PS1}${colour_red_bold}\H${colour_normal}${shlvl_char}${os_char}  "
PS1="${PS1}${colour_green}\w\n"
PS1="${PS1}${colour_cyan}⎩${colour_normal} ⚒ ≻ "

# }}}1

# Some useful aliases
if [[ $( uname ) == "Darwin" ]]
then
   alias ls='ls -GF'
elif [[ "$( uname )" == "Linux" ]]
then
   alias ls='ls -F --color'
fi

alias la='ls -a'
alias ll='ls -lh'
alias pwd='pwd -P'
alias cd.='cd $(pwd -P)'
alias bc='bc --mathlib --quiet ~/.bc_functions'
alias du='du -sh'
alias perlmod="h2xs -AX"

#!/usr/bin/bash
function parse_git_branch {
  ref=$(git-symbolic-ref HEAD 2> /dev/null) || return
  echo "("${ref#refs/heads/}")"
}

# Generate a random password
alias randpass="openssl rand -base64 12"

# user@host dir (git-branch)
export PS1='\[\e[0;32m\]\u@\h\[\e[m\] \[\e[1;34m\]\W\[\e[m\]`__git_ps1` \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]'
PS2='> '
PS4='+ '


# Amazingness for the shell
shopt -s cdspell # fix spelling for cd
shopt -s cmdhist # multi-line commands stay multi-line
shopt -s histappend # don't nuke history file
export PROMPT_COMMAND='history -a' # save each line to history in order
shopt -s lithist # multi-line awesomeness
shopt -s checkwinsize #after each command, update LINES and COLUMNS

# History
export HISTIGNORE="&" # Do not save consecutive duplicates
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTCONTROL=ignoreboth

# ANTLR
alias antlr='java org.antlr.Tool'
alias gunit='java org.antlr.gunit.Interp'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Ruby
export RUBY_HOME=/usr/local/Cellar/ruby/1.9.2-p0
export PATH=$PATH:$RUBY_HOME/bin

# Python
export PYTHONSTARTUP=~/.pythonstartup

# LS and directory colors
if [ "$OSTYPE" == 'darwin10.0' ]
then
    alias ls='ls -G'
else
    alias ls='ls --color'
fi

alias less='less -R'
alias more=less
alias tree='tree -C'

# export LS_OPTIONS='--color=auto'
# export CLICOLOR='Yes'
# export LSCOLORS=''
export CLICOLOR=1
# export LSCOLORS=dxfxcxdxbxegedabagacad

# -- Bash completion
source ~/.git-completion.sh
source ~/.django-completion.sh

# -- Grep
if [ "$OSTYPE" != 'msys' ]
then
    # msysgit doesn't understand --color
    alias grep='grep --color=auto'
    export GREP_COLOR=32
fi

# -- OS Specific
export EDITOR=vi
if [[ -e /Applications/TextMate.app ]]; then
    # On OSX, use TextMate
    alias vi="mate"
    export EDITOR="mate -w"
fi
if [[ -d /c/ ]]; then
    # On windows, use gvim
    alias vi="gvim"

    # Fix 'terminal not fully functional' on MSYSGIT
    export TERM=msys
    alias chrome='$HOME/Local\ Settings/Application\ Data/Google/Chrome/Application/chrome.exe'
    export PYTHON_HOME=/c/python
    export GRAILS_HOME=/c/grails
    alias vi=gvim
fi

export PATH=$HOME/bin:$PYTHON_HOME:$GRAILS_HOME/bin:/opt/local/bin:/usr/local/bin:$PATH




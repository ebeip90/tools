#!/usr/bin/bash
function parse_git_branch {
  ref=$(git-symbolic-ref HEAD 2> /dev/null) || return
  echo "("${ref#refs/heads/}")"
}

# Generate a random password
alias randpass="openssl rand -base64 12"

# user@host dir (git-branch)
export PS1='\[\e[0;32m\]\u@\h\[\e[m\] \[\e[1;34m\]\W\[\e[m\]`__git_ps1` \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]'

# Amazingness for the shell
shopt -s cdspell # fix spelling for cd
shopt -s cmdhist # multi-line commands stay multi-line
shopt -s histappend # don't nuke history file
export PROMPT_COMMAND='history -a' # save each line to history in order
shopt -s lithist # multi-line awesomeness

# History
export HISTIGNORE="&" # Do not save consecutive duplicates
export HISTSIZE=10000
export HISTFILESIZE=10000

# ANTLR
alias antlr='java org.antlr.Tool'
alias gunit='java org.antlr.gunit.Interp'

alias ls='ls --color'

# -- Grep
if [ "$OSTYPE" != 'msys' ]
then
    alias grep='grep --color=auto'
    export GREP_COLOR=32
fi

# -- MSYSGIT
if [ "$OSTYPE" == 'msys' ]
then
     # Fix 'terminal not fully functional'
    export TERM=msys
    alias chrome='$HOME/Local\ Settings/Application\ Data/Google/Chrome/Application/chrome.exe'
    export PYTHON_HOME=/c/python
    export GRAILS_HOME=/c/grails
    alias vi=gvim
fi

export PATH=$HOME/bin:$PYTHON_HOME:$GRAILS_HOME/bin:$PATH




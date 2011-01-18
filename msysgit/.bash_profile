function parse_git_branch {
  ref=$(git-symbolic-ref HEAD 2> /dev/null) || return
  echo "("${ref#refs/heads/}")"
}

export GRAILS_HOME=/c/grails

export PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\W\[\e[m\]`__git_ps1` \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]'
alias vi=gvim
alias ls='ls --color'
alias grep='grep --color=always'
alias chrome='$HOME/Local\ Settings/Application\ Data/Google/Chrome/Application/chrome.exe'

export PATH=/c/python:$GRAILS_HOME/bin:$PATH

# -- Fix issue 184 with msysgit 'Terminal not fully functional'
export TERM=msys


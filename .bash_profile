# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH
#source /usr/share/doc/git-1.7.1/contrib/completion/git-completion.bash
#source /usr/share/doc/git-1.8.2.1/contrib/completion/git-prompt.sh
#source /usr/share/doc/git-1.8.2.1/contrib/completion/git-completion.bash
#GIT_PS1_SHOWDIRTYSTATE=true
#export PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\w\[\033[31m\]\[\033[00m\]$ '
PS1="\ndev1:\[\e[32;1m\](\[\e[37;1m\]\u\[\e[32;1m\])-(\[\e[37;1m\]jobs:\j\[\e[32;1m\])-(\[\e[37;1m\]\w\[\e[32;1m\])\n(\[\e[37;1m\]! \!\[\e[32;1m\])-> \[\e[0m\]"

cd /vagrant/develop

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

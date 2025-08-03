alias vim='nvim'
alias find='gfind'
alias sed='gsed'
alias awsp='export AWS_PROFILE=$(sed -n "s/\[\(profile \)\?\|\]//gp" ~/.aws/config | fzf)'
alias ctags="`brew --prefix`/opt/universal-ctags/bin/ctags"
alias ctags-build="ctags -R -f .tags --fields=+ilnKz"
alias ll='eza -la'
alias tailf='tail -f'
alias mkdir='mkdir -p'
alias pp='popd'
alias be="bundle exec"
alias killspring="ps aux | grep spring | grep -v grep | awk '{print $2}' | xargs kill -9"
alias killpuma="ps aux | grep puma | grep -v grep | awk '{print $2}' | xargs kill -9"
alias ff=fzf
alias ffp="fzf --ansi --delimiter : --preview 'bat --color=always {1} --highlight-line {2}'"
alias gw='git worktree'
alias tigs='tig status'
alias tigb='tig blame'
alias lzd='lazydocker'
alias doc='tldr'
alias yz=yazi
alias cm=chezmoi
alias nocolor='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g"'
alias beep='afplay /System/Library/Sounds/Hero.aiff'
alias ghql='code "`ghq root`/`ghq list | fzf`"'

#unalias ctags
#unalias cp
#unalias find
alias vim='nvim'
alias find='gfind'
alias sed='gsed'
alias awsp='export AWS_PROFILE=$(sed -n "s/\[\(profile \)\?\|\]//gp" ~/.aws/config | fzf)'
alias ctags="`brew --prefix`/opt/universal-ctags/bin/ctags"
alias ctags-build="ctags -R -f .tags --fields=+ilnKz"
alias ll='eza -la'
# require zsh plugin = supercrabtree/k
alias tailf='tail -f'
alias mkdir='mkdir -p'
alias pp='popd'
alias be="bundle exec"
alias killspring="ps aux | grep spring | grep -v grep | awk '{print $2}' | xargs kill -9"
alias killpuma="ps aux | grep puma | grep -v grep | awk '{print $2}' | xargs kill -9"
alias ff=fzf
alias ffp="fzf --ansi --delimiter : --preview 'bat --color=always {1} --highlight-line {2}'"
alias h='function hdi(){ howdoi $* -c -n 5; }; hdi'
alias g='git'
alias gw='git worktree'
alias t='tig'
alias tigs='tig status'
alias tb='tig blame'
alias lzd='lazydocker'
alias doc='tldr'
alias yz=yazi
alias cm=chezmoi
alias nocolor='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g"'
alias beep='afplay /System/Library/Sounds/Hero.aiff'
alias codeghq='code "`ghq root`/`ghq list | fzf`"'

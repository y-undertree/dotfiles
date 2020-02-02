export LANG=ja_JP.UTF-8
# goaccess時に指定が必要
#export LANG='en_US-utf-8' 
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/sbin"
export GREP_OPTIONS='--color=always'

# History
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
HOMEBREW_PREFIX=/usr/local/Homebrew/

# Default Editor
export EDITOR='vim'

# node
export NODE_PATH=/usr/local/lib/node_modules

# gnu project
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# postgresql
#export PGDATA=/usr/local/var/postgres
export PGDATA=/usr/local/var/postgresql@9.6
export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/postgresql@9.6/lib"
export CPPFLAGS="-I/usr/local/opt/postgresql@9.6/include"
export PKG_CONFIG_PATH="/usr/local/opt/postgresql@9.6/lib/pkgconfig"

# axel
export PATH="/usr/local/opt/gettext/bin:$PATH"

# github
alias git=hub
export PATH="/usr/local/bin/git:$PATH"

export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"

# anyenv
export RUBY_CONFIGURE_OPTS="--with-readline-dir=$(brew --prefix readline)"
export PATH="$HOME/.anyenv/bin:$PATH"
export ANYENV_ROOT="$HOME/.anyenv"
if [[ "${+commands[anyenv]}" == 1 ]]
then
  #eval "$(anyenv init - zsh)"
  eval "$(env PATH="$ANYENV_ROOT/libexec:$PATH" $ANYENV_ROOT/libexec/anyenv-init - --no-rehash)"
fi

# rust
export PATH="/usr/local/opt/openssl@1.1/bin:$HOME/.cargo/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"

# npm
export PATH=$PATH:`npm bin -g`

autoload -Uz compinit && compinit

# Zplugin
source "$HOME/.zinit/bin/zplugin.zsh"
zcompile ~/.zinit/bin/zplugin.zsh
autoload -Uz _zinit
autoload -Uz cdr 
autoload -Uz add-zsh-hook
autoload -Uz chpwd
autoload -Uz chpwd_recent_dirs

if [[ "${+_comps}" == 1 ]]
then
  _comps[zinit]=_zinit
fi

zinit ice pick''
zinit light 'zsh-users/zsh-completions'

zinit cdreplay -q

zinit ice wait'1' atload'_zsh_highlight'
zinit light 'zdharma/fast-syntax-highlighting'
# コマンドをサジェストするプラグインを遅延ロードします。
zinit ice wait'1' atload'_zsh_autosuggest_start'
zinit light 'zsh-users/zsh-autosuggestions'

zinit ice pick'k.sh'
zinit light 'supercrabtree/k'

zinit light zsh-users/zsh-history-substring-search

zinit light mollifier/anyframe

#zinit light mollifier/cd-gitroot

zinit light willghatch/zsh-cdr
zinit ice pick'init.sh'
zinit light b4b4r07/enhancd

zinit light jcorbin/zsh-git
#zinit load plugins/git
zinit light peterhurford/git-aliases.zsh
#zinit light marzocchi/zsh-notify
zinit ice pick"async.zsh" src"pure.zsh"; zinit light sindresorhus/pure
#zplug "docker/cli", use:"contrib/completion/zsh/_docker"
zinit ice pick'zshrc'
zinit light 'tcnksm/docker-alias'

# notify
#export SYS_NOTIFIER="/usr/local/bin/terminal-notifier"
#export NOTIFY_COMMAND_COMPLETE_TIMEOUT=10
#
#zstyle ':notify:*' error-title "Error"
#zstyle ':notify:*' success-title "Success"
#zstyle ':notify:*' error-sound "Glass"
#zstyle ':notify:*' success-sound "default"
#zstyle ':notify:*' activate-terminal yes
#zstyle ':notify:*' command-complete-timeout 15

# cdr Settings
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/shell/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-pushd true

# bindkey
source "${HOME}/.zsh/rc/20_key-bindings.zsh"
# Alias
source "${HOME}/.zsh/rc/30_aliases.zsh"
# Options
source "${HOME}/.zsh/rc/50_options.zsh"
export PATH="/usr/local/opt/v8@3.15/bin:$PATH"

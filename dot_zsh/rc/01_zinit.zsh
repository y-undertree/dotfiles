ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# vim keybind
# https://github.com/jeffreytse/zsh-vi-mode
# https://github.com/jeffreytse/zsh-vi-mode#custom-escape-key
function zvm_after_lazy_keybindings() {
  # https://github.com/jeffreytse/zsh-vi-mode/blob/cd730cd347dcc0d8ce1697f67714a90f07da26ed/zsh-vi-mode.zsh#L1501-L1517
  zvm_bindkey vicmd 'H' vi-first-non-blank
  zvm_bindkey vicmd 'L' vi-end-of-line
}
export ZVM_VI_ESCAPE_BINDKEY=jj
export ZVM_LINE_INIT_MODE=$ZVM_MODE_LAST
export ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_ZLE
zinit ice lucid depth=1
zinit light jeffreytse/zsh-vi-mode

# zinit config exmpale
# https://zdharma-continuum.github.io/zinit/wiki/GALLERY/

# theme
# https://github.com/romkatv/powerlevel10k#fonts
zinit ice lucid depth=1
zinit light romkatv/powerlevel10k

zinit ice lucid blockf
zinit light zsh-users/zsh-completions

# basic plugin
zinit wait"1" lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
  atload'eval "$(op completion zsh)"; compdef _op op' \
  zdharma-continuum/fast-syntax-highlighting \
  atload"!_zsh_autosuggest_start" \
  zsh-users/zsh-autosuggestions

zinit ice atclone'./init.sh' nocompile'!' wait'!0'
zinit light b4b4r07/enhancd

# zinit ice wait lucid
# zinit load urbainvaes/fzf-marks

zinit ice wait lucid
zinit load hlissner/zsh-autopair

# style
zinit ice wait"0c" lucid reset \
    atclone"local P=${${(M)OSTYPE:#*darwin*}:+g}
            \${P}sed -i \
            '/DIR/c\DIR 38;5;63;1' LS_COLORS; \
            \${P}dircolors -b LS_COLORS > c.zsh" \
    atpull'%atclone' pick"c.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zinit light trapd00r/LS_COLORS

#export ZSH_FZF_HISTORY_SEARCH_BIND='^H'
zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search

zinit ice wait"1" lucid
zinit load zdharma-continuum/zui
#
# history search
zstyle ":history-search-multi-word" page-size "11"
zinit ice wait"1" lucid
zinit load zdharma-continuum/history-search-multi-word

zinit ice lucid pick"h.sh" wait"2"
zinit light paoloantinori/hhighlighter

# jq interactive
zinit ice wait"2" lucid atload'\
  bindkey "^J" jq-complete'
zinit light reegnz/jq-zsh-plugin

# docker aliasesa
# https://github.com/akarzim/zsh-docker-aliases
zinit ice wait"2" lucid
zinit light akarzim/zsh-docker-aliases

# https://github.com/mdumitru/git-aliases
zinit ice wait"2" lucid
zinit light mdumitru/git-aliases

# https://github.com/empresslabs/pnpm.plugin.zsh
zinit ice wait"2" lucid
zinit light empresslabs/pnpm.plugin.zsh

zinit ice wait"2" lucid
zinit light djui/alias-tips

zinit ice wait'[[ -n ${ZLAST_COMMANDS[(r)cra*]} ]]' lucid
zinit load zdharma-continuum/zinit-crasis

<a href="https://dotfyle.com/y-undertree/dotfiles-dotconfig-nvim"><img src="https://dotfyle.com/y-undertree/dotfiles-dotconfig-nvim/badges/plugins?style=for-the-badge" /></a>
<a href="https://dotfyle.com/y-undertree/dotfiles-dotconfig-nvim"><img src="https://dotfyle.com/y-undertree/dotfiles-dotconfig-nvim/badges/leaderkey?style=for-the-badge" /></a>
<a href="https://dotfyle.com/y-undertree/dotfiles-dotconfig-nvim"><img src="https://dotfyle.com/y-undertree/dotfiles-dotconfig-nvim/badges/plugin-manager?style=for-the-badge" /></a>

# README

個人の趣味で管理しているdotfileです。

本ソフトウェアは、「現状有姿」で提供され、商品性、特定目的への適合性、及び非侵害に関する黙示的な保証を含む、いかなる明示的または黙示的な保証も伴わないものとします。作者または著作権者は、本ソフトウェアの使用によって生じうる直接的、間接的、偶発的、特別、懲罰的、または結果的損害（データの損失、ビジネスの中断、業務の実行権利の喪失などを含むがこれに限られない）に対して、いかなる責任も負わないものとします。

## about

- dotfileは、chezmoiで管理する
- command は HomeBrew で管理する
- shell、terminal 系は zinit で管理する
- terminal: Alactitty
- tmuxを使う

## update

```sh
zinit self-update
zinit update

brew update
brew upgrade

vim
:NvChadUpdate
:Lazy update
```

## color scheme

https://draculatheme.com/

## tips

- tmuxでは、Shiftを押せばAlacrittyのMouse操作できる（Shift + clickでURLを開くなど）
- vimで`cnoremap`は基本使わない. 変な動作になるのと検索などが邪魔されるので
    - `n`など連打するようなキーは、キーの入力待ちになって動作が遅くなるので設定しないこと

## color

**True Color**

https://gist.github.com/bbqtd/a4ac060d6f6b9ea6fe3aabe735aa9d95
https://www.pandanoir.info/entry/2019/11/02/202146

```sh
# tigのcolorが動作しないので、screen-256color or xterm-256color にする必要がある
set -g default-terminal "xterm-256color"
set -ag terminal-overrides ",alacritty:RGB"
```

## vim

core plugin = [NvChad](https://nvchad.com/)

### require

- https://github.com/daipeihust/im-select
  - うまくインストールできない場合は、直接 Github から取得する
  - https://github.com/daipeihust/im-select/blob/master/macOS/out/intel/im-select

```sh
if [ -e /usr/local/bin/im-select ]
then
  rm -f /usr/local/bin/im-select
fi

mv ~/Downloads/im-select /usr/local/bin/im-select

chmod +x /usr/local/bin/im-select
```

```sh
# nnn plugin
curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh
```

### eslint

```sh
npm i -g vscode-langservers-extracted
# masonでinstallできない場合など
npm i -g cspell

# bundle execできればよいが...
gem install reek --no-doc
gem install solargraph --no-doc
gem install rubocop --no-doc
gem install rubocop-rails --no-doc
gem install rubocop-capybara --no-doc
gem install rubocop-erb --no-doc
gem install rubocop-migration --no-doc
gem install rubocop-performance --no-doc
gem install rubocop-rspec --no-doc
gem install sevencop --no-doc
```

### git commit error vim editor

```sh
# error message at git commit close(keybind:ZZ)
hint: Waiting for your editor to close the file... error: There was a problem with the editor 'nvim'
```

```sh
which nvim
git config --global core.editor "which output command path"
```

### git mergetool

sublime mergeを使う. sublime mergeのcliの準備をしておく必要がある

https://www.sublimemerge.com/docs/command_line

## chezmoi

ref: https://www.chezmoi.io/user-guide/command-overview/
reference: https://www.chezmoi.io/reference/commands

### about

- `re-add` で管理しているファイルをすべて追加する
- `apply -v` でローカルファイルに反映する 
    - `-n` でdry-run
- `update` でまとめて反映まで可能


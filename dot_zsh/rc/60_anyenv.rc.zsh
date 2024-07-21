source "/Users/kinoshityasunori/.anyenv/libexec/../completions/anyenv.zsh"
anyenv() {
  typeset command
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi
  command anyenv "$command" "$@"
}
export GOENV_ROOT="/Users/kinoshityasunori/.anyenv/envs/goenv"
export PATH="/Users/kinoshityasunori/.anyenv/envs/goenv/bin:$PATH"
export GOENV_SHELL=zsh
export GOENV_ROOT=/Users/kinoshityasunori/.anyenv/envs/goenv
if [ "${PATH#*$GOENV_ROOT/shims}" = "${PATH}" ]; then
  export PATH="$PATH:$GOENV_ROOT/shims"
fi
source '/Users/kinoshityasunori/.anyenv/envs/goenv/libexec/../completions/goenv.zsh'
goenv() {
  local command
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(goenv "sh-$command" "$@")";;
  *)
    command goenv "$command" "$@";;
  esac
}
goenv rehash --only-manage-paths
export NODENV_ROOT="/Users/kinoshityasunori/.anyenv/envs/nodenv"
export PATH="/Users/kinoshityasunori/.anyenv/envs/nodenv/bin:$PATH"
export PATH="/Users/kinoshityasunori/.anyenv/envs/nodenv/shims:${PATH}"
export NODENV_SHELL=zsh
source '/Users/kinoshityasunori/.anyenv/envs/nodenv/libexec/../completions/nodenv.zsh'
nodenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(nodenv "sh-$command" "$@")";;
  *)
    command nodenv "$command" "$@";;
  esac
}
export PHPENV_ROOT="/Users/kinoshityasunori/.anyenv/envs/phpenv"
export PATH="/Users/kinoshityasunori/.anyenv/envs/phpenv/bin:$PATH"
export PATH="/Users/kinoshityasunori/.anyenv/envs/phpenv/shims:${PATH}"
source "/Users/kinoshityasunori/.anyenv/envs/phpenv/libexec/../completions/phpenv.zsh"
phpenv() {
  local command
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  shell)
    eval `phpenv "sh-$command" "$@"`;;
  *)
    command phpenv "$command" "$@";;
  esac
}
export PYENV_ROOT="/Users/kinoshityasunori/.anyenv/envs/pyenv"
export PATH="/Users/kinoshityasunori/.anyenv/envs/pyenv/bin:$PATH"
PATH="$(bash --norc -ec 'IFS=:; paths=($PATH); 
for i in ${!paths[@]}; do 
if [[ ${paths[i]} == "''/Users/kinoshityasunori/.anyenv/envs/pyenv/shims''" ]]; then unset '\''paths[i]'\''; 
fi; done; 
echo "${paths[*]}"')"
export PATH="/Users/kinoshityasunori/.anyenv/envs/pyenv/shims:${PATH}"
export PYENV_SHELL=zsh
source '/Users/kinoshityasunori/.anyenv/envs/pyenv/libexec/../completions/pyenv.zsh'
pyenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(pyenv "sh-$command" "$@")"
    ;;
  *)
    command pyenv "$command" "$@"
    ;;
  esac
}
export RBENV_ROOT="/Users/kinoshityasunori/.anyenv/envs/rbenv"
export PATH="/Users/kinoshityasunori/.anyenv/envs/rbenv/bin:$PATH"
export PATH="/Users/kinoshityasunori/.anyenv/envs/rbenv/shims:${PATH}"
export RBENV_SHELL=zsh
source '/Users/kinoshityasunori/.anyenv/envs/rbenv/completions/rbenv.zsh'
rbenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(rbenv "sh-$command" "$@")";;
  *)
    command rbenv "$command" "$@";;
  esac
}

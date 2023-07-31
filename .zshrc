HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=999999999
SAVEHIST=$HISTSIZE

autoload -Uz compinit && compinit

export AWS_PROFILE=486329218230_Platforma-Editor
export PATH=$HOME/Library/Python/3.9/bin:$PATH
export PV_PLATFORMA_HOME=/Volumes/workspace/platforma

bindkey -e
# bindkey '^r' history-incremental-search-backward
# bindkey "^P" up-line-or-search
# bindkey "^N" down-line-or-search

# stuff i need to do every time i open a new terminal instance
# so that nvm is found in that terminal instance
export NVM_DIR="$HOME/.nvm"
. $NVM_DIR/nvm.sh

alias ppdev="/Volumes/workspace/projectplace/main_service/localenv/bin/ppdev"
# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export CLICOLOR=1

export PATH=$PATH:/Volumes/workspace/projectplace/main_service/localenv/bin
[[ -d /Applications/WezTerm.app/Contents/MacOS ]] && export PATH="/Applications/WezTerm.app/Contents/MacOS:$PATH"

# openssl
export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include"

eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"

autoload -U add-zsh-hook
load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use
  elif [[ $(nvm version) != $(nvm version default)  ]]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

HISTFILE=$ZDOTDIR/.zsh_history
HISTSIZE=999999999
SAVEHIST=$HISTSIZE

autoload -Uz compinit && compinit

export AWS_PROFILE=486329218230_Platforma-Editor
export MAUDE_CACHE_DIR=$HOME/code/pms/cache
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/Users/mukeshsoni/Library/Python/3.9/bin:$PATH"
export PATH="/usr/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
alias python=python3


bindkey -e
# bindkey '^r' history-incremental-search-backward
# bindkey "^P" up-line-or-search
# bindkey "^N" down-line-or-search

# stuff i need to do every time i open a new terminal instance
# so that nvm is found in that terminal instance
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

alias ls=lsd
alias p=pnpm
alias sqlite3="/opt/homebrew/opt/sqlite/bin/sqlite3"

export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export CLICOLOR=1

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

# pnpm
export PNPM_HOME="$HOME/.config/local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

autoload bashcompinit
bashcompinit

autoload -U colors && colors

autoload -Uz compinit 
# initialize auto completion. We use -i to tell compinit to not worry about
# insecure directories. Solution from this github issue -
# https://github.com/zsh-users/zsh-completions/issues/680#issuecomment-647037301
if [ "$(whoami)" = "msoni" ]; then
	compinit -i # Ignore insecure directories
else
	compinit
fi
zmodload -i zsh/complist

alias gst='git status'
alias gpr='git pull --rebase'
alias gps='git push'
alias gl='git log'
alias git=hub

# If i don't do the fasd init, fasd_cd is not registered as a command
eval "$(fasd --init auto)"
# alias j to fasd_cd. Now we can jump directory with j command
alias j='fasd_cd -d' # z is an alias set by fasd to 'fasd_cd -d', i.e. jump to directory

# history will not record duplicates. which makes going through command history faster
export HISTCONTROL=ignoreboth:erasedups
export PATH=$PATH:~/.projectplace/bin

PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%F{50}%2~%f%b %# '

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
# PROMPT=\$vcs_info_msg_0_'%# '
zstyle ':vcs_info:git:*' formats '%F{30}(%b)%r%f'
zstyle ':vcs_info:*' enable git

TERM=xterm-256color
export BAT_THEME="Dracula"
alias config='/usr/bin/git --git-dir=/Users/msoni/.myconfig/ --work-tree=/Users/msoni'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

[[ -s "/Users/msoni/.projectplace/bin/pptool-init.sh" ]] && source "/Users/msoni/.projectplace/bin/pptool-init.sh"

# control-b to move back a word on command line
bindkey "^b" backward-word
# control-f to move forward a word on command line
bindkey "^f" forward-word

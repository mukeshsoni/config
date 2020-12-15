autoload -U colors && colors

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

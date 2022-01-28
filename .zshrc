# If you don't know or are confused about any of the functions being invoked below
# E.g. autoload, zmodload etc., either use `man zshbuiltins` or look for them here 
# https://linux.die.net/man/1/zshbuiltins
# Googling is not the most efficient way to find about them. I found it the hard way.
autoload bashcompinit
bashcompinit

# This one i have no idea about
# TODO: research about TERM
TERM=xterm-256color

# -U prevents alias expansion of the autoloadable function
# -z probably makes native zsh load the function. I don't know what that means.
# https://stackoverflow.com/questions/12570749/zsh-completion-difference
# autoload itself brings a functions into the zsh landscape. Only after you call
# autoload functionName, can you invoke it
# colors is a functions which sets up some helpful aliases for some common colors
autoload -Uz colors && colors

autoload -Uz compinit 
# initialize auto completion. We use -i to tell compinit to not worry about
# insecure directories. Solution from this github issue -
# https://github.com/zsh-users/zsh-completions/issues/680#issuecomment-647037301
if [ "$(whoami)" = "msoni" ]; then
	compinit -i # Ignore insecure directories
else
	compinit
fi
# zmodload loads a module
# If we try zmodload on the terminal without arguments, it will show the list of all currently loaded binary modules
# What does the module zsh/complist do?
# More details here - http://info2html.sourceforge.net/cgi-bin/info2html-demo/info2html?(zsh)The%2520zsh%2Fcomplist%2520Module
zmodload -i zsh/complist

# history will not record duplicates. which makes going through command history faster
export HISTCONTROL=ignoreboth:erasedups

# aliases
alias gst='git status'
alias gpr='git pull --rebase'
alias gps='git push'
alias gl='git log'
alias git=hub
# Specially to maintain my dotfiles and config files in a git repo
alias config='/usr/bin/git --git-dir=/Users/msoni/.myconfig/ --work-tree=/Users/msoni'

# If i don't do the fasd init, fasd_cd is not registered as a command
eval "$(fasd --init auto)"
# alias j to fasd_cd. Now we can jump directory with j command
alias j='fasd_cd -d' # z is an alias set by fasd to 'fasd_cd -d', i.e. jump to directory

# using exa for listing files instead of inbuilt ls
alias l='exa'
alias la='exa -a'
alias ll='exa -lah'
alias ls='exa --color=auto'

export PATH=$PATH:$HOME/.cargo/bin
# Add projectplace tools to path
export PATH=$PATH:~/.projectplace/bin
[[ -s "/Users/msoni/.projectplace/bin/pptool-init.sh" ]] && source "/Users/msoni/.projectplace/bin/pptool-init.sh"

# very simple prompt. We will zazz it up with a right hand section somewhere below.
# PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%F{50}%2~%f%b %# '
# Let add a right hand section to the prompt. With some git information.
# RPROMPT is the variable which shows up as the right hand section in the prompt.
# autoload -Uz vcs_info
# precmd_vcs_info() { vcs_info }
# precmd_functions+=( precmd_vcs_info )
# setopt prompt_subst
# RPROMPT=\$vcs_info_msg_0_
# PROMPT=\$vcs_info_msg_0_'%# '
# zstyle ':vcs_info:git:*' formats '%F{30}(%b)%r%f'
# zstyle ':vcs_info:*' enable git

# nice but fast prompt - https://github.com/sindresorhus/pure#getting-started
# This will only work if we have sindresorhus/pure installed globally
autoload -U promptinit; promptinit
prompt pure

# specially for the bat command. It's an alternate to cat command to view contents of a file. 
# bat can display the files with syntax highlighting and all. Which is why we are setting a 
# theme so that we see the contents in our favorite color scheme
export BAT_THEME="Dracula"

# add awesomeness to filtering file search lists or reverse command search lists
# One thing to understsand is that fzf itself doesn't do the file search or the
# reverse command search. It gives us an interface to navigate the lists returned by
# other commands or programs like ripgrep for file search or cmd+r for reverse command search.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

# key bindings
# control-b to move back a word on command line
bindkey "^b" backward-word
# control-f to move forward a word on command line
bindkey "^f" forward-word

# use bat to see git diffs
batdiff() {
    git diff --name-only --diff-filter=d | xargs bat --diff
}


export DATABASE_URL=postgres://postgres:postgrespwd@localhost:5432/postgres

# much better ctrl-r experience. They call it neural net for your shell history.
eval "$(mcfly init zsh)"

### PPDEV INSTALLED - read init script
[[ -s "/Volumes/code-case-sensitive/code/main_service/localenv/ppdev-bash-init.sh" ]] && source "/Volumes/code-case-sensitive/code/main_service/localenv/ppdev-bash-init.sh"

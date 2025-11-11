# .bashrc
# Executed for interactive non-login shells

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ============================================
# ENVIRONMENT VARIABLES
# ============================================

# Editor
export EDITOR="nvim"
export VISUAL="nvim"

# History
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend

# Better bash behavior
shopt -s checkwinsize  # Update window size after each command
shopt -s cdspell       # Autocorrect typos in path names when using cd
shopt -s nocaseglob    # Case-insensitive globbing

# Color support
export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd

# ============================================
# PROMPT
# ============================================

# Git prompt function
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Set up prompt with git branch
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]$(parse_git_branch)\[\033[00m\]\$ '

# ============================================
# ALIASES
# ============================================

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# List files
alias ls='ls -G'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias lg='lazygit'

# System
alias c='clear'
alias h='history'
alias please='sudo'
alias restart='sudo shutdown -r now'

# Development
alias nv='nvim'
alias vim='nvim'
alias vi='nvim'

# Tmux
alias t='tmux'
alias ta='tmux attach'
alias tls='tmux ls'
alias tn='tmux new -s'

# Quick edits
alias bashrc='nvim ~/.bashrc'
alias vimrc='nvim ~/.config/nvim/init.lua'
alias tmuxconf='nvim ~/.tmux.conf'

# Network
alias myip='curl ifconfig.me'
alias ports='lsof -i -P -n | grep LISTEN'

# Node/npm
alias ni='npm install'
alias nid='npm install --save-dev'
alias ns='npm start'
alias nt='npm test'
alias nr='npm run'

# ============================================
# FUNCTIONS
# ============================================

# Create and enter directory
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract archives
extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Find file by name
ff() {
    find . -type f -iname "*$1*"
}

# Find directory by name
fd() {
    find . -type d -iname "*$1*"
}

# Quick git commit
qc() {
    git add .
    git commit -m "$1"
}

# ============================================
# NODE VERSION MANAGER (NVM)
# ============================================

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# ============================================
# BASH COMPLETION
# ============================================

if [ -f /opt/homebrew/etc/bash_completion ]; then
    . /opt/homebrew/etc/bash_completion
fi

# ============================================
# FZF (Fuzzy Finder)
# ============================================

if command -v fzf &> /dev/null; then
    # Setup fzf key bindings and completion
    eval "$(fzf --bash)"

    # Use fd for fzf if available
    if command -v fd &> /dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi
fi

# ============================================
# ADDITIONAL TOOLS
# ============================================

# GitHub CLI completion
if command -v gh &> /dev/null; then
    eval "$(gh completion -s bash)"
fi

# ============================================
# LOCAL CUSTOMIZATIONS
# ============================================

# Source local bashrc if it exists (for machine-specific config)
if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi

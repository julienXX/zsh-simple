############
# FUNCTIONS
############

# mkdir & cd to it
function mcd() {
    mkdir -p "$1" && cd "$1";
}

# remove results from a find
function findrm() {
    find . -iname "$1" -exec rm -r {} \;
}

#########
# COLORS
#########

autoload -U colors
colors
setopt prompt_subst

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"

# Text to display if the branch is dirty
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} *%{$reset_color%}"

# Text to display if the branch is clean
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[cyan]%}"

#########
# PROMPT
#########
export PS1=$'
%{$fg[blue]%}∴ %d%{$fg[yellow]%}$(~/bin/git-cwd-info)
%{$fg[blue]%}λ %{$reset_color%}'

_lineup=$'\e[1A'
_linedown=$'\e[1B'
RPROMPT=%{${_lineup}%}%{$fg[magenta]%}[%*]%{${_linedown}%}%{$reset_color%}

#############
# COMPLETION
#############

# Show completion on first TAB
setopt menucomplete

# enable cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# ignore completion to commands we don't have
zstyle ':completion:*:functions' ignored-patterns '_*'

# format autocompletion style
zstyle ':completion:*:descriptions' format "%{$fg_bold[green]%}%d%{$reset_color%}"
zstyle ':completion:*:corrections' format "%{$fg_bold[yellow]%}%d%{$reset_color%}"
zstyle ':completion:*:messages' format "%{$fg_bold[red]%}%d%{$reset_color%}"
zstyle ':completion:*:warnings' format "%{$fg_bold[red]%}%d%{$reset_color%}"

# zstyle show completion menu if 2 or more items to select
zstyle ':completion:*'                        menu select=2

# zstyle kill menu
zstyle ':completion:*:*:kill:*'               menu yes select
zstyle ':completion:*:kill:*'                 force-list always
zstyle ':completion:*:*:kill:*:processes'     list-colors "=(#b) #([0-9]#)*=36=31"

# enable color completion
zstyle ':completion:*:default' list-colors "=(#b) #([0-9]#)*=$color[yellow]=$color[red]"

# fuzzy matching of completions for when we mistype them
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only

# number of errors allowed by _approximate increase with the length of what we have typed so far
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# up and down arrows do history search
autoload -U history-search-end

zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey "\e[A" history-beginning-search-backward-end
bindkey "\e[B" history-beginning-search-forward-end

##########
# ALIASES
##########

alias ls='ls -G'
alias ll='ls -lG'
alias duh='du -csh'

# Git aliases
alias glog="git log -p -40 | vim - -R -c 'set foldmethod=syntax'"

# Bundler
alias be="bundle exec"
alias bi="bundle install"

alias psgrep="ps aux | grep "
alias hb="hub browse"
alias internet="ping 8.8.8.8"
alias please='sudo $(fc -ln 0)'

alias kfr="setxkbmap -layout fr -option ctrl:nocaps -option compose:ralt"
alias kus="setxkbmap -layout us -option ctrl:nocaps -option compose:ralt"

alias vpn="cd /home/julien/config/Jblanchard@50.200.182.250 && sudo openvpn Jblanchard@50.200.182.250.ovpn && cd -"
alias ssh_content_staging="cd /home/julien/Code/content/rails && /home/julien/Code/sm-terraform/infra/staging/assume_staging_admin.sh eb ssh content-worker-staging && cd -"
alias ssh_content_web_staging="cd /home/julien/Code/content/rails && /home/julien/Code/sm-terraform/infra/staging/assume_staging_admin.sh eb ssh content-web-staging && cd -"
alias ssh_platform_staging="cd /home/julien/Code/platform/rails && /home/julien/Code/sm-terraform/infra/staging/assume_staging_admin.sh eb ssh platform-worker-staging && cd -"
alias ssh_platform_web_staging="cd /home/julien/Code/platform/rails && /home/julien/Code/sm-terraform/infra/staging/assume_staging_admin.sh eb ssh platform-web-staging && cd -"
alias ssh_content_production="cd /home/julien/Code/content/rails && /home/julien/Code/sm-terraform/infra/production/assume_production_admin.sh eb ssh content-worker-production && cd -"
alias ssh_content_web_production="cd /home/julien/Code/content/rails && /home/julien/Code/sm-terraform/infra/production/assume_production_admin.sh eb ssh content-web-production && cd -"
alias ssh_platform_production="cd /home/julien/Code/platform/rails && /home/julien/Code/sm-terraform/infra/production/assume_production_admin.sh eb ssh platform-worker-production && cd -"
alias ssh_platform_web_production="cd /home/julien/Code/platform/rails && /home/julien/Code/sm-terraform/infra/production/assume_production_admin.sh eb ssh platform-web-production && cd -"

alias docker_clean="sudo docker system prune --all --filter until=$(date -d "1 month ago" +%s)"

#######
# PATH
#######

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/home/julien/bin:/usr/local/share/npm/bin:/usr/local/share/npm/lib/node_modules:/home/julien/.cask/bin:/home/julien/.cabal/bin:/home/julien/.local/bin:$PATH

#######
# MISC
#######

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.history

export EDITOR=/usr/bin/vim
export SHELL=/usr/bin/zsh

# Bundler
export USE_BUNDLER=force

# Emacs mode
bindkey -e

# Stack binaries
export PATH="$HOME/.local/bin:$PATH"

# Rustup
export PATH="$HOME/.cargo/bin:$PATH"

# Racer
export RUST_SRC_PATH="/home/julien/Code/rust/src"

# Autojump
. /usr/share/autojump/autojump.sh

# RBEnv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Elixir
export ERL_AFLAGS="-kernel shell_history enabled"

# AWS
export AWS_BUCKET_NAME="sm-dev-temp"
export AWS_REGION="eu-west-1"

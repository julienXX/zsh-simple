############
# FUNCTIONS
############

# mkdir & cd to it
function mcd() {
  mkdir -p "$1" && cd "$1";
}

# Emacs
function e() {
  open -a Emacs.app "$1"
}

# Git
function g() {
  REAL_GIT=$(which git)
  BRANCH=$($REAL_GIT branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1/")

  # If there is more than one parameter, proceed with normal git
  if [ $# -gt 0 ]
  then
      $REAL_GIT $@
      return
  fi

  # Check if the only argument is "push" or "pull"
  if [ $1 ]
  then
    if [ $1 == "pull" ]
    then
      $REAL_GIT pull --rebase origin $BRANCH
    elif [ $1 == "push" ]
    then
      $REAL_GIT push origin $BRANCH
    else
      $REAL_GIT
    fi
  else
    $REAL_GIT
  fi
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
%{\e[0;34m%}∴ %{\e[0;34m%}%d%{\e[0m%}$(~/bin/git-cwd-info)
%{$fg[blue]%}λ%{$reset_color%} '

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

##########
# ALIASES
##########

alias ls='ls -G'
alias ll='ls -lG'
alias duh='du -csh'

# Git aliases
alias gplod="git pull origin development"
alias gplom="git pull origin master"
alias gpsod="git push origin development"
alias gpsom="git push origin master"
alias glog="git log -p -40 | vim - -R -c 'set foldmethod=syntax'"

# Bundler
alias be="bundle exec"
alias bi="bundle install"

#######
# PATH
#######

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/Users/julien/bin:/Users/julien/.rbenv/bin:$PATH

#######
# MISC
#######

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.history

export EDITOR=/usr/local/bin/vim
export SHELL=/usr/local/bin/zsh

# Bundler
export USE_BUNDLER=force

# Emacs mode
bindkey -e

# Autojump
if [ -f `brew --prefix`/etc/autojump ]; then
  . `brew --prefix`/etc/autojump
fi

# RBenv
eval "$(rbenv init -)"

source "`brew --prefix grc`/etc/grc.bashrc"

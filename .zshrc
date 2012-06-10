# DESCRIPTION:
#   A simple zsh configuration that gives you 90% of the useful features that I use everyday.
#
# AUTHOR:
#   Geoffrey Grosenbach http://peepcode.com

############
# FUNCTIONS
############

# RVM or rbenv
function ruby_prompt(){
  rv=$(rbenv version-name)
  if (echo $rv &> /dev/null)
  then
    echo "%{$fg_bold[green]%}ruby $rv%{$reset_color%}"
  elif $(which rvm &> /dev/null)
  then
    echo "%{$fg_bold[gray]%}$(rvm tools identifier)%{$reset_color%}"
  else
    echo ""
  fi
}

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
function git_time_since_commit() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    # Only proceed if there is actually a commit.
    if [[ $(git log 2>&1 > /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
      # Get the last commit.
      last_commit=`git log --pretty=format:'%at' -1 2> /dev/null`
      now=`date +%s`
      seconds_since_last_commit=$((now-last_commit))

      # Totals
      MINUTES=$((seconds_since_last_commit / 60))
      HOURS=$((seconds_since_last_commit/3600))

      # Sub-hours and sub-minutes
      DAYS=$((seconds_since_last_commit / 86400))
      SUB_HOURS=$((HOURS % 24))
      SUB_MINUTES=$((MINUTES % 60))

      if [[ -n $(git status -s 2> /dev/null) ]]; then
        if [ "$MINUTES" -gt 30 ]; then
          COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG"
        elif [ "$MINUTES" -gt 10 ]; then
          COLOR="$ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM"
        else
          COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT"
        fi
      else
        COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
      fi

      if [ "$HOURS" -gt 24 ]; then
        echo "($COLOR${DAYS}d${SUB_HOURS}h${SUB_MINUTES}m%{$reset_color%}|"
      elif [ "$MINUTES" -gt 60 ]; then
        echo "($COLOR${HOURS}h${SUB_MINUTES}m%{$reset_color%}|"
      else
        echo "($COLOR${MINUTES}m%{$reset_color%}|"
      fi
    else
      COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
      echo "($COLOR~|"
    fi
  fi
}

function prompt_char {
  git branch >/dev/null 2>/dev/null && echo '[±])' && return
  hg root >/dev/null 2>/dev/null && echo '[☿])' && return
  echo '[○]'
}

# Current path color depending on last command exit status
local current_path="%(?,%{$fg[gray]%}%~%{$reset_color%},%{$fg[red]%}%~%{$reset_color%})"

# mkdir & cd to it
function mcd() {
  mkdir -p "$1" && cd "$1";
}

# Emacs
function e() {
  open -a Emacs.app "$1"
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

PROMPT='
%{$fg[blue]%}${current_path}%{$reset_color%}
%{$fg[gray]%}$(git_time_since_commit)%{$fg[gray]%}$(prompt_char)%{$fg[white]%} ✪  %{$reset_color%}'

RPROMPT='%{$fg[white]%} $(ruby_prompt)$(~/bin/git-cwd-info)%{$reset_color%}'

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
alias vim='/usr/local/bin/vim'

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

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/Users/julien/bin:/Users/julien/.rbenv/bin

#######
# MISC
#######

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.history

export EDITOR=/usr/local/bin/vim
export SHELL=/usr/local/bin/zsh

# VimClojure
export VIMCLOJURE_SERVER_JAR="$HOME/.nailgun/server-2.3.1.jar"

# Bundler
export USE_BUNDLER=force

# Emacs mode
bindkey -e

# Tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

# Autojump
if [ -f `brew --prefix`/etc/autojump ]; then
  . `brew --prefix`/etc/autojump
fi

# RBenv
eval "$(rbenv init -)"

source "`brew --prefix grc`/etc/grc.bashrc"

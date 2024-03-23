# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)

source $ZSH/oh-my-zsh.sh

export PATH="/opt/:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.tmuxifier/bin:$PATH"
export PATH="$HOME/Applications:$PATH"
export PATH=$PATH:/usr/local/go/bin

# export GOPATH=$HOME/xxxxx
# export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH=$PATH:$(go env GOPATH)/bin




# export NABU_TENANT_FOLDER="$ALAYACARE_HOME/nabu/web/api/v1/tenant"
# export VISUAL=lvim
# export EDITOR=lvim


# Aliases
alias zsource="source ~/.zshrc"
alias gpush='git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'
alias dots='cd ~/dotfiles'

alias pullall='for i in */.git; do ( echo $i; cd $i/..; git checkout develop && git pull; ); done'
alias gch='git checkout -b'
alias wip="git add . && git commit -m 'WIP' -n"
alias unwip="git reset HEAD^"

alias cvim='cd ~/.config/nvim/ && nvim .'

alias tn='tmuxifier new-session'
alias tl='tmuxifier load-session'

function fetchd() {
  git stash
  BB=$(git branch | grep "*" | awk '{ print $2 }')
  git checkout develop  
  git pull
  git checkout $BB
  git merge develop
  git stash pop
}

function b36() {
    echo "base 10: $((36#$1))" 
    echo "base 36: $((10#$1))" 
}


function glog(){
    git log --decorate --simplify-by-decoration --oneline | grep -v "(HEAD" | head -n1 sed 's/.* (\(.*\)) .*/\1' sed 's/\(.*\), .*/\1/' sed 's/origin\///'
}

function gbranch {
        if [[ $# -eq 0 ]]
        then
                git --no-pager branch
        elif [[ $# -eq 1 ]]
        then
                git --no-pager branch | grep $1
        elif [[ $2 == '-b' ]]
        then
                git branch | grep $1 | sed -e 's/^[[:space:]]*//' | xargs git checkout
        else
                printf "Usage: gbranch\n       gbranch <ticket number>\n"
        fi
}

alias nvchad="NVIM_APPNAME=nvchad nvim"
alias lazy="NVIM_APPNAME=lazy nvim"
# alias cvim="NVIM_APPNAME=cvim nvim"

function nvims() {
  items=("default" "NvChad")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

# Alaya
[ $USER = "developer1" ] &&
[ -f /home/developer1/dotfiles/.workrc ] && source /home/developer1/dotfiles/.workrc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bindkey -s ^a "nvims\n"
export EDITOR='/usr/bin/nvim'

# nvm use 20.10.0

eval "$(tmuxifier init -)"

fpath+=${ZDOTDIR:-~}/.zsh_functions
eval "$(starship init zsh)"
eval "$(~/.rbenv/bin/rbenv init - zsh)"
# eval "$(rbenv init -)"
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

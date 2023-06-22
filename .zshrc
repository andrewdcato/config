# Set a few defaults to our shell.
export ZSH="$HOME/.oh-my-zsh"
export XDG_CONFIG_HOME="$HOME/.config"
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/config.toml"
export DEFAULT_USER="andrewcato"
export EDITOR="vim"
export PYENV_ROOT="$HOME/.pyenv"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export ANS_DIR="$HOME/surety/ansible"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

eval "$(/opt/homebrew/bin/brew shellenv)"

# Use PyEnv instead of system python
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Hack for running mongodb@3.4 as 'mongo'
export PATH="/opt/homebrew/opt/mongodb-community@4.4/bin:$PATH"
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH="${PATH}:${HOME}/.local/bin/"

export PATH="$HOME/.tmux/plugins/t-smart-tmux-session-manager/bin:$PATH"

# OMZ customization
DISABLE_AUTO_TITLE="false"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

# OMZ TMUX CONFIG
# TODO: get .config dir working for TMUX w/ZSH_TMUX_CONFIG

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  ansible
  brew
  git
  git-flow
  nvm
  tmux
)

# You have to load this *after* declaring plugins or it won't work...odd
source $ZSH/oh-my-zsh.sh

# Custom Aliases
alias bump="./bump.sh"
alias vim="nvim"
alias gpt="git push && git push --tags"
alias gfpub="git flow feature publish \$(git branch | sed -n '/\* feature\//s///p')"
alias szshrc="source ~/.zshrc"
alias zshrc="vim ~/.zshrc"
alias gitClean="git branch --merged | egrep -v \"(^\*|master|main|develop|production)\" | xargs git branch -d"
alias preRelease="gcm; ggpull; gcd; ggpull"

# Handles bare .cfg repo git actions
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"

# Adds & commits
function ac(){
  git add .
  git commit -m "$1"
}

# Add, commit, & push
function acp(){
  git add .
  git commit -m "$1"
  git push
}

# Kill all docker containers with "none" tags
alias dkill="docker rmi $(docker images | grep '^<none>' | awk '{print $3}')"

# Link Ngrok executable
alias ngrok="~/.dotfiles/ngrok/ngrok"

# Ngrok shortcuts
alias nlms='ngrok http -subdomain=sb1-lms 3000'
alias nconnect='ngrok http -hostname=cato-con.ngrok.io 5000'
alias nem='ngrok http -subdomain=sb1-ews 5500'
alias nams='ngrok http -subdomain=sb1-ams 5001'

# Ansible Aliases
alias pingAll="ansible-playbook $ANS_DIR/playbooks/ping.yml"

# Tells you what's listening on a given port
# credit: https://stackoverflow.com/a/30029855/3264790
function listening() {
    if [ $# -eq 0 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P
    elif [ $# -eq 1 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
    else
        echo "Usage: listening [pattern]"
    fi
}

# kill process on given port
function killport() {
  if [ $# -eq 0 ]; then
    echo "Usage: killport PORT_TO_KILL"
    return
  fi
  
  lsof -t -i tcp:$1 | xargs kill
}

# Mongo Aliases
alias mongoProd="mongosh 'mongodb+srv://lms-prod.h69c1.mongodb.net/lms-prod' --username acato"
alias mongoDev="mongosh 'mongodb+srv://lms-dev.msr1d.mongodb.net/lms-dev' --username acato"

# Force NVM to load the specified version of Node
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# Apply the proper rice
source $ZSH/custom/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh

# Load homebrew-managed extensions
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/Cellar/tfenv/3.0.0/versions/1.4.6/terraform terraform

# Path to your oh-my-zsh installation.
export ZSH="/Users/andrewcato/.oh-my-zsh"

eval "$(/opt/homebrew/bin/brew shellenv)"

# Set default user account for themes that recognize this
export DEFAULT_USER="andrewcato"
export EDITOR='vim'

# Load homebrew-managed extensions
source $HOMEBREW_PREFIX/opt/spaceship/spaceship.zsh
source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Use PyEnv instead of system python
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Hack for running mongodb@3.4 as 'mongo'
export PATH="/usr/local/opt/mongodb@4.0/bin:$PATH"
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export PATH="${PATH}:${HOME}/.local/bin/"

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export PATH=$HOME/.tmux/plugins/t-smart-tmux-session-manager/bin:$PATH

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

# Theme Customizations
SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  host          # Hostname section
  dir           # Current directory section
  git           # Git section (git_branch + git_status)
  package       # Package version
  node          # Node.js section
  exec_time     # Execution time
  time          # Time stamps
  battery
  line_sep      # Line break
  char          # Prompt character
)

SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_12HR=true
SPACESHIP_NODE_DEFAULT_VERSION='v14.21.2'
SPACESHIP_BATTERY_SHOW=true
SPACESHIP_BATTERY_THRESHOLD=40
SPACESHIP_EXIT_CODE_SHOW=true
SPACESHIP_PACKAGE_SHOW_PRIVATE=true

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
alias config='/usr/bin/git --git-dir=/Users/andrewcato/.cfg/ --work-tree=/Users/andrewcato'

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
export ANS_DIR="/Users/andrewcato/surety/ansible"
export PROD_INV="$ANS_DIR/inventory/production"
export STAG_INV="$ANS_DIR/inventory/staging"

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

eval "$(zoxide init zsh)"

# source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#eval "$(op completion zsh)"; compdef _op op

# Set Spaceship ZSH as a prompt
#autoload -U promptinit; promptinit
#prompt spaceship

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

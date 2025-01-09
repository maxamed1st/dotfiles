#shell integrations
source /usr/local/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source <(fzf --zsh)
export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

#defaults
export EDITOR=nvim
export VISUAL=nvim
export BROWSER=firefox

# PATH
export PATH=$PATH:~/engineering/bin
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:/applications/firefox.app/contents/macos
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin

### ShORTCUTS ###

#config files
alias cdc="cd ~/.config/"
alias cdl="cd ~/.local/"
alias k="cd ~/.config/kitty/"
alias v="cd ~/.config/nvim/"

#project files
alias eng="cd ~/engineering"
alias dev="cd ~/engineering/devmode/"
alias dot="cd ~/engineering/dotfiles/"
alias re="cd ~/engineering/readmode/"
alias pp="cd ~/engineering/devmode/project-planning/"

#programs
alias nv="nvim"
alias ngh="ngrok http 3000"
alias gs="git status"
alias tw="timew"
alias up="docker compose up"
alias down="docker compose down"
alias compose="docker compose down; docker compose up -d"
alias logs="docker compose logs"

#scripts
alias nrs="npm run start"
alias nrf="npm run serve"
alias nrd="npm run dev"
alias expoc="npx expo start -c"
alias sva="source venv/bin/activate"

#terminal commands
alias c="clear"
alias q="exit"
alias s="source ~/.zshrc"

. "$HOME/.local/bin/env"

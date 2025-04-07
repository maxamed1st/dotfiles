#shell integrations
source /usr/local/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source <(fzf --zsh)
export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

#defaults
export TERM="xterm-256color"
export EDITOR=nvim
export VISUAL=nvim
export BROWSER=firefox

# PATH
export PATH=$PATH:~/engineering/bin
export ANDROID_HOME=$HOME/Library/Android/sdk
export ANDROID_NDK_HOME=$HOME/Library/Android/sdk/ndk/26.1.10909125
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$ANDROID_HOME/platforms:$PATH

export PATH=$PATH:/applications/firefox.app/contents/macos
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin
export PATH=$PATH:/Applications/love.app/Contents/MacOS/

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

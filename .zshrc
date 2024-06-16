#android emulator
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

### ShORTCUTS ###

#config files
alias cdc="cd ~/.config/"
alias cdl="cd ~/.local/"
alias k="cd ~/.config/kitty/"
alias v="cd ~/.config/nvim/"

#project files
alias eng="cd ~/engineering"
alias dev="cd ~/engineering/devmode/"
alias t="cd ~/engineering/devmode/turjum/"
alias tf="cd ~/engineering/devmode/turjum/functions/"
alias p="cd ~/engineering/devmode/pure-binuarals/"
alias w="cd ~/engineering/devmode/walaalka/"
alias dot="cd ~/engineering/dotfiles/"

#programs
alias nv="nvim"
alias ngh="ngrok http 3000"
alias gs="git status"

#scripts
alias nrs="npm run start"
alias nrf="npm run serve"
alias nrd="npm run dev"
alias expoc="npx expo start -c"

#terminal commands
alias c="clear"
alias q="exit"
alias s="source ~/.zshrc"

#shell integrations
source /usr/local/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source <(fzf --zsh)

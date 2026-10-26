alias ls='ls -a'
alias ll='ls -alh'
alias gaa='git add .'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gcb='git checkout -b'
alias cat='bat'
export PATH="/home/rishy/.local/bin:$PATH"
export PATH="/home/rishy/.cargo/bin:$PATH"
export PATH="/opt/nvim/bin:$PATH"
export PATH="/opt/kitty/kitty/launcher:$PATH"
export PATH="/opt/cmake/bin:$PATH"
export PATH="/opt/zig/:$PATH"
export PATH="/opt/jdtls/bin:$PATH"
export PATH="/opt/gradle/bin:$PATH"
export PS1="\u@\h-> "
eval "$(mise activate bash)"
export EDITOR=nvim
eval "$(starship init bash)"
hyprctl dispatch 'hl.dsp.exec_cmd("wayle shell")'
hyprctl dispatch 'hl.dsp.exec_cmd("awww-daemon")'
awww img "$HOME/.backgrounds/bg.png"
clear
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

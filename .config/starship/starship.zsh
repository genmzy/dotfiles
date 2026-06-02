# install starship with apt first
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
eval "$(starship init zsh)"

# scrollback only show line with history command
async_init_transient() {
  starship_zle_line_finish() {
    PROMPT=$(starship module character)
    RPROMPT=""
    zle .reset-prompt
  }
  zle -N zle-line-finish starship_zle_line_finish
}

starship_restore_current() {
  PROMPT="$(starship prompt)"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd async_init_transient
add-zsh-hook precmd starship_restore_current

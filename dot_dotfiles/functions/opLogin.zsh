# ~/.dotfiles/functions/opLogin.zsh

# Login to 1Password CLI
opLogin() {
  eval $(op signin my)
}

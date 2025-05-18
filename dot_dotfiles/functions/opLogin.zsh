# ~/.dotfiles/functions/opLogin.zsh

# Login to 1Password CLI
opLogin () {
    local account=$(op account list --format json | jq -r '.[0].user_uuid')
    eval "$(op signin --account "$account" --raw)"
}

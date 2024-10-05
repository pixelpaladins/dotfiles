# ~/.dotfiles/functions/creds.zsh

# EZ credential grabbing using 1Password CLI
creds() {
    if [ -z "$2" ]; then
        echo "Usage: creds <item/uid> <field>"
        return 1
    fi
    # Fetch the credential using op and echo it
    local cmd="op item get \"$1\" --fields \"$2\" --reveal"
    eval "$cmd"
}

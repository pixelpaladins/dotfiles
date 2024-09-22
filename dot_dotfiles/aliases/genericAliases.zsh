# ~/.dotfiles/aliases/genericAliases.zsh

# Because I hate typing kubectl and kubectl is too long - oc is cooler anyhow
alias kc='kubectl'
# Turns jnv on its head and into a yaml parser
alias ynv='yq -o json | jnv'
# Set context in kubectl (namespace set)
alias ksn='kubectl config set-context --current --namespace'
# Because Terraform is too long, too...
alias tf='terraform'

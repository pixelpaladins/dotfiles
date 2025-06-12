# Initialize completion system
autoload -Uz compinit
compinit

# Load completions dynamically for tools with native Zsh completion
for tool in kubectl gh chezmoi argocd helm
do
  if [[ -x $(command -v $tool) ]]; then
    if $tool completion zsh &>/dev/null; then
      source <($tool completion zsh)
    fi
  fi
done

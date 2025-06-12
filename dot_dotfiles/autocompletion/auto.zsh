# Initialize completion system
fpath=(~/.local/completions $fpath)
autoload -Uz compinit
compinit

# Load completions dynamically for tools with native Zsh completion
for tool in kubectl gh chezmoi argocd helm
do
  if [[ -x $(command -v $tool) ]]; then
    completion_output="$($tool completion zsh 2>/dev/null || true)"
    # Only source if it looks like a Zsh completion (has #compdef)
    if grep -q '^#compdef' <<< "$completion_output"; then
      source <(echo "$completion_output")
    fi
  fi
done

# ~/.dotfiles/exports/kubeContext.zsh

# Kubernetes Context for the Homelab Cluster
# Define the location for the kubeconfig file
KUBECONFIG_PATH="$HOME/.kube/kubeconfig.yaml"

# Check if the kubeconfig file exists
if [[ -f "$KUBECONFIG_PATH" ]]; then
  echo "✅ KUBECONFIG file found at $KUBECONFIG_PATH"
else
  echo "⚠️  KUBECONFIG file not found. Fetching from 1Password..."

  # Check if .kube directory exists, if not create it
  if [[ ! -d "$HOME/.kube" ]]; then
    mkdir -p "$HOME/.kube"
    echo "✅ Created .kube directory at $HOME/.kube"
  fi

  # Use op to fetch the document and write it to the kubeconfig path
  opDoc '3pmmbxpwty7zvxinnvlsujww44' 'kubeconfig.yaml' "$KUBECONFIG_PATH"

  # Set proper permissions for the kubeconfig file
  chmod 600 "$KUBECONFIG_PATH"

  echo "✅ KUBECONFIG file has been downloaded and saved to $KUBECONFIG_PATH"
fi

# Export the kubeconfig file path to the environment
export KUBECONFIG="$KUBECONFIG_PATH"

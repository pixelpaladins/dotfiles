# ~/.dotfiles/exports/kubeContext.zsh

KUBECONFIG_PATH="$HOME/.kube/kubeconfig.yaml"

if [[ -f "$KUBECONFIG_PATH" ]]; then
  echo "✅ KUBECONFIG file found at $KUBECONFIG_PATH"
else
  echo "⚠️  KUBECONFIG file not found. Fetching from 1Password..."

  # Fetch from 1Password
  op document get '3pmmbxpwty7zvxinnvlsujww44' > "$KUBECONFIG_PATH" 2>/dev/null

  # Wait for file to appear (max 5 seconds)
  for i in {1..10}; do
    [[ -f "$KUBECONFIG_PATH" ]] && break
    sleep 0.5
  done

  if [[ -f "$KUBECONFIG_PATH" ]]; then
    chmod 600 "$KUBECONFIG_PATH"
    echo "✅ KUBECONFIG file has been downloaded and saved to $KUBECONFIG_PATH"
  else
    echo "❌ Failed to retrieve KUBECONFIG file from 1Password"
  fi
fi

export KUBECONFIG="$KUBECONFIG_PATH"
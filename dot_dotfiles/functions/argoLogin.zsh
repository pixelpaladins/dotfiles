# ~/.dotfiles/functions/argoLogin.zsh

# ArgoCD login function
# Usage: argoLogin
# Dependencies: argocd, creds
# Output: Login to ArgoCD server
argoLogin() {
  if [[ -z $(command -v argocd) ]]; then
    echo "argocd not found"
    return 1
  fi
  local opi=o77nae5rh26yred43jvsaxn2ba
  export ARGOCD_USERNAME=$(creds $opi 'username')
  export ARGOCD_PASSWORD=$(creds $opi 'password')
  local ARGOCD_SERVER_FL=$(op item get $opi --format json | jq -r '.urls[0].href')
  export ARGOCD_SERVER=$(echo $ARGOCD_SERVER_FL | sed 's/https:\/\///' | sed 's/:443//' | sed 's/\/$//')
  argocd login $ARGOCD_SERVER --username $ARGOCD_USERNAME --password $ARGOCD_PASSWORD --grpc-web
}

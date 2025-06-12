# ~/.dotfiles/functions/ghq.zsh
function ghql() {
  local repo=$(ghq list -p | fzf --height 40% --reverse --prompt="Select repo: ")
  if [[ -n $repo ]]; then
    cd "$repo"
  fi
}
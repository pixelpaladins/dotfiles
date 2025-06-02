# ~/.dotfiles/functions/plex.zsh

# Check current streams on Plex
function plex_streams() {
  local opi='xqz3rnyhd5am2xtjc7eyxsl2mu'
  local rootUrl=$(op item get $opi --format json | jq -r '.urls[0].href')
  local apiKey=$(creds $opi 'apiKey')
  local plexStreams=$(curl -L -s '${rootUrl}/api/v2?apikey='${apiKey}'&cmd=get_activity' | jq -r '.response.data.stream_count')
  # Check if there are any streams
  if [[ $plexStreams -gt 0 ]]; then
    if [[ $plexStreams -eq 1 ]]; then
      echo "There is currently 1 stream on Plex."
    else
      echo "There are currently ${plexStreams} streams on Plex."
    fi
  else
    echo "There are currently no streams on Plex."
  fi
}

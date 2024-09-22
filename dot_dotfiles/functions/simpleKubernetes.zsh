# ~/.dotfiles/functions/simpleKubernetes.zsh

# Cordon a node
lasso() {
  # Check if the node name is provided
  if [ -z "$1" ]; then
    echo "Usage: lasso <node-name>"
    echo "Cordons a node"
    return 1
  fi
  NODE_NAME=$1
  kc cordon $NODE_NAME
}

# Uncordon a node
graze() {
  # Check if the node name is provided
  if [ -z "$1" ]; then
    echo "Usage: graze <node-name>"
    echo "Uncordons a node"
    return 1
  fi
  NODE_NAME=$1
  kc uncordon $NODE_NAME
}

# Drain a node
trench() {
  # Check if the node name is provided
  if [ -z "$1" ]; then
    echo "Usage: trench <node-name>"
    echo "Drains a node"
    return 1
  fi
  NODE_NAME=$1
  kc drain $NODE_NAME --ignore-daemonsets --delete-emptydir-data --force --grace-period=10
}

# Run a command on all nodes
roan() {
  # Check if the command is provided
  if [ -z "$1" ]; then
    echo "Usage: roan <command>"
    echo "Runs a command on all nodes in the cluster"
    return 1
  fi
  NODE_COMMAND=$1
  #Fetch all node IP addresses 
  for ip in $(kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}')
  do
    echo "Running command on $ip"
    ssh root@$ip $NODE_COMMAND
  done
}

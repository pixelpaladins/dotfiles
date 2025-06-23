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

# Runs a temporary Alpine pod with a specified PersistentVolumeClaim (PVC) mounted at /mnt/data.
# Useful for debugging or inspecting the contents of a PVC.
# The pod sleeps for 1 hour, allowing you to exec into it as needed.
# Usage: run_temp_pod_with_pvc <pvc-name>
run_temp_pod_with_pvc() {
  # Check if the PVC name is provided
  if [ -z "$1" ]; then
    echo "Usage: run_temp_pod_with_pvc <pvc-name>"
    echo "Runs a temporary pod with a specified PVC mounted at /mnt/data"
    return 1
  fi
  PVC_NAME=$1
  kubectl run temp-pod --image=alpine --restart=Never --overrides='
{
  "apiVersion": "v1",
  "spec": {
    "containers": [
      {
        "name": "temp-pod",
        "image": "alpine",
        "command": ["sleep", "3600"],
        "volumeMounts": [
          {
            "mountPath": "/mnt/data",
            "name": "data-volume"
          }
        ]
      }
    ],
    "volumes": [
      {
        "name": "data-volume",
        "persistentVolumeClaim": {
          "claimName": "'"$PVC_NAME"'"
        }
      }
    ]
  }
}' -- /bin/sh -c 'while true; do sleep 30; done'
}


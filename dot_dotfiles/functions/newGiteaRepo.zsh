# ~/.dotfiles/functions/newGiteaRepo.zsh

# Create a new repository on Gitea and set up a local corresponding Git repository
function create_repo_and_setup_git() {
    if [ "$#" -ne 3 ]; then
        echo "Usage: create_repo_and_setup_git <repo_name> <description> <private (true/false)>"
        return 1
    fi

    repo_name=$1
    description=$2
    private=$3

    # Get the URL from 1Password
    local opi=dnpf6mebgjootuflw5hb2jeqbe
    local repo_url=$(op item get $opi --format json | jq -r '.urls[].href')

    # Set the credentials
    local username=$(creds $opi 'user_name')
    local password=$(creds $opi 'password')

    # Perform the API call to create the repo and capture the output
    response=$(curl -s -X POST -H "Content-Type: application/json" \
        -u $username:$password \
        -d "{\"name\": \"$repo_name\", \"description\": \"$description\", \"private\": $private}" \
        $repo_url/api/v1/user/repos)

    # Check if the response contains the repo name to confirm success
    if echo "$response" | grep -q "\"name\":\"$repo_name\""; then
        echo "Success! Repository '$repo_name' created."

        # Get the git username
        git_user=$username

        # Switch to home directory
        cd ~/$git_user || exit

        # Create a folder for the repo
        mkdir "$repo_name"
        cd "$repo_name" || exit

        # Initialize Git repository and push the first commit
        touch README.md
        git init
        git checkout -b main
        git add README.md
        git commit -m "first commit"

        # Extract the repository URL without the 'https://' and trailing '/'
        clean_repo_url=$(echo "$repo_url" | sed -e 's#https://##' -e 's#/$##')

        # Add the remote and push the first commit
        git remote add origin "git@$clean_repo_url:$git_user/$repo_name.git"
        git push -u origin main

        echo "Local Git repository initialized and first commit pushed to remote!"
    else
        echo "Error: Failed to create repository."
        echo "$response"  # You can comment this out if you want to fully hide the response in case of failure.
    fi
}

#!/bin/bash

# Load environment variables from .env file if it exists
if [ -f .env ]; then
    echo "Loading environment variables from .env file..."
    # Use export to make variables available to script
    set -a
    # Remove carriage returns when reading the file
    source <(tr -d '\r' < .env)
    set +a
else
    echo "No .env file found. Please create one or enter values manually."
fi

# Clean up any potential carriage returns from variables
FOLDER_PATH=$(echo "$FOLDER_PATH" | tr -d '\r')
GITHUB_TOKEN=$(echo "$GITHUB_TOKEN" | tr -d '\r')
GITHUB_USER=$(echo "$GITHUB_USER" | tr -d '\r')
REPO_NAME=$(echo "$REPO_NAME" | tr -d '\r')

# Now check if variables are set, only prompt if they're empty
if [ -z "$GITHUB_TOKEN" ]; then
    stty -echo
    echo "Enter your GitHub Token: "
    read GITHUB_TOKEN
    stty echo
    echo
fi

if [ -z "$GITHUB_USER" ]; then
    echo "Username: "
    read GITHUB_USER
fi

if [ -z "$REPO_NAME" ]; then
    echo "Repo name: "
    read REPO_NAME
fi

if [ -z "$FOLDER_PATH" ]; then
    echo "Folder path: "
    read FOLDER_PATH
fi

# Clean up path and verify it exists
FOLDER_PATH=$(echo "$FOLDER_PATH" | tr -d '\r')
if [ ! -d "$FOLDER_PATH" ]; then
    echo "Error: Directory $FOLDER_PATH does not exist!"
    exit 1
fi

echo "Creating GitHub repository..."
curl -v -X POST -H "Authorization: token $GITHUB_TOKEN" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Content-Type: application/json" \
     https://api.github.com/user/repos \
     -d "{\"name\":\"$REPO_NAME\", \"private\":false}"

# Initialize and push code
echo "Initializing local repository..."
cd "$FOLDER_PATH" || exit

# Create .gitignore if it doesn't exist
if [ ! -f .gitignore ]; then
    echo "Creating .gitignore..."
    echo "upload.sh" > .gitignore
    echo "upload2.sh" >> .gitignore
    echo ".env" >> .gitignore
fi

git init

# Check if the remote 'origin' already exists
if git remote | grep -q origin; then
    echo "Remote 'origin' already exists. Skipping..."
else
    git remote add origin https://github.com/$GITHUB_USER/$REPO_NAME.git
fi

git remote set-url origin https://$GITHUB_TOKEN@github.com/$GITHUB_USER/$REPO_NAME.git
git add .
git commit -m "Initial commit"
git branch -M main
echo "Pushing to GitHub..."
git push -u origin main

# Clear sensitive environment variables
unset GITHUB_TOKEN
unset GITHUB_USER
unset REPO_NAME
unset FOLDER_PATH
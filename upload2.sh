#!/bin/bash

# Check if environment variables are set, if not prompt for them
if [ -z "$GITHUB_TOKEN" ]; then
    echo "Enter your GitHub Token: "
    read -s GITHUB_TOKEN  # -s flag hides the input
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

echo "Creating GitHub repository..."
curl -X POST -H "Authorization: token $GITHUB_TOKEN" \
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
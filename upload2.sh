#!/bin/bash

GITHUB_USER="ahma2860"
REPO_NAME="ST494_assignment3"
FOLDER_PATH="/mnt/c/Users/Asus/Desktop/STassignment"

# Ask for GitHub token securely (without hardcoding)
read -sp "Enter your GitHub Personal Access Token: " GITHUB_TOKEN
echo ""

# Move to the repository folder
cd "$FOLDER_PATH" || { echo "Folder not found!"; exit 1; }

# Create GitHub Repository
echo "Creating GitHub repository..."
response=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
     -H "Authorization: token $GITHUB_TOKEN" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Content-Type: application/json" \
     https://api.github.com/user/repos \
     -d "{\"name\":\"$REPO_NAME\", \"private\":false}")

if [[ "$response" == "201" ]]; then
    echo "Repository created successfully."
elif [[ "$response" == "422" ]]; then
    echo "Repository already exists. Skipping creation."
else
    echo "Failed to create repository. HTTP response: $response"
    exit 1
fi

# Initialize and push code
echo "Initializing local repository..."
git init

# Set remote URL securely
git remote set-url origin https://$GITHUB_TOKEN@github.com/$GITHUB_USER/$REPO_NAME.git

git add .
git commit -m "Initial commit"
git branch -M main
echo "Pushing to GitHub..."
git push -u origin main

# Remove the stored token for security
unset GITHUB_TOKEN

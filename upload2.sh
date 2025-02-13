#!/bin/bash

GITHUB_USER="ahma2860"
REPO_NAME="ST494_assignment3"
FOLDER_PATH="/mnt/c/Users/Asus/Desktop/STassignment"

# Prompt for GitHub token securely
echo "Enter your GitHub Token: "
read GITHUB_TOKEN

# Move to repo folder
cd "$FOLDER_PATH" || { echo "Folder not found!"; exit 1; }

# Create GitHub repo if it doesn’t exist
echo "Creating GitHub repository..."
response=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
     -H "Authorization: token $GITHUB_TOKEN" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Content-Type: application/json" \
     https://api.github.com/user/repos \
     -d "{\"name\":\"$REPO_NAME\", \"private\":false}")

if [ "$response" = "201" ]; then
    echo "Repository created successfully."
elif [ "$response" = "422" ]; then
    echo "Repository already exists. Skipping creation."
elif [ "$response" = "401" ]; then
    echo "❌ Authentication failed. Check your GitHub token!"
    exit 1
else
    echo "Failed to create repository. HTTP response: $response"
    exit 1
fi

# Initialize and push code
echo "Initializing local repository..."
git init
git remote set-url origin https://github.com/$GITHUB_USER/$REPO_NAME.git

git add .
git commit -m "Initial commit"
echo "Pushing to GitHub..."
git push -u origin main

# Clear token for security
unset GITHUB_TOKEN

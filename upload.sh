#!/bin/bash

GITHUB_USER="ahma2860"
GITHUB_TOKEN="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"
REPO_NAME="ST494_assignment3"
FOLDER_PATH="/mnt/c/Users/Asus/Desktop/STassignment"

echo "Creating GitHub repository..."
curl -v -X POST -H "Authorization: token $GITHUB_TOKEN" \
     -H "Accept: application/vnd.github.v3+json" \
     -H "Content-Type: application/json" \
     https://api.github.com/user/repos \
     -d "{\"name\":\"$REPO_NAME\", \"private\":false}"

# Initialize and push code
echo "Initializing local repository..."
git init

# Check if the remote 'origin' already exists
if git remote | grep -q origin; then
    echo "Remote 'origin' already exists. Skipping..."
else
    git remote add origin https://github.com/$GITHUB_USER/$REPO_NAME.git
fi

git remote set-url origin https://$GITHUB_TOKEN@github.com/$REPO_NAME/$REPO_NAME.git
git add .
git commit -m "Initial commit"
git branch -M main
echo "Pushing to GitHub..."
git push -u origin main

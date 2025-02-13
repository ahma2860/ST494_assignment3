#!/bin/bash

# Ensure we're in the git repository
if [ ! -d .git ]; then
    echo "Error: Not a git repository"
    exit 1
fi

# Commit any unstaged changes first
git add .
git commit -m "Temporary commit before cleanup" || true

# Create a backup of your current repository (optional)
cd ..
cp -r "$(basename $(pwd))" "$(basename $(pwd))_backup"
cd "$(basename $(pwd))"

# Remove the old .git directory and start fresh
rm -rf .git
git init

# Create proper .gitignore
cat > .gitignore << EOL
# Security
.env
*.sh
.env*
*token*
*TOKEN*
*secret*
*SECRET*

# Common
.DS_Store
*.log
node_modules/
EOL

# Initialize new repository
git init
git add .
git commit -m "Fresh start - clean repository"

# Setup remote with new token
echo "Enter your GitHub username:"
read NEW_GITHUB_USER

echo "Enter your NEW GitHub token:"
read -s NEW_GITHUB_TOKEN
echo

# Set up the new remote
git remote add origin "https://$NEW_GITHUB_USER:$NEW_GITHUB_TOKEN@github.com/$NEW_GITHUB_USER/ST494_assignment3.git"

# Force push to overwrite the remote history
echo "Force pushing new clean history..."
git push -f origin main

# Clear sensitive data from memory
unset NEW_GITHUB_TOKEN
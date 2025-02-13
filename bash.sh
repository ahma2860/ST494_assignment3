# Remove the file from Git history
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch upload.sh" \
  --prune-empty --tag-name-filter cat -- --all

# Add the cleaned file back
git add upload.sh
git commit -m "Removed sensitive information"

# Force push the cleaned history (⚠️ WARNING: This rewrites history)
git push origin main --force

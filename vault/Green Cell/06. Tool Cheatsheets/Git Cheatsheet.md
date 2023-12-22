
>[!info]
>This note is still in development.
### Creating a new Repository
---

```shell
# Creating a brand new Git Repository from CLI

# In your current project repository (e.g., CoolCode)
git init

# Create README
echo "# CoolCode Repository" > README.md

# Add ALL files within the current directory
git add -A .

git commit -m "Initial Commit"

# Github CLI to create a new public repo
gh repo create <repo_name> --public

git remote add origin https://github.com/<username>/<repo_name>
git push -u origin master
```

### Removing prior commit
---

```shell
git push -f origin HEAD^:main
```
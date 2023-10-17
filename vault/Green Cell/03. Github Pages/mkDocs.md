###  Creating your Site:
---
> [!NOTE]
> This example is a manual walkthrough of setting up the Github Pages mdBook Workflow utilizing an Obsidian Vault **WITHOUT** having to setup/use ``mkdocs`` locally on your own system.
---

#### 1. Create a repository.

#### 2. Add your Obsidian Vault.
- This Vault should contain a root ``index.md`` or ``README.md`` for navigation.

#### 3. Create an ``mkdocs.yml`` file.
- This file should point to your Obsidian Vault if the root directory isn't named `docs`.

```yml
site_name: MkDocs Example
site_author: Tyler McCann
docs_dir: vault # Root Directory (Obsidian Vault)
repo_name: tylerdotrar/notreal-mkdocs
repo_url: https://github.com/tylerdotrar/notreal-mkdocs

# Material Configuration
theme:
  name: material
  custom_dir: assets # Overrides folder containing 'home.html'
  
  features:
    - navigation.tabs
    - navigation.tabs.sticky

  palette:
    # Light Mode
    - media: "(prefers-color-scheme: light)"
      scheme: default
      primary: deep orange
      accent: indigo
      toggle:
        icon: material/toggle-switch-off-outline
        name: Switch to Dark Mode

    # Dark Mode
    - media: "(prefers-color-scheme: dark)"
      scheme: slate
      primary: teal
      accent: indigo
      toggle:
        icon: material/toggle-switch
        name: Switch to Light Mode
        
plugins:
  - search
  - roamlinks # Obsidian Style Image Support ![[<attachment_name]]
```

#### 4. Enable 'Read & Write Permissions' for Workflows usingthe GITHUB_TOKEN.
- ``Repository --> Settings --> Actions --> General --> Workflow Permissions``

![[Pasted image 20231002183650.png]]

#### 5. Create ``.github/workflows/deploy-mkdocs.yml`` using [mkocs-deploy-gh-pages.](https://github.com/mhausenblas/mkdocs-deploy-gh-pages).
```yml
# Using the workflow from: "https://github.com/mhausenblas/mkdocs-deploy-gh-pages"
name: Publish mkDocs via GitHub Pages
on:
  push:
    branches:
      - main

jobs:
  build:
    name: Deploy MkDocs
    runs-on: ubuntu-latest
    steps:
      - name: Checkout main
        uses: actions/checkout@v2

      - name: Deploy docs
        uses: mhausenblas/mkdocs-deploy-gh-pages@master
        # Or use mhausenblas/mkdocs-deploy-gh-pages@nomaterial to build without the mkdocs-material theme
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          CONFIG_FILE: mkdocs.yml
          # REQUIREMENTS: requirements.txt
          # EXTRA_PACKAGES: build-base
          # CUSTOM_DOMAIN: optionaldomain.com
          # GITHUB_DOMAIN: github.myenterprise.com
```

#### 6. Set your Github Page deployment to the 'gh-pages' branch.
- The 'gh-pages' branch will be created by the ``mdbook.yml`` workflow (assuming no errors occur).
- Once it is created, you can set that branch as your deployment branch.

![[Pasted image 20231002183731.png]]
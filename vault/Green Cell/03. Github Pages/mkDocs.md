
My example ``mkdocs.yml`` config:

```yml
site_name: RGBwiki
docs_dir: ./src


# Repository
repo_name: tylerdotrar/RGBwiki
repo_url: https://github.com/tylerdotrar/RGBwiki


# Visual Formatting
theme:
  name: material
  
  # Copied half of these from the Material root site
  features:
    - announce.dismiss
    - content.action.view
    - content.code.annotate
    - content.code.copy
    - content.tooltips
    - navigation.footer
    - navigation.indexes
    - navigation.sections
    - navigation.tabs
    - navigation.top
    - navigation.tracking
    - search.highlight
    - search.share
    - search.suggest
    - toc.follow
    
  palette:
    # Light Mode
    - media: "(prefers-color-scheme: light)"
      scheme: default
      primary: teal
      accent: indigo
      toggle:
        icon: material/toggle-switch-off-outline
        name: Switch to Dark Mode

    # Dark Mode
    - media: "(prefers-color-scheme: dark)"
      scheme: slate
      primary: teal
      accent: blue
      toggle:
        icon: material/toggle-switch
        name: Switch to Light Mode


# Extensions
markdown_extensions:
  - footnotes
  - attr_list # File Download Support
  - def_list
  - pymdownx.arithmatex:
      generic: true
  - pymdownx.magiclink
  - pymdownx.tasklist:
      custom_checkbox: true
  - pymdownx.critic
  - pymdownx.caret
  - pymdownx.keys
  - pymdownx.mark
  - pymdownx.tilde
  # Mermaid Diagram Support
  - pymdownx.superfences:
      custom_fences:
        - name: mermaid
          class: mermaid
          format: !!python/name:pymdownx.superfences.fence_code_format
  - toc:
      permalink: true
  
  # Added for Obsidian callout support
  - nl2br
  - admonition
  - pymdownx.details
  

# Plugins
plugins:
  - search
  - roamlinks # Obsidian Style Image Support
  - callouts
  - mermaid2:
      javascript: js/mermaid.min.js 


# Returning deprecated message
extra_javascript:
  - javascripts/mathjax.js
  - https://polyfill.io/v3/polyfill.min.js?features=es6
  - https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-c
```
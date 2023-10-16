## About RGBwiki
---

- This project is aimed at being an aggregate of the knowledge I have gained throughout my tenure in the field of cyber (as broad of a statement as that is).  Unfortunately, I'm starting this project a couple years late -- so some subjects are better documented than others.

## Wiki Usage
---

Another intent is for this repository to able to be read and interacted with as easily as possible; whether it be via the public facing website, via a personal [Obsidian](https://obsidian.md/) vault, or via a locally hosted [MkDocs](https://www.mkdocs.org/) instance.

### Usage via Obsidian

**(1)** Download the repository from the [GitHub page](https://github.com/tylerdotrar/RGBwiki).

```bash
# Clone Me
git clone https://github.com/tylerdotrar/RGBwiki
```

**(2)** Open the repository as a Vault in Obsidian.

![[Pasted image 20231014224324.png]]

**(3)** Profit.

![[Pasted image 20231015140025.png]]

### Usage via a local MkDocs Instance

**(1)** Download the repository from the [GitHub page](https://github.com/tylerdotrar/RGBwiki).

```powershell
# Clone Me
git clone https://github.com/tylerdotrar/RGBwiki
```

(2) Install the MkDocs dependencies.

```powershell
pip install -r requirements.txt
```

(3) Serve the vault locally on port 8000.

```powershell
# From within the root RGBwiki directory
mkdocs serve

# Windows systems might require this syntax
python -m mkdocs serve
```

![[Pasted image 20231014230226.png]]
(*Ignore the warning messages.  They stem from my implementation of a custom home page.*)


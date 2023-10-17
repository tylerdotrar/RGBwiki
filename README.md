# RGBwiki
Aggregate of my offensive (**Red**), DevOps (**Green**), and defensive (**Blue**) knowledge in the form of a mkdocs-material hosted Obsidian Vault.

![RGBwiki](https://cdn.discordapp.com/attachments/855920119292362802/1163293288883830835/image.png?ex=653f0c4d&is=652c974d&hm=69650f4e7a5e12d1e3cd202621323803b24e060b1425dc07895e3d95aee62e87&)

## About RGBwiki

- This project is aimed at being an aggregate of the knowledge I have gained throughout my tenure in the field of cyber (as broad of a statement as that is).  Unfortunately, I'm starting this project a couple years late -- so some subjects are better documented than others.

## Wiki Usage

- Another intent is for this repository to able to be read and interacted with as easily as possible; whether it be via the public facing website, via a personal [Obsidian](https://obsidian.md/) vault, or via a locally hosted [MkDocs](https://www.mkdocs.org/) instance.

---

### Usage via the Website

**(1)** Navigate to https://rgbwiki.com

**(2)** Profit.


### Usage via a Local Obsidian Vault

**(1)** Download the repository from the [GitHub page](https://github.com/tylerdotrar/RGBwiki).

```bash
# Clone Me
git clone https://github.com/tylerdotrar/RGBwiki
```

**(2)** Open the repository as a Vault in Obsidian.

![](./vault/attachments/Pasted%20image%2020231014224324.png)

**(3)** Profit.

![](./vault/attachments/Pasted%20image%2020231015140025.png)

### Usage via a Local MkDocs Instance

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

![](./vault/attachments/Pasted%20image%2020231014230226.png)
(*Ignore the warning messages.  They stem from my implementation of a custom home page.*)

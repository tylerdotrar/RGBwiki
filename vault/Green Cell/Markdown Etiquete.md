
### Tables
---

| Category 1 | Category 2 | Category 3 |
| --- | --- | --- |
| Example | ``Example`` | Longer example here. | 
| Example | ``Example`` | Longer example here. | 
| Example | ``Example`` | Longer example here. | 


### Checklists
---
- [ ] Thingy 1
- [ ] Thingy 2
- [ ] Thingy 3


### Message Blocks (Callouts)
---

> [!info]
> Information here.
> Alises: N/A

> [!todo]
> To-do list here.
> Alises: N/A

> [!tip]
> Important info here!
> Aliases: ``hint``, ``important``

>[!success]
>Success here!
> Aliases: ``check``, ``done``

> [!question]
> Freqently asked questions!
> Aliases: ``help``, ``faq``

>[!warning]
> Warning here!
> Aliases: ``caution``, ``attention``

>[!failure]
> Failure here!
> Aliases: ``fail``, ``missing``

> [!danger]
> Bruh!!!
> Aliases: N/A

> [!bug]
> Known bugs here!
> Aliases: N/A

> [!example]
> Example here!
> Aliases: N/A

> [!quote]
> Quote here!
> Aliases: N/A

**Example:**

> [!question]- Guess what?
> > [!example] Callouts can be renamed...
> > > [!tip] ... and nested!


The following are GitHub README compatible:

> [!NOTE]  
> Highlights information that users should take into account, even when skimming.

> [!IMPORTANT]  
> Crucial information necessary for users to succeed.

> [!WARNING]  
> Critical content demanding immediate user attention due to potential risks.


### Diagrams
---

```mermaid
graph TD;
	A[Originator] --> B[Route 1];
	A --> C[Route 2];
	B --> D[Finish];
	C --> D;
```

```mermaid
flowchart LR

A[Hard] -->|Text| B(Round)
B --> C{Decision}
C -->|One| D[Result 1]
C -->|Two| E[Result 2]
```

```mermaid
gantt
    section Section
    Completed :done,    des1, 2014-01-06,2014-01-08
    Active        :active,  des2, 2014-01-07, 3d
    Parallel 1   :         des3, after des1, 1d
    Parallel 2   :         des4, after des1, 1d
    Parallel 3   :         des5, after des3, 1d
    Parallel 4   :         des6, after des4, 1d
```


```mermaid
pie
"Dogs" : 386
"Cats" : 85.9
"Rats" : 15
```

### Code Blocks
---

```powershell
# PowerShell
Get-ChildItem "C:\Windows\system32"
```

```shell
#!/bin/bash
echo "yo momma"
```


### Embedding Images & Videos
---

**URL Encoded Format**
```
# Locally Hosted Image
![](file://<absolute_file_path_url_encoded>)

# Web Hosted Image
![](http(s)://<image_url>
```

### File Download Support
---
```
# Download a file from a local 'downloads' directory
[link](downloads/filename.exe){:download="filename.exe"}
```

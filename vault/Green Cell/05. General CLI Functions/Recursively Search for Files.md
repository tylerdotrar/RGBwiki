
### Linux
---

```shell
# Search Entire File System for File
find / -name "user.txt" 2>/dev/null

# Search Entire File System for Pattern
find / -name "*.txt" 2>/dev/null

# Search for Files containing a String
grep -r "search_string" /path/to/search/directory
```


### Windows
---

- PowerShell
```powershell
# Search Entire File System for File
Get-ChildItem -Path C:/ -Recurse -Filter "user.txt" 2>$NULL
# Including Hidden Files
Get-ChildItem -Path C:/ -Recurse -Hidden -Filter "user.txt" 2>$NULL

# Search Entire File System for Pattern
Get-ChildItem -Path C:/ -Recurse -Filter "user.txt" 2>$NULL
Get-ChildItem -Path C:/ -Recurse -Hidden -Filter "*.txt*" 2>$NULL
```

- CMD
```
# Search Entire File System for File (including Hidden Files)
dir /s /b C:\user.txt 2>nul

# Search Entire File Sytem for Pattern (including Hidden Files)
dir /s /b /a C:\*.txt 2>nul
```
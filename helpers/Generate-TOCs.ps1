function Generate-TOCs {
#.SYNOPSIS
# Script to recursively generate verbose Table of Contents
# ARBITRARY VERSION NUMBER: 1.0.0
# AUTHOR: Tyler McCann (@tylerdotrar)
#
#.DESCRIPTION
# Recursively iterate through the Vault and update/generate index(es) if Section index(es)
# have headers that pass validation (e.g., proper heading, spacing, and description).  This
# allows for easy reorganization of the Vault, assuming sections have proper headings.
# Default behavior is to print a Vault directory tree without overwriting any files.
#
# Parameters:
#    -VaultRoot     -->   The root directory of the vault.
#    -Write         -->   Overwrite existing index(es).
#    -Help          -->   Return Get-Help information.
#
#
#     Maximum Directory Depth:
#     _______________________________________________________________
#    | root                                                          |
#  -1| |__ index.md (site coverpage)                                 |
#    | |__ Color Cell                                                |
#   0|     |__ index.md (TOC to modify)                              |
#    |     |__ num. Section                                          |
#  +1|         |__ index.md (TOC to modify)                          |
#    |         |__ File1.md                                          |
#    |         |__ Subfolder1                                        |
#  +2|             |__ File2.md                                      |
#    |             |__ Subfolder2                                    |
#  +3|                 |__ File3.md                                  |
#    |_______________________________________________________________|
#
#
#     Cell Table of Contents (index.md):
#     _______________________________________________________________
#  01| # <color_cell> Overview                                       | <-- Start Header
#  02|                                                               |
#  03| > [!info]                                                     | 
#  04| > **<color_cell>** | <cell_description>                       |
#  05|                                                               |
#  06| ---                                                           |
#  07| ### [$num. $SectionName](./${num}.%20${SectionName}/index.md) | <-- Start ToC
#  08| - $SectionDescription                                         |
#  09| <etc>                                                         |
#  10|_______________________________________________________________|
#
#
#     Section Table of Contents (index.md):
#     _______________________________________________________________
#  01| # <section_name>                                              | <-- Start Header
#  02| ---                                                           | 
#  03| - <section_description>                                       |
#  04| ## Table of Contents                                          | <-- Start ToC
#  05| ---                                                           |
#  06| - [$Filename1](./$Filename1.md)                               |
#  07| ### $Subfolder1                                               |
#  08| - [$Filename2](./$Subfolder1/$Filename2.md)                   |
#  09| ##### $Subfolder2                                             |
#  10| - [$Filename3](./$Subfolder1/$Subfolder2/$Filename3.md)       |
#  11| <etc>                                                         |
#  12|_______________________________________________________________|
#
#
#.LINK
# https://github.com/tylerdotrar/RGBwiki

    
    Param (
        [string]$VaultRoot = "$PSScriptRoot/../vault", # Located in 'helpers' directory
        [switch]$Write,
        [switch]$Help
    )


    # Return Get-Help information
    if ($Help) { return (Get-Help Generate-ToCs) }


    # Audit Function
    function Audit-ToC ($Index, [switch]$Cell, [switch]$Section) {
        
        # Audit Cell 'index.md'
        if ($Cell) {
            $Content = Get-Content -LiteralPath $Index -Encoding UTF8
            $PassAudit = $TRUE

            # Can be refined later, but it technically works.
            if ($Content[0] -notmatch "^# [A-Za-z\s]+ Overview$")          { $PassAudit = $FALSE } # Cell Overview
            if ($Content[1] -notmatch "^\s*$")                             { $PassAudit = $FALSE } # White Space
            if ($Content[2] -notmatch "^>\s*\[!info\]\s*$")                { $PassAudit = $FALSE } # Info Callout
            if ($Content[3] -notmatch "^>\s*\*\*[A-Za-z\s]+\*\*\s\|\s.*$") { $PassAudit = $FALSE } # Callout Data
            if ($Content[4] -notmatch "^\s*$")                             { $PassAudit = $FALSE } # White Space
            if ($Content[5] -notmatch "^---\s*$")                          { $PassAudit = $FALSE } # Line separator
        }

        # Audit Section 'index.md'
        if ($Section) {
            $Content = Get-Content -LiteralPath $Index -Encoding UTF8
            $PassAudit = $TRUE

            # Can be refined later, but it technically works.
            if ($Content[0] -notmatch "^# .+$")   { $PassAudit = $FALSE } # Section Name
            if ($Content[1] -notmatch "^---\s*$") { $PassAudit = $FALSE } # Line separator
            if ($Content[2] -notmatch "^- .+$")   { $PassAudit = $FALSE } # Section Description
        }

        # Return audit results
        return $PassAudit
    }


    # Establish Cells
    $Cells = (Get-ChildItem -LiteralPath $VaultRoot -Directory -Filter "* Cell")

    $DirTree   = @('vault')
    $DirBranch = '|__ '


    # Test Write (this will overwrite section indexes)
    if ($Write) {
        Write-Host "[+] Generating index(es):" -ForegroundColor Yellow
    }

    # Iterate through Cells (Depth: 0)
    foreach ($Cell in $Cells) {

        # Cell Table of Contents
        $CellTOC = @()
        $DirDepth = 0


        # Add Cell to DirTree
        $DirTree += '|'
        $DirTree += ('    ' * $DirDepth) + $DirBranch + $Cell.Name


        # Validate Index
        $CellIndex = ("$($Cell.Fullname)/index.md").Replace('\','/')
        if (!(Test-Path -LiteralPath $CellIndex)) { <#echo "$($Cell.name) 'index.md' does not exist."   ;#> continue }
        if (!(Audit-ToC -Cell $CellIndex)) { <#echo "$($Cell.name) 'index.md' failed the header audit." ;#> continue }
        

        # Add index to DirTree & headers to Cell Table of Contents
        $DirTree += ('    ' * ($DirDepth + 1)) + $DirBranch + $CellIndex.Split('/')[-1]
        (Get-Content $CellIndex -Encoding UTF8)[0..5] | % { $CellTOC += $_ }


        # Get list of all Sections (prefaced by a two digit number)
        $Sections = (Get-ChildItem -LiteralPath $Cell.Fullname -Directory | ? { $_.Name -match "^\d{2}\. *" })

        # Get list of all '.md' Files (should not exist)
        #$MdFilesD0 = Get-ChildItem -LiteralPath $Cell.Fullname -Filter "*.md" | ? { $_.Name -ne 'index.md' }


        # Iterate through Cells (Depth: 1)
        foreach ($Section in $Sections) {
            
            # Section Table of Contents
            $SectionTOC = @()
            $DirDepth = 1
          

            # Validate Index
            $SectionIndex = ("$($Section.Fullname)/index.md").Replace('\','/')
            if (!(Test-Path -LiteralPath $SectionIndex)) { <#Write-Host "$($Section.name) 'index.md' does not exist." ;#> continue }
            if (!(Audit-ToC $SectionIndex -Section)) { <#Write-Host "$($Section.name) 'index.md' failed the header audit.";#> continue }


            # Add Section and index to DirTree
            $DirTree += ('    ' * $DirDepth) + $DirBranch + $Section.Name
            $DirTree += ('    ' * ($DirDepth + 1)) + $DirBranch + $SectionIndex.Split('/')[-1]


            # Add headers to Section Table of Contents
            (Get-Content $SectionIndex -Encoding UTF8)[0..2] | % { $SectionTOC += $_ }
            $SectionTOC += '## Table of Contents'
            $SectionTOC += '---'


            # Acquire Variables for Cell ToC
            $SectionFull = $Section.Name
            $Description = (Get-Content $SectionIndex -Encoding UTF8)[2]
            $SectionDescription = (Get-Content $SectionIndex -Encoding UTF8)[2]
            #$Num         = $SectionFull | Select-String -Pattern "\d{2}\.\s" -AllMatches | % { ($_.Matches.Value) }
            #$SectionName = $SectionFull.Replace("$Num","")
            
           
            # Add Section + Description to Cell Table of Contents
            $CellTOC += "### [${SectionFull}](./$($SectionFull.Replace(' ','%20'))/index.md)"
            $CellTOC += $SectionDescription


            # Get list of all Markdown files not in a subdirectory (excluding index)
            $MdFilesD1 = (Get-ChildItem -LiteralPath $Section.Fullname -Filter "*.md" | ? { $_.Name -ne 'index.md' })

            # Get list of all folders in Sections
            $SubfoldersD1 = (Get-ChildItem -LiteralPath $Section.Fullname -Directory)


            # Add files to ToC (Depth: 1)
            foreach ($MdFile in $MdFilesD1) {
                
                $MdFileFull = $MdFile.Name

                # Add files to dirtree and Section ToC
                $DirTree += ('    ' * ($DirDepth + 1)) + $DirBranch + $MdFileFull
                $SectionTOC += "- [$($MdFile.BaseName)](./$($MdFileFull.Replace(' ','%20')))"
            }

            
            # Iterate through Subfolders (Depth: 1)
            foreach ($Subfolder1 in $SubfoldersD1) {
                
                $Subfolder1Full = $Subfolder1.Name

                # Add files to dirtree
                $DirTree += ('    ' * ($DirDepth + 1)) + $DirBranch + $Subfolder1Full
                $SectionTOC += "### $Subfolder1Full"

                # Get list of all Sections (prefaced by a two digit number)
                $MdFilesD2 = (Get-ChildItem -LiteralPath $Subfolder1.Fullname -Filter "*.md")

                # Get list of all folders in Sections
                $SubfoldersD2 = (Get-ChildItem -LiteralPath $Subfolder1.Fullname -Directory)

                
                # Add files to ToC (Depth: 2)
                foreach ($MdFile in $MdFilesD2) {
                
                    $MdFileFull = $MdFile.Name

                    # Add files to dirtree and Section ToC
                    $DirTree += ('    ' * ($DirDepth + 2)) + $DirBranch + $MdFileFull
                    $SectionTOC += "- [$($MdFile.BaseName)](./$($Subfolder1Full.Replace(' ','%20'))/$($MdFileFull.Replace(' ','%20')))"
                }


                # Iterate through Subfolders (Depth: 2)
                foreach ($Subfolder2 in $SubfoldersD2) {
                
                    $Subfolder2Full = $Subfolder2.Name

                    # Add files to dirtree
                    $DirTree += ('    ' * ($DirDepth + 2)) + $DirBranch + $Subfolder2Full
                    $SectionTOC += "##### $Subfolder2Full"

                    # Get list of all Sections (prefaced by a two digit number)
                    $MdFilesD3 = (Get-ChildItem -LiteralPath $Subfolder2.Fullname -Filter "*.md")
                

                    # Add files to ToC (Depth: 3)
                    foreach ($MdFile in $MdFilesD3) {
                
                        $MdFileFull = $MdFile.Name

                        # Add files to dirtree and Section ToC
                        $DirTree += ('    ' * ($DirDepth + 3)) + $DirBranch + $MdFileFull
                        $SectionTOC += "- [$($MdFile.BaseName)](./$($Subfolder1Full.Replace(' ','%20'))/$($Subfolder2Full.Replace(' ','%20'))/$($MdFileFull.Replace(' ','%20')))"
                    }
                }
            }

            # Return Section Table of Contents
            #$SectionTOC

            # Overwrite Section indexes
            if ($Write) {
                $SectionIndexPath = "$(($Section.Fullname).Replace('\','/'))/index.md"
                $SectionTOC | Set-Content -Path $SectionIndexPath -Encoding UTF8
                Write-Host " o '$SectionIndexPath'"
            }
        }


        # Return Cell Table of Contents
        #$CellTOC

        # Overwrite Cell indexes
        if ($Write) {
            $CellIndexPath = "$(($Cell.Fullname).Replace('\','/'))/index.md"
            $CellTOC | Set-Content -Path $CellIndexPath -Encoding UTF8
            Write-Host " o '$CellIndexPath'"
        }
    }


    # Return DirTree
    if (!$Write) {
        Write-Host '[+] Vault DirTree:' -ForegroundColor Yellow
        $DirTree | % { if ($_ -like "*index.md") { Write-Host $_ -ForegroundColor Yellow } else { $_ } }

        Write-Host "`n[+] Use the '-Write' parameter to overwrite index(es)." -ForegroundColor Yellow
    }
}
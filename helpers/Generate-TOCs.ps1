function Generate-TOCs {
#.SYNOPSIS
# Script to recursively generate verbose Table of Contents
# ARBITRARY VERSION NUMBER: WIP
# AUTHOR: Tyler McCann (@tylerdotrar)
#
#.DESCRIPTION
# Description TBD.
#
# Parameters:
#    -VaultRoot     -->   The root directory of the vault.
#    -Audit         -->   Audit Cell and Section indexes for headers.
#    -Help          -->   Return Get-Help information.
#
#
#     Maximum Directory Depth:
#     ______________________________________
#    | root                                 |
#  -1| |__ index.md (site coverpage)        |
#    | |__ Color Cell                       |
#   0|     |__ index.md (TOC to modify)     |
#    |     |__ num. Section                 |
#  +1|         |__ index.md (TOC to modify) |
#    |         |__ File1.md                 |
#    |         |__ Subfolder1               |
#  +2|             |__ File2.md             |
#    |             |__ Subfolder2           |
#  +3|                 |__ File3.md         |
#    |______________________________________|
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
#     _________________________________________________________
#  01| # <section_name>                                        | <-- Start Header
#  02| ---                                                     | 
#  03| - <section_description>                                 |
#  04| ## Table of Contents                                    | <-- Start ToC
#  05| ---                                                     |
#  06| - [$Filename1](./$Filename1.md)                         |
#  07| ### $Subfolder1                                         |
#  08| - [$Filename2](./$Subfolder1/$Filename2.md)             |
#  09| ##### $Subfolder2                                       |
#  10| - [$Filename3](./$Subfolder1/$Subfolder2/$Filename3.md) |
#  11| <etc>                                                   |
#  12|_________________________________________________________|
#
#
#.LINK
# https://github.com/tylerdotrar/RGBwiki

    
    Param (
        [string]$VaultRoot = "$PSScriptRoot/../vault", # Located in 'helpers' directory
        [switch]$Audit,
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

    # Iterate through Cells (Depth: 0)

    foreach ($Cell in $Cells) {

        # Cell Table of Contents
        $CellTOC = @()
        $DirDepth = 0


        # Add Cell to DirTree
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


            # Get list of all Sections (prefaced by a two digit number)
            $MdFilesD1 = (Get-ChildItem -LiteralPath $Section.Fullname -Filter "*.md" | ? { $_.Name -ne 'index.md' })


            # Add files to ToC
            foreach ($MdFile in $MdFilesD1) {
                
                $MdFileFull = $MdFile.Name

                # Add files to dirtree
                $DirTree += ('    ' * ($DirDepth + 1)) + $DirBranch + $MdFileFull
                $SectionTOC += "- [$($MdFile.BaseName)](./$($MdFileFull.Replace(' ','%20')))"
            }

            # Test Write (WORKING)
            #$TestPath = "$($Section.Fullname)/ExampleTOC.md"
            #$SectionTOC | Set-Content -Path $TestPath

            ### Iterate through depth 2 and 3
            #foreach (
        }

        # Return Cell Table of Contents
        #$CellTOC
    }

    # Return DirTree
    Write-Host "[+] Print DirTree..."
    $DirTree
}

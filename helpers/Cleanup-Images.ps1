function Cleanup-Images {
#.SYNOPSIS
# Simple script to list and/or remove all unused attachments within the Vault.
# ARBITRARY VERSION NUMBER: 1.0.0
# AUTHOR: Tyler McCann (@tylerdotrar)
#
#.DESCRIPTION
# This is a very simple script that creates two arrays: one of all files in the
# designated 'attachments' directory, and one of all attachments found being 
# used within the Obsidian fault, specifically filtering on RoamLinks images.
# (i.e., '![[<attachment_name>]]')
#
# The script then compares the two arrays to see if there are any differences.
# o  Unique files in both arrays can be displayed using '-Verbose'
# o  Unique files in the 'attachments' directory can me deleted using '-Remove'
#
# Parameters:
#    -Attachments   -->   Directory containing the vault's attachments.
#    -VaultRoot     -->   The root directory of the vault.
#    -Remove        -->   Remove unique files in the 'attachments' directory.
#    -Verbose       -->   Display filenames of unique files.
#    -Help          -->   Return Get-Help information.
#
#.LINK
# https://github.com/tylerdotrar/RGBwiki


    Param (
        [string]$Attachments = "$PSScriptRoot/../vault/attachments", # Located in 'helpers' directory
        [string]$VaultRoot   = "$PSScriptRoot/../vault",             # Located in 'helpers' directory
        [switch]$Remove,
        [switch]$Verbose,
        [switch]$Help
    )
    

    # Return Get-Help Information
    if ($Help) { return (Get-Help Cleanup-Images) }


    # Acquire list of all available images and .md files
    $AvailableImages = (Get-ChildItem -LiteralPath $Attachments).Name
    $MdFiles         = (Get-ChildItem -LiteralPath $VaultRoot -Recurse -Filter "*.md").FullName


    # Iterate through every .md file for attachments (RoamLinks)
    $UsedImages = @()
    foreach ($MdFile in $MdFiles) {

        $MdContents = Get-Content $MdFile
        $UsedImages += $MdContents | Select-String -Pattern '![[[A-Za-z0-9\s.]+]]' -AllMatches | % { (($_.Matches.Value).Replace('![[','')).Replace(']]','') }
    }


    # Remove of duplicate entries
    $AvailableImages = $AvailableImages | Sort-Object -Unique
    $UsedImages      = $UsedImages | Sort-Object -Unique


    # Find all unique elements in each array
    $UnusedImages      = Compare-Object -ReferenceObject $AvailableImages -DifferenceObject $UsedImages | ? { $_.SideIndicator -eq '<=' }
    $UnavailableImages = Compare-Object -ReferenceObject $AvailableImages -DifferenceObject $UsedImages | ? { $_.SideIndicator -eq '=>' }


    # Print the differences
    Write-Host "[+] Total available images: " -ForegroundColor Yellow -NoNewline; $(($AvailableImages | Sort-Object -Unique).count)
    Write-Host " o  Unused images: " -ForegroundColor Yellow -NoNewline; $(($UnusedImages.InputObject).count)
    if ($Verbose -and ($UnusedImages.count -gt 0)) { $UnusedImages.InputObject | % { Write-Host " -  " -ForegroundColor Red -NoNewline; $_ } }

    Write-Host "`n[+] Total used images: " -ForegroundColor Yellow -NoNewline; $(($UsedImages | Sort-Object -Unique).count)
    Write-Host " o  Unavailable images: " -ForegroundColor Yellow -NoNewline; $(($UnavailableImages.InputObject).count)
    if ($Verbose -and ($UnavailableImages.count -gt 0)) { $UnavailableImages.InputObject | % { Write-Host " -  " -ForegroundColor Red -NoNewline; $_ } }

    
    # Remove unused images from the 'attachments' directory
    if ($Remove) {

        if ($UnusedImages.count -lt 1) { return (Write-Host "`n[-] No unused image(s) to delete." -ForegroundColor Red) }

        Write-Host "`n[+] Removing unused image(s)..." -ForegroundColor Yellow
        $UnusedImages.InputObject | % { Remove-Item -LiteralPath "$Attachments/$_" -Force }
        Write-Host " o  Done." -ForegroundColor Yellow
    }
}
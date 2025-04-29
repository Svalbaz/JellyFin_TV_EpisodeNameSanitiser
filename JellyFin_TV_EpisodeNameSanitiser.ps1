<#
SvalbazNet: TV_EpisodeNameSanitiser.ps1

Target:		TV
Use: 		Script looks recursively at all folders in $rootTV for misnamed Episode titles and corrects them into this format: "<Show Name> (year) - SXXEXX.XXX)". This also picks up any unmatched and gives you a list at the end of the run.
Reason: 	After a botched start with JellyFin I had to sanitise the naming conventions of my TV Show Episodes to help it's scraping

# SAFE MODE: This Script is saved in "SAFE MODE", so by default it will only Write-Host the result,
it will not actually Rename-Item until you remove the -WhatIf
#>

# ----- VARIABLES ----- #
$rootTV = "\\192.168.1.184\tv\TV"
$unmatchedFiles = @()  # Array to store unmatched filenames

# ----- SCRIPT ----- #
Get-ChildItem -Path $rootTV -Directory | ForEach-Object {
    $showFolder = $_.FullName

    Get-ChildItem -Path $showFolder -Directory -Filter "Season *" | ForEach-Object {
        $seasonFolder = $_.FullName

        Get-ChildItem -Path $seasonFolder -File | Where-Object { $_.Extension -match "\.(mkv|mp4|avi)$" } | ForEach-Object {
            $oldName = $_.Name
            $oldPath = $_.FullName

            # Try to extract "Show (Year)" and SxxExx pattern (or sxxexx etc)
            if ($oldName -match "^(?<show>.+?)\s*(?:-|–)?\s*(?:Season\s*\d+\s*)?(?:-|–)?\s*(?<ep>s\d{2}e\d{2}(?:-\w+)?)(?:[^\\\/]*)?(?<ext>\.\w+)$") {
                $cleanShow = $Matches['show'].Trim()
                $epCode = $Matches['ep'].ToUpper()
                $ext = $Matches['ext']
                $newName = "$cleanShow - $epCode$ext"
                $newPath = Join-Path -Path $seasonFolder -ChildPath $newName

                if ($oldName -ne $newName) {
                    Write-Host "Renaming:`n $oldName `n   => $newName" -ForegroundColor Yellow
                    Rename-Item -Path $oldPath -NewName $newName -WhatIf  # SAFE MODE: REMOVE -WhatIf to Rename-Item
                }
            } else {
                $unmatchedFiles += $oldName
            }
        }
    }
}

# ----- SUMMARY OUTPUT ----- #
if ($unmatchedFiles.Count -gt 0) {
    Write-Host "`nUnmatched Files:" -ForegroundColor Cyan
    $unmatchedFiles | Sort-Object | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
} else {
    Write-Host "`n✅ All files matched successfully!" -ForegroundColor Green # Let's use Emojis, it's 2025
}

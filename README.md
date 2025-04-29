# JellyFin_TV_EpisodeNameSanitiser

# SvalbazNet: TV_EpisodeNameSanitiser.ps1

## Target
TV

## Description
This script scans all folders in `$rootTV` for misnamed TV episode files and renames them into a standardised format:  
`<Show Name> (year) - SXXEXX.XXX`

The script also generates a list of unmatched episode files at the end of its execution.

## Purpose
This script was designed to help clean up and standardise/Sanitise episode naming conventions after my botched initial setup with JellyFin. Properly formatted names help the JellyFin scraper to accurately recognise and organise your TV show episodes.

## Safe Mode
This script runs in "SAFE MODE" by default. It will display the results of its actions (using `Write-Host`) without actually renaming the files. To apply the changes, remove the `-WhatIf` parameter.

## Usage
Run the script in your TV library folder. It will show a preview of the renaming operations without making any changes unless you explicitly disable the `-WhatIf` flag.

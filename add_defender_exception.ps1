# This script must be run as Administrator

# Get the full path to the cloudflare.exe file
$exePath = Join-Path -Path (Get-Location) -ChildPath "dist\cloudflare.exe" | Resolve-Path

# Add the exclusion for the specific file
Add-MpPreference -ExclusionPath $exePath

Write-Host "Added exclusion for: $exePath" -ForegroundColor Green
Write-Host "You can now run the executable without Windows Defender interfering"

# Optional: Also add the directory as an exclusion
$distDir = Join-Path -Path (Get-Location) -ChildPath "dist" | Resolve-Path
Add-MpPreference -ExclusionPath $distDir
Write-Host "Added exclusion for directory: $distDir" -ForegroundColor Green

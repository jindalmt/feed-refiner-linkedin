$ErrorActionPreference = "Stop"
$base = "e:\linkedinBeautUI"
& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $base "resize-only.ps1")
& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $base "blur-final.ps1")
& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $base "patch1.ps1")
& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $base "add-captions.ps1")
& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $base "fix-daily-limit.ps1")
Write-Host "PIPELINE DONE"

# Ensure the script runs with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script requires administrative privileges. Restarting with admin rights..."
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File "$PSCommandPath"" -Verb RunAs
    exit
}

$progressPreference = 'silentlyContinue'

# --- Installing Winget Dependencies ---
Write-Host "Installing Winget Dependencies..."
$depUrl = "https://github.com/microsoft/winget-cli/releases/download/v1.10.320/DesktopAppInstaller_Dependencies.zip"
$depZip = "$env:TEMP\DesktopAppInstaller_Dependencies.zip"
Invoke-WebRequest -Uri $depUrl -OutFile $depZip
$depFolder = "$env:TEMP\DesktopAppInstaller_Dependencies"
Expand-Archive -Path $depZip -DestinationPath $depFolder -Force

# Determine system architecture and set variables accordingly
if ([Environment]::Is64BitOperatingSystem) {
    $uiXaml = Join-Path $depFolder "x64\Microsoft.UI.Xaml.2.8_8.2501.31001.0_x64.appx"
    $vcLibs = Join-Path $depFolder "x64\Microsoft.VCLibs.140.00.UWPDesktop_14.0.33728.0_x64.appx"
}
else {
    $uiXaml = Join-Path $depFolder "x86\Microsoft.UI.Xaml.2.8_8.2501.31001.0_x86.appx"
    $vcLibs = Join-Path $depFolder "x86\Microsoft.VCLibs.140.00.UWPDesktop_14.0.33728.0_x86.appx"
}

try {
    Add-AppxPackage -Path $PackagePath -ErrorAction Stop
}
catch {
    if ($_.Exception.Message -match "0x80073D02") {
        Write-Host "Package '$PackagePath' already installed, skipping."
    }
    else {
        throw $_
    }
}


Write-Host "Installing Microsoft.UI.Xaml dependency..."
Try-AddAppxPackage -PackagePath $uiXaml

Write-Host "Installing Microsoft.VCLibs dependency..."
Try-AddAppxPackage -PackagePath $vcLibs

Write-Host "Installing Winget..."
$msixUrl = "https://github.com/microsoft/winget-cli/releases/download/v1.10.320/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
$msixPath = "$env:TEMP\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
Invoke-WebRequest -Uri $msixUrl -OutFile $msixPath

try {
    Add-AppxPackage -Path $msixPath -ErrorAction Stop
}
catch {
    if ($_.Exception.Message -match "0x80073D02") {
        Write-Host "Microsoft.DesktopAppInstaller already installed, skipping."
    }
    else {
        throw $_
    }
}

Write-Host "Checking if there is any Winget update..."
winget update winget --silent
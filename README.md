# InstallWinget

**InstallWinget** is a PowerShell script that automates the installation of Winget and its dependencies, ensuring smooth package management on Windows 10/11. This script is designed to bypass common issues such as missing dependencies, PowerShell 7 incompatibilities, and installation failures.

## Features
- **Automated Winget Installation:** Installs Winget using Microsoft's official packages.
- **Dependency Management:** Automatically installs required Appx packages.
- **Fixes PowerShell 7 Issues:** Works around `Repair-WinGetPackageManager` limitations.
- **Silent Installation:** No user interaction required.

## Why This Script?
The official Winget installation method via `Repair-WinGetPackageManager`:
- **Fails on PowerShell 7** due to missing `NuGet` provider.
- **Has dependency issues**, requiring manual fixes.
This script provides a **reliable workaround** borrowed from [UltimateRedist](https://github.com/darthdemono/UltimateRedist).

The original script:
```ps1
$progressPreference = 'silentlyContinue'
Write-Host "Installing WinGet PowerShell module from PSGallery..."
Install-PackageProvider -Name NuGet -Force | Out-Null
Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery | Out-Null
Write-Host "Using Repair-WinGetPackageManager cmdlet to bootstrap WinGet..."
Repair-WinGetPackageManager
Write-Host "Done."
```

## Installation

### Prerequisites
- **Windows 10/11**
- **PowerShell:** Must be run as **Administrator**
- **Execution Policy:** Ensure script execution is allowed

### How to Use

1. **Open Windows Terminal or PowerShell as Administrator:**
   - Right-click on the **Start** button and select **Windows Terminal (Admin)** or **PowerShell (Admin)**.

2. **Enable Script Execution (if not already enabled):**
   ```powershell
   Set-ExecutionPolicy Unrestricted
   ```

3. **Run the Script:**
   Copy and paste the following command into PowerShell:
   ```powershell
   irm "https://raw.githubusercontent.com/darthdemono/InstallWinget/main/InstallWinget.ps1" | iex
   ```
   - This will **download and execute** the InstallWinget script from GitHub.

## Notes
- This script automatically **downloads** the latest Winget dependencies from [Microsoft's GitHub Releases](https://github.com/microsoft/winget-cli/releases).
- If Winget is already installed, it will **check for updates** and apply them.
- Works on both **x64** and **x86** systems.

## License
This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---


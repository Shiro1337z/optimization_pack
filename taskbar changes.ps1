# Ensure the Microsoft.WinGet.Client module is installed
Run-AsAdmin -Command 'if (-not (Get-Module -ListAvailable -Name Microsoft.WinGet.Client)) { Install-Module -Name Microsoft.WinGet.Client -Force -Scope CurrentUser }'

# Import the module
Run-AsAdmin -Command 'Import-Module Microsoft.WinGet.Client'

# List of apps to unpin
$appsToUnpin = @(
    'Microsoft.MicrosoftEdge',
    'Microsoft.WindowsStore',
    'Microsoft.WindowsCalculator',
    'Microsoft.Paint',
    'Microsoft.WindowsCamera',
    'Microsoft.XboxGamingOverlay',
    'Microsoft.YourPhone',
    'Microsoft.Todos',
    'Microsoft.OneConnect',
    'Microsoft.GetHelp',
    'Microsoft.MicrosoftSolitaireCollection',
    'Microsoft.People',
    'Microsoft.SkypeApp',
    'Microsoft.WindowsMaps',
    'Microsoft.Office.OneNote',
    'Microsoft.GrooveMusic',
    'Microsoft.ZuneVideo',
    'Microsoft.WindowsFeedbackHub',
    'Microsoft.Xbox.TCUI',
    'Microsoft.XboxGameOverlay',
    'Microsoft.XboxIdentityProvider',
    'Microsoft.XboxSpeechToTextOverlay',
    'Microsoft.MixedReality.Portal',
    'Microsoft.3DViewer',
    'Microsoft.MSPaint',
    'Microsoft.Microsoft3DViewer'
)

# Build and run unpin command
try {
    $unpinCommand = "Get-StartApps | Where-Object { " +
        ($appsToUnpin | ForEach-Object { "`$_.AppId -like '*$_*'" }) -join ' -or ' +
        " } | ForEach-Object { Unpin-StartApps -AppId `$_.AppId }"
    Run-AsAdmin -Command $unpinCommand
} catch {
    Clear-Host
    Write-Host "The apps have not been found."
    exit
}

# Other customizations
Run-AsAdmin -Command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search' -Name 'SearchboxTaskbarMode' -Value 0 -Force"
Run-AsAdmin -Command "Set-TimeZone -Id 'E. Europe Standard Time'"
Run-AsAdmin -Command "Set-WinUserLanguageList -LanguageList @('en-US') -Force"

# Registry modifications
$commands = @(
    "reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings' /v TaskbarEndTask /t REG_DWORD /d 1 /f",
    "reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' /v Hidden /t REG_DWORD /d 1 /f",
    "reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' /v HideFileExt /t REG_DWORD /d 0 /f",
    "reg add 'HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32' /ve /f",
    "reg add 'HKCU\Software\Policies\Microsoft\Windows\CloudContent' /v DisableWindowsSpotlightFeatures /t REG_DWORD /d 1 /f",
    "reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' /v RotatingLockScreenEnabled /t REG_DWORD /d 0 /f",
    "reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' /v RotatingLockScreenOverlayEnabled /t REG_DWORD /d 0 /f",
    "reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' /v SubscribedContent-338387Enabled /t REG_DWORD /d 0 /f",
    "reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f",
    "reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f",
    "reg add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' /v ShowSecondsInSystemClock /t REG_DWORD /d 1 /f",
    "reg add 'HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System' /v ConsentPromptBehaviorAdmin /t REG_DWORD /d 0 /f",
    # PowerPlan registry entries
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan' /v Icon /t REG_SZ /d 'powercpl.dll' /f",
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan' /v MUIVerb /t REG_SZ /d 'Select Power Plan' /f",
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan' /v Position /t REG_SZ /d 'Middle' /f",
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan' /v SubCommands /t REG_SZ /d '' /f",
    # PowerPlan subcommands
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan\shell\01menu' /v MUIVerb /t REG_SZ /d 'Power Saver' /f",
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan\shell\01menu' /v Icon /t REG_SZ /d 'powercpl.dll' /f",
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan\shell\01menu\command' /ve /t REG_SZ /d 'powercfg.exe /setactive a1841308-3541-4fab-bc81-f71556f20b4a' /f",
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan\shell\02menu' /v MUIVerb /t REG_SZ /d 'Balanced' /f",
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan\shell\02menu' /v Icon /t REG_SZ /d 'powercpl.dll' /f",
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan\shell\02menu\command' /ve /t REG_SZ /d 'powercfg.exe /setactive 381b4222-f694-41f0-9685-ff5bb260df2e' /f",
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan\shell\03menu' /v MUIVerb /t REG_SZ /d 'High Performance' /f",
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan\shell\03menu' /v Icon /t REG_SZ /d 'powercpl.dll' /f",
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan\shell\03menu\command' /ve /t REG_SZ /d 'powercfg.exe /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c' /f",
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan\shell\04menu' /v MUIVerb /t REG_SZ /d 'Ultimate Performance' /f",
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan\shell\04menu' /v Icon /t REG_SZ /d 'powercpl.dll' /f",
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan\shell\04menu\command' /ve /t REG_SZ /d 'powercfg.exe /setactive e9a42b02-d5df-448d-aa00-03f14749eb61' /f",
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan\shell\05menu' /v MUIVerb /t REG_SZ /d 'Power Options' /f",
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan\shell\05menu' /v Icon /t REG_SZ /d 'powercpl.dll' /f",
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan\shell\05menu' /v CommandFlags /t REG_DWORD /d 32 /f",
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan\shell\05menu\command' /ve /t REG_SZ /d 'control.exe powercfg.cpl' /f",
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan\shell\06menu' /v MUIVerb /t REG_SZ /d 'Khorvie plan' /f",
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan\shell\06menu' /v Icon /t REG_SZ /d 'powercpl.dll' /f",
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan\shell\06menu' /v MUIVerb /t REG_SZ /d 'Khorvie plan' /f",
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan\shell\06menu' /v Icon /t REG_SZ /d 'powercpl.dll' /f",
    "reg add 'HKCR\DesktopBackground\Shell\PowerPlan\shell\06menu' /v "" /t REG_SZ /d 'powercfg.exe /setactive 1e5d685f-1f5e-45fa-a75b-7c8d1d03036e' /f"

)

# Run all registry commands
$combinedRegistryCommand = $commands -join " & "
Run-AsAdmin -Command $combinedRegistryCommand

# Final message
Write-Host "✅ System customized: search button hidden, apps unpinned, time zone set, language updated, and registry settings applied."

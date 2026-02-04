winget install --id Microsoft.WindowsTerminal
winget install --id Microsoft.Powershell
wsl --install
winget install --id Git.Git
winget install --id Rustdesk.Rustdesk
winget install --id Brave.Brave
winget install --id Microsoft.VisualStudioCode
winget install --id Microsoft.DSC
winget install --id Anthropic.ClaudeCode
winget install --id OpenAI.Codex
dsc config set --document oh-my-posh-setup.yaml

# Install Nerd Fonts via Oh My Posh
oh-my-posh font install 0xProto
oh-my-posh font install JetBrainsMono
oh-my-posh font install FiraCode

# Configure Windows Terminal default font
$wtSettings = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path $wtSettings) {
    $settings = Get-Content $wtSettings -Raw | ConvertFrom-Json
    if (-not $settings.profiles.defaults) {
        $settings.profiles | Add-Member -NotePropertyName 'defaults' -NotePropertyValue @{} -Force
    }
    $settings.profiles.defaults | Add-Member -NotePropertyName 'font' -NotePropertyValue @{ face = "0xProto Nerd Font" } -Force
    $settings | ConvertTo-Json -Depth 10 | Set-Content $wtSettings
}

# Configure VS Code font
$vscodeSettings = "$env:APPDATA\Code\User\settings.json"
$dir = Split-Path $vscodeSettings
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force }
if (Test-Path $vscodeSettings) {
    $vsSettings = Get-Content $vscodeSettings -Raw | ConvertFrom-Json
} else {
    $vsSettings = [PSCustomObject]@{}
}
$vsSettings | Add-Member -NotePropertyName 'editor.fontFamily' -NotePropertyValue "'0xProto Nerd Font', 'JetBrainsMono Nerd Font', Consolas, monospace" -Force
$vsSettings | Add-Member -NotePropertyName 'editor.fontLigatures' -NotePropertyValue $true -Force
$vsSettings | Add-Member -NotePropertyName 'terminal.integrated.fontFamily' -NotePropertyValue "'0xProto Nerd Font'" -Force
$vsSettings | ConvertTo-Json -Depth 10 | Set-Content $vscodeSettings
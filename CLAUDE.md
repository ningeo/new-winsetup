# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Windows development environment bootstrap project. It automates setting up a fresh Windows machine with development tools using **winget** (Windows Package Manager) and **Windows DSC v3** (Desired State Configuration).

## How It Works

1. `bootstrap.ps1` — PowerShell script that installs core tools via `winget install` (Windows Terminal, PowerShell, WSL, Git, VS Code, DSC, etc.), then applies the DSC configuration.
2. `oh-my-posh-setup.yaml` — DSC v3 configuration document that installs Oh My Posh and configures it for both PowerShell and Bash shells.

## Running

Run `bootstrap.ps1` in an elevated PowerShell session:

```powershell
powershell -ExecutionPolicy Bypass -File bootstrap.ps1
```

The script calls `dsc config set --document oh-my-posh-setup.yaml` at the end to apply the DSC configuration.

## Key Technologies

- **winget**: Handles all package installations
- **Windows DSC v3**: Declarative configuration via YAML (`$schema` references the DSC v3 config schema)
- **Oh My Posh**: Terminal prompt theming, configured through DSC resources (`OhMyPosh/Config` and `OhMyPosh/Shell`)

## Notes

- Line 1 of `bootstrap.ps1` has a missing dot in `Microsoft WindowsTerminal` (should be `Microsoft.WindowsTerminal`).

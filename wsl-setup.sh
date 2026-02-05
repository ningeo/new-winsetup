#!/bin/bash
set -e

# Install Oh My Posh
curl -s https://ohmyposh.dev/install.sh | bash -s

# Copy theme file
OMP_DIR="$HOME/.config/oh-my-posh"
mkdir -p "$OMP_DIR"

# Resolve the Windows-side repo path via /mnt
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cp "$SCRIPT_DIR/bashtheme.omp.json" "$OMP_DIR/bashtheme.omp.json"

# Ensure ~/.profile sources .bashrc AFTER adding local bin paths to PATH,
# otherwise oh-my-posh (installed to ~/.local/bin) won't be found.
if [ -f "$HOME/.profile" ]; then
    # Check if .bashrc sourcing block exists and isn't already at the end
    if grep -qF 'BASH_VERSION' "$HOME/.profile"; then
        # Remove the bashrc sourcing block
        sed -i '/# if running bash/,/^fi$/d' "$HOME/.profile"
        # Remove any trailing blank lines
        sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$HOME/.profile"
        # Re-append it at the end
        cat >> "$HOME/.profile" << 'PROFILE'

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi
PROFILE
        echo "Moved .bashrc sourcing to end of ~/.profile"
    fi
fi

# Add oh-my-posh init to .bashrc if not already present
OMP_INIT='eval "$(oh-my-posh init bash --config ~/.config/oh-my-posh/bashtheme.omp.json)"'
if ! grep -qF 'oh-my-posh init bash' "$HOME/.bashrc"; then
    printf '\n%s\n' "$OMP_INIT" >> "$HOME/.bashrc"
    echo "Added oh-my-posh init to ~/.bashrc"
else
    echo "oh-my-posh init already in ~/.bashrc"
fi

# Add ssh-agent start block to .bashrc if not already present
if ! grep -qF 'Start ssh-agent and set environment variables' "$HOME/.bashrc"; then
    cat >> "$HOME/.bashrc" << 'SSHAGENT'

# Start ssh-agent and set environment variables
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)"
fi
SSHAGENT
    echo "Added ssh-agent starter to ~/.bashrc"
else
    echo "ssh-agent starter already in ~/.bashrc"
fi

echo "Done. Restart your shell or run: source ~/.bashrc"

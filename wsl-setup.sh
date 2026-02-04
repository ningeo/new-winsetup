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

# Add oh-my-posh init to .bashrc if not already present
OMP_INIT='eval "$(oh-my-posh init bash --config ~/.config/oh-my-posh/bashtheme.omp.json)"'
if ! grep -qF 'oh-my-posh init bash' "$HOME/.bashrc"; then
    printf '\n%s\n' "$OMP_INIT" >> "$HOME/.bashrc"
    echo "Added oh-my-posh init to ~/.bashrc"
else
    echo "oh-my-posh init already in ~/.bashrc"
fi

echo "Done. Restart your shell or run: source ~/.bashrc"

#!/usr/bin/env bash
# Cloud Agent bootstrap for the Le Wagon dotfiles.
# Installs the prerequisites the repo's own install.sh expects (zsh + oh-my-zsh),
# then runs it to symlink the dotfiles and install the zsh plugins.
set -euo pipefail

# 1. Ensure zsh is available (the dotfiles install.sh uses `#!/bin/zsh`).
if ! command -v zsh >/dev/null 2>&1; then
  echo "-----> Installing zsh"
  sudo apt-get update
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y zsh
fi

# 2. Ensure oh-my-zsh is installed (sourced by the repo's zshrc). Unattended so
#    it does not launch a shell, change the login shell, or overwrite .zshrc.
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "-----> Installing oh-my-zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# 3. The dotfiles install.sh symlinks VS Code settings into this dir on Linux
#    servers; create it up front so the symlink step succeeds headlessly.
mkdir -p "$HOME/.vscode-server/data/Machine"

# 4. Run the repository's own installer (idempotent: it skips existing symlinks
#    and already-cloned plugins). This is the core action of this repo.
echo "-----> Running the dotfiles install.sh"
zsh ./install.sh

echo "-----> Dotfiles environment ready"

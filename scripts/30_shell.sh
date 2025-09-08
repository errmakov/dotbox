#!/usr/bin/env bash
set -euo pipefail

ZRC="$HOME/.zshrc"
BREW_BIN="$([ "$(uname -m)" = "arm64" ] && echo /opt/homebrew/bin || echo /usr/local/bin)"

# Add brew shellenv line once
if ! grep -q 'brew shellenv' "$ZRC" 2>/dev/null; then
  {
    echo ''
    echo '# Homebrew environment'
    echo "eval \"\$($BREW_BIN/brew shellenv)\""
  } >> "$ZRC"
fi

# Ensure ~/.local/bin is first and unique (zsh-idiomatic)
if ! grep -q 'typeset -U path PATH' "$ZRC" 2>/dev/null; then
  {
    echo ''
    echo '# dotbox PATH (unique)'
    echo 'typeset -U path PATH'
    echo 'path=("$HOME/.local/bin" $path)'
    echo 'export PATH'
  } >> "$ZRC"
fi


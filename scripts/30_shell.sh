#!/usr/bin/env bash
set -euo pipefail

ZRC="$HOME/.zshrc"
ARCH="$(uname -m)"
BREW_PREFIX="$([ "$ARCH" = "arm64" ] && echo /opt/homebrew || echo /usr/local)"
BREW_BIN="$BREW_PREFIX/bin/brew"

is_managed_by_chezmoi() {
  command -v chezmoi >/dev/null 2>&1 || return 1
  # exit 0 if managed, 1 if not
  chezmoi managed -i "$ZRC" >/dev/null 2>&1
}

if is_managed_by_chezmoi; then
  cat <<'MSG'
⚠️  .zshrc is managed by chezmoi. Not modifying the live file.

Next steps:
  1) Edit the chezmoi source:
       cme ~/.zshrc
     (or edit dot_zshrc.tmpl directly)
  2) Ensure these blocks exist in the template:

     # Unique PATH handling (zsh-friendly)
     typeset -U path PATH
     path=("$HOME/.local/bin" $path)
     export PATH

     # Homebrew environment (macOS)
     {{ if (eq .chezmoi.os "darwin") -}}
     eval "$({{ if (eq .chezmoi.arch "arm64") }}/opt/homebrew{{ else }}/usr/local{{ end }}/bin/brew shellenv)"
     {{- end }}

  3) Apply & commit:
       chezmoi apply ~/.zshrc
       chezmoi git add .
       chezmoi git commit -m "Update .zshrc PATH and brew shellenv"
       chezmoi git push
MSG
  exit 0
fi

# Fallback: if not chezmoi-managed, ensure sane defaults once (idempotent)
touch "$ZRC"

# Add Homebrew shellenv once
if ! grep -q 'brew shellenv' "$ZRC"; then
  {
    echo ''
    echo '# Homebrew environment (added by bootstrap)'
    echo "eval \"\$($BREW_BIN shellenv)\""
  } >> "$ZRC"
fi

# Add ~/.local/bin to PATH once, uniquely (zsh idiom)
if ! grep -q 'typeset -U path PATH' "$ZRC"; then
  {
    echo ''
    echo '# dotbox PATH (unique)'
    echo 'typeset -U path PATH'
    echo 'path=("$HOME/.local/bin" $path)'
    echo 'export PATH'
  } >> "$ZRC"
fi

echo "✅ Updated $ZRC (non-chezmoi). Run: exec zsh"


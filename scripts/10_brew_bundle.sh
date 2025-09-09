#!/usr/bin/env bash
set -euo pipefail
eval "$($(uname -m | grep -q arm64 && echo /opt/homebrew/bin/brew || echo /usr/local/bin/brew) shellenv)"
brew update
brew bundle --file="$(git rev-parse --show-toplevel)/Brewfile"


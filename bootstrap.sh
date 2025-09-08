#!/usr/bin/env bash
set -euo pipefail

# Repo root (supports running from curl | bash)
REPO="${REPO:-$HOME/.dotbox}"
if [[ ! -d "$REPO" ]]; then
  git clone --depth=1 https://github.com/errmakov/dotbox.git "$REPO"
fi

cd "$REPO"
chmod +x scripts/*.sh

# Run pieces; each script is idempotent and safe to re-run
#scripts/00_macos_prereqs.sh
#scripts/10_brew_bundle.sh
scripts/20_bins.sh
#scripts/30_shell.sh
#scripts/40_devtools.sh
#scripts/50_security.sh   # comment out if you’ll wire later
#scripts/60_dotfiles.sh
#scripts/90_finish.sh


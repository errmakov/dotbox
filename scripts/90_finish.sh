#!/usr/bin/env bash
set -euo pipefail

echo "✅ Base setup complete."

# Sanity check: Python
PY=$(which python3)
if [[ "$PY" == "/usr/bin/python3" ]]; then
  echo "⚠️  Still using system Python ($PY). Check Brewfile or PATH ordering."
else
  echo "🐍 Using Homebrew Python: $PY ($(python3 --version 2>&1))"
fi

# Sanity check: yt-dlp
if command -v yt-dlp >/dev/null; then
  echo "🎬 yt-dlp installed → $(yt-dlp --version | head -n1)"
else
  echo "❌ yt-dlp not found on PATH"
fi

echo ""
echo "👉 Next steps:"
echo "   - Run 'exec zsh' to reload your shell if you haven’t yet"
echo "   - Commit chezmoi changes if you edited dotfiles manually"


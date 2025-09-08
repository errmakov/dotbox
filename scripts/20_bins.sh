#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

echo "⬇️ Installing yt-dlp..."
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
  -o "$BIN_DIR/yt-dlp"
chmod +x "$BIN_DIR/yt-dlp"

# remove quarantine flag so Gatekeeper doesn’t nag
xattr -d com.apple.quarantine "$BIN_DIR/yt-dlp" 2>/dev/null || true


#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

echo "⬇️ Fetching yt-dlp (official macOS binary + verification)..."

TMP="$(mktemp -d)"
cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

# 1) Import yt-dlp release signing key (idempotent)
curl -fsSL https://raw.githubusercontent.com/yt-dlp/yt-dlp/master/public.key | gpg --import - >/dev/null 2>&1 || true

# 2) Get sums + signatures from the latest release
curl -fsSL -o "$TMP/SHA2-256SUMS"     https://github.com/yt-dlp/yt-dlp/releases/latest/download/SHA2-256SUMS
curl -fsSL -o "$TMP/SHA2-256SUMS.sig" https://github.com/yt-dlp/yt-dlp/releases/latest/download/SHA2-256SUMS.sig

# 3) Verify sums file
gpg --verify "$TMP/SHA2-256SUMS.sig" "$TMP/SHA2-256SUMS"

# 4) Download the recommended macOS universal binary
curl -fsSL -o "$TMP/yt-dlp_macos" https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_macos

# 5) Check its SHA256 against the verified sums
(cd "$TMP" && shasum -a 256 -c <(grep ' yt-dlp_macos$' "$TMP/SHA2-256SUMS"))

# 6) Install
install -m 0755 "$TMP/yt-dlp_macos" "$BIN_DIR/yt-dlp"

# 7) Clear quarantine (nice-to-have)
xattr -d com.apple.quarantine "$BIN_DIR/yt-dlp" 2>/dev/null || true

echo "✅ yt-dlp installed → $("$BIN_DIR/yt-dlp" --version | head -n1)"


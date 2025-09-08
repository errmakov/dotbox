#!/usr/bin/env bash
set -euo pipefail

echo "✅ Base setup complete."

echo ""
echo "👉 Next steps:"
echo "   1) Reload your shell:   exec zsh"
echo "   2) Capture changes in chezmoi:"
echo "        chezmoi re-add ~/.zshrc"
echo "        chezmoi git add ~/.zshrc.tmpl"
echo "        chezmoi git commit -m 'Update zshrc from bootstrap'"
echo "        chezmoi git push"


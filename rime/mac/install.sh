#!/usr/bin/env bash
set -euo pipefail

RIME_DIR="${RIME_DIR:-$HOME/Library/Rime}"
BACKUP_DIR="$HOME/Library/Rime.backup.$(date +%Y%m%d-%H%M%S)"

echo "Backup current Rime config..."
if [ -d "$RIME_DIR" ]; then
	cp -a "$RIME_DIR" "$BACKUP_DIR"
fi

echo "Install or update plum..."
if [ ! -d "$HOME/plum" ]; then
	git clone https://github.com/rime/plum.git "$HOME/plum"
fi

echo "Install rime-ice..."
cd "$HOME/plum"
bash rime-install iDvel/rime-ice
bash rime-install iDvel/rime-ice:others/recipes/config:schema=double_pinyin_flypy

echo "Apply personal config..."
cd -
mkdir -p "$RIME_DIR"
rsync -av \
	--exclude ".git" \
	--exclude "install.sh" \
	./ "$RIME_DIR/"

echo "Done. Now redeploy Rime from Squirrel menu."

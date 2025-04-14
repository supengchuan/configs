#!/bin/bash

if [ -d ./out ]; then
	rm -rf out
fi

mkdir -p out/config
mkdir -p out/data

cp -r ~/.config/nvim out/config/
cp -r ~/.local/share/nvim out/data/

cat << EOF > out/move.sh
#!/bin/bash

rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim

mv config/nvim ~/.config/
mv data/nvim ~/.local/share/

EOF

cat << "EOF" > out/update_links.sh
#!/bin/bash

set -euo pipefail

OLD_DIR="${1:-/home/supc}"
NEW_DIR="${2:-/root}"

if [[ -z "$OLD_DIR" || -z "$NEW_DIR" ]]; then
	echo "Usage: $0 OLD_DIR NEW_DIR"
	exit 1
fi

for link in *; do
	echo "$link"
	if [ -L "$link" ] && [ ! -d "$link" ]; then
		current_target=$(readlink "$link")
		echo "$current_target "
		echo "$OLD_DIR"
		if [[ "$current_target" == "$OLD_DIR"* ]]; then
			new_target="${current_target/#$OLD_DIR/$NEW_DIR}"

			echo "Updating $link:"
			echo "  old -> $current_target"
			echo "  new -> $new_target"

			rm "$link"
			ln -s "$new_target" "$link"
		else
			echo "not matched "
		fi
	fi
done
EOF

chmod +x out/move.sh out/update_links.sh
tar -zcf out.tar.gz out
rm -rf out

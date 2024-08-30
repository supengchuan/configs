#!/bin/bash

if [ -d ./out ]; then
	rm -rf out
fi

mkdir -p out/config
mkdir -p out/data

cp -r ~/.config/nvim out/config/
cp -r ~/.local/share/nvim out/data/

if [ -f /usr/local/bin/rust-analyzer ]; then
	sudo cp /usr/local/bin/rust-analyzer out/rust-analyzer
fi

cat <<EOF >out/move.sh
#!/bin/bash

rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim

mv config/nvim ~/.config/
mv data/nvim ~/.local/share/
if [ -f rust-analyzer ]; then
	sudo mv rust-analyzer /usr/local/bin/
fi

EOF

cat <<"EOF" >out/update_links.sh
#!/bin/bash

# Define the old and new user
OLD_DIR=""
NEW_DIR=""

# Loop through all symbolic links in the current directory
for link in *; do
	# Check if it is a symbolic link
	if [ -L "$link" ]; then
		# Get the current target of the symbolic link
		current_target=$(readlink "$link")

		echo "$current_target"
		# Check if the target contains the old directory path
		if [[ "$current_target" == "$OLD_DIR"* ]]; then
			# Replace the old directory path with the new directory path
			new_target=${current_target//$OLD_DIR/$NEW_DIR}

			# Remove the old symbolic link
			rm "$link"

			# Create a new symbolic link with the updated target
			ln -s "$new_target" "$link"

			echo "Updated $link -> $new_target"
		fi
	fi
done
EOF

chmod +x out/move.sh out/update_links.sh
tar -zcvf out.tar.gz out
rm -rf out

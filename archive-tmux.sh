#!/bin/bash

if [ -d ./tmux-out ]; then
	rm -rf tmux-out
fi

mkdir tmux-out

sudo cp /usr/local/bin/tmux.appimage ./tmux-out/ 
cp -Lr ~/.tmux.conf ./tmux-out/
cp -r ~/.config/tmux/ ./tmux-out/
cp -r ~/.tmux/ ./tmux-out

cat <<EOF >./tmux-out/move.sh
#!/bin/bash

rm -rf ~/.tmux
rm -rf ~/.tmux.conf
rm -rf ~/.config/tmux

mkdir -p ~/.config/
mv ./tmux ~/.config/tmux/
mv ./.tmux ~/
mv ./.tmux.conf ~/
EOF

chmod +x ./tmux-out/move.sh

tar -zcf tmux-out.tar.gz tmux-out

rm -rf tmux-out


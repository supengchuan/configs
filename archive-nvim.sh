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

cat << EOF > out/move.sh
#!/bin/bash

rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim

mv config/nvim ~/.config/
mv data/nvim ~/.local/share/
if [ -f rust-analyzer ]; then
	sudo mv rust-analyzer /usr/local/bin/
fi

EOF

chmod +x out/move.sh
tar -zcvf out.tar.gz out
rm -rf out

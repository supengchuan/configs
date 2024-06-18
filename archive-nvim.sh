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

tar -zxvf out.tar.gz
cd out
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim

mv config/nvim ~/.config/
mv data/nvim ~/.local/share/

EOF

chmod +x out/move.sh
tar -zcvf out.tar.gz out
rm -rf out

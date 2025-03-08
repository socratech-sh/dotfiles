# Check if neovim exists if not download it and set the the necessary values 
## ln -s "$HOME/dotfiles/starship.toml" "$HOME/.config/starhip.toml"
if ! nvim -v &> /dev/null 
then
	echo "You don't have neovim"
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
	sudo rm -rf /opt/nvim
	sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
	rm -rf nvim-linux-x86_64.tar.gz
	echo 'PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.bashrc 
	source ~/.bashrc
	echo "Neovim's been successfully installed" 
fi 

if [ ! -L "$HOME/.config/nvim" ]; then
	echo "Creating sym link for neovim"
	ln -s "$(pwd)/nvim" "$HOME/.config/nvim"
fi

if ! rg --version &> /dev/null
then
	echo "installing ripgrep"
	curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb
	sudo dpkg -i ripgrep_14.1.0-1_amd64.deb
	echo "Ripgrep's been successfully installed"
fi

if ! cat ~/.bashrc | grep starship &> /dev/null
then
	echo "Starship is not installed"
	curl -sS https://starship.rs/install.sh | sh
	rf -rf ripgrep_14.1.0-1_amd64.deb
	echo "starship installed"
	echo 'eval "$(starship init bash)"' >> ~/.bashrc
fi

sudo mkdir -p /usr/share/fonts
sudo ln -s "$HOME/dotfiles/fonts/MonoLisaNerdFont-Regular.ttf" "/usr/share/fonts/MonoLisaNerdFont-Regular.ttf" \
sudo ln -s "$HOME/dotfiles/fonts/MonoLisaNerdFont-Bold.ttf" "/usr/share/fonts/MonoLisaNerdFont-Bold.ttf" &> /dev/null

echo "Check if starship exists"
if [ ! -L "$HOME/.config/starship.toml" ]; then
	ln -s "$HOME/dotfiles/starship.toml" "$HOME/.config/starship.toml"
	echo "Sym link for starship has been created"
	echo "STARSHIP_CONFIG=$HOME/.config/starship.toml" >> ~/.bashrc
fi

echo "Checking if zig 0.13 is installed"
if ! zig version &> /dev/null; then
    curl -LO https://ziglang.org/download/0.13.0/zig-linux-x86_64-0.13.0.tar.xz
    tar xvf zig-linux-x86_64-0.13.0.tar.xz
    rm -rf zig-linux-x86_64-0.13.0.tar.xz
    mv zig-linux-x86_64-0.13.0 "$HOME/zig"
    sudo ln -s "$HOME/zig/zig" /usr/bin/zig
    sudo apt install libgtk-4-dev libadwaita-1-dev git blueprint-compiler
    git clone https://github.com/ghostty-org/ghostty 
    cd ghostty
    zig build -Doptimize=ReleaseFast
    sudo mv ./ghostty/zig-out/bin/ghostty /usr/bin/
    cd ../
    rm -rf ghostty
    ln -s  "$HOME/dotfiles/ghostty_config" "$HOME/.config/ghostty"
fi


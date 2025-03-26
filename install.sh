
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
	sudo pacman -S ripgrep
	echo "Ripgrep's been successfully installed"
fi

if ! cat ~/.bashrc | grep starship &> /dev/null
then
	echo "Starship is not installed"
	curl -sS https://starship.rs/install.sh | sh
	echo "starship installed"
	echo 'eval "$(starship init bash)"' >> ~/.bashrc
fi

sudo mkdir -p /usr/share/fonts
sudo ln -s "$HOME/dotfiles/fonts/MonoLisaNerdFont-Regular.ttf" "/usr/share/fonts/MonoLisaNerdFont-Regular.ttf" \
sudo ln -s "$HOME/dotfiles/fonts/MonoLisaNerdFont-Bold.ttf" "/usr/share/fonts/MonoLisaNerdFont-Bold.ttf" &> /dev/null

echo "Check if starship config exists"
if [ ! -L "$HOME/.config/starship.toml" ]; then
	ln -s "$HOME/dotfiles/starship.toml" "$HOME/.config/starship.toml"
	echo "Sym link for starship has been created"
	echo "STARSHIP_CONFIG=$HOME/.config/starship.toml" >> ~/.bashrc
fi

echo "Checking if zig 0.13 is installed"
if [ ! -L ~/.config/ghostty ]; then
    ln -s  "$HOME/dotfiles/ghostty_config" "$HOME/.config/ghostty"
fi


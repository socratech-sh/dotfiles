echo "Installing fonts"
sudo mkdir -p /usr/share/fonts
sudo ln -s "$HOME/dotfiles/fonts/MonoLisaNerdFont-Regular.ttf" "/usr/share/fonts/MonoLisaNerdFont-Regular.ttf" \
sudo ln -s "$HOME/dotfiles/fonts/MonoLisaNerdFont-Bold.ttf" "/usr/share/fonts/MonoLisaNerdFont-Bold.ttf" &> /dev/null

if ! ghostty --version &> /dev/null
then
	echo "Installing ghostty"
	sudo ln -s "$HOME/dotfiles/ghostty_config" "$HOME/.config/ghostty"
	echo 'export PS1="\[\e[38;5;35m\]╭─\[\e[m\]\[\e[38;5;35m\](\[\e[m\]\[\e[38;5;38m\]\A\[
e[m\]\[\e[38;5;35m\]-\[\e[m\]\[\e[38;5;35m\](\[\e[m\]\[\e[38;5;38m\]\j\[\e[m\]\[
e[38;5;35m\]-\[\e[m\]\[\e[38;5;35m\](\[\e[m\]\[\e[38;5;38m\]\H\[\e[m\]\[\e[38;5;
5m\]-\[\e[m\]\[\e[38;5;35m\](\[\e[m\]\[\e[38;5;38m\]\w\[\e[m\]\[\e[38;5;35m\])\[
─ |\[\e[m\] "' >> ~/.bashrc
	pacman -S ghostty
	source ~/.bashrc
	echo "Ghostty has been succesfully installed"
fi

if ! Hyprland --version
then
	echo "Installing Hyperland"
	sudo ln -s "$HOME/dotfiles/hypr" "$HOME/.config/hypr"
	sudo pacman -S hyprland uwsm
	
	echo "if uwsm check may-start; then
		exec uwsm start hyprland-uwsm.desktop
	fi" >> ~/.bashrc
fi

if ! rg --version &> /dev/null
then
	echo "installing ripgrep"
	sudo pacman -S ripgrep
	echo "Ripgrep's been successfully installed"
fi

if ! emacs --version &> /dev/null
then
	echo "Installing emacs"
	pacman -S emacs
	sudo ln -s "$HOME/dotfiles/hypr" "$HOME/.config/doom"
	git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
	~/.config/emacs/bin/doom install
	doom sync
fi

if ! firefox --version
then
	echo "Downloading Firefox installing it depends on you"
	curl --location "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US" --output Firefox.tar.bz2
fi

echo "Installing missing dependecies"
sudo pacman -S --needed - < pacman.txt

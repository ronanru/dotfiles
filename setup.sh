#!/bin/bash
sudo -v

sudo pacman -S --noconfirm --needed dialog >/dev/null 2>&1

install_essentials() {
  sudo pacman -Syu --noconfirm
  sudo pacman -S --noconfirm --needed base-devel git

  if ! command -v paru &>/dev/null; then
    current_dir=$(pwd)

    mkdir -p /tmp/paru-install
    cd /tmp/paru-install
    git clone https://aur.archlinux.org/paru-bin.git
    cd paru-bin
    makepkg -si --noconfirm
    cd "$current_dir"
    rm -rf /tmp/paru-install
  fi

  paru -S --noconfirm --needed \
    man-db \
    flatpak \
    gnu-netcat \
    htop \
    btop \
    curl \
    wget \
    mpv \
    yt-dlp \
    wl-clipboard \
    tldr \
    noto-fonts-emoji \
    noto-fonts-cjk \
    noto-fonts \
    chromium \
    brave-bin \
    libreoffice-fresh \
    mullvad-vpn-bin \
    ttf-cascadia-code-nerd \
    ttf-cascadia-code \
    ttf-ubuntu-font-family \
    papirus-icon-theme \
    adw-gtk3 \
    pipewire \
    pipewire-pulse \
    pipewire-jack \
    pipewire-alsa \
    wireplumber \
    xdg-desktop-portal \
    xdg-desktop-portal-gtk \
    qt6-wayland \
    qt5-wayland

  sudo sed -i 's/#Color/Color\nILoveCandy/' /etc/pacman.conf
  sudo sed -i 's/#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
  sudo sed -i 's/#BottomUp/BottomUp/' /etc/paru.conf

  xdg-settings set default-web-browser brave-browser.desktop
  xdg-mime default org.gnome.Nautilus.desktop inode/directory

  gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3-dark"
  gsettings set org.gnome.desktop.interface font-name "Ubuntu 11"
  gsettings set org.gnome.desktop.interface document-font-name "Ubuntu 11"
  gsettings set org.gnome.desktop.interface monospace-font-name "Cascadia Code Regular 11"
  gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
  gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
}

install_shell_config() {
  paru -S --noconfirm --needed \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    starship \
    exa \
    tmux \
    fzf \
    ripgrep \
    fd \
    bat \
    zoxide \
    neofetch \
    pfetch-rs-bin \
    alacritty \
    atuin

  mkdir ~/.config/alacritty
  cp ./configs/alacritty.yml ~/.config/alacritty/alacritty.yml
  cp ./configs/zshrc ~/.zshrc
  sudo chsh -s /bin/zsh $USER
}

install_programming_staff() {
  paru -Rncs --noconfirm rust
  paru -Rncs --noconfirm nodejs

  paru -S --noconfirm --needed \
    git \
    code \
    code-features \
    code-marketplace \
    neovim \
    rustup \
    nodejs-lts-hydrogen \
    pnpm \
    github-cli \
    lazygit \
    podman \
    bun-bin \
    datagrip \
    insomnia-bin \
    whois

  rustup default stable
  mkdir ~/Coding

  mkdir ~/.config/nvim
  cp ./configs/init.lua ~/.config/nvim/init.lua

  mkdir ~/.config/rustfmt
  cp ./configs/rustfmt.toml ~/.config/rustfmt/rustfmt.toml

  xdg-mime default org.gnome.Nautilus.desktop inode/directory

  pnpm i -g prettier typescript vercel cspell

  if [ "$USER" == "matvey" ]; then
    git config --global user.name "Matvey Ryabchikov"
    git config --global user.email "ronanru@users.noreply.github.com"
  fi
}

install_gaming_stuff() {
  sudo sed -i 's/#[multilib]/[multilib]/' /etc/pacman.conf
  sudo pacman -Sy --noconfirm
  paru -S --noconfirm --needed jre17-openjdk prismlauncher-qt5-bin steam linux-headers v4l2loopback-dkms
  flatpak install --noninteractive com.obsproject.Studio
}

install_gnome() {
  paru -S --noconfirm --needed \
    gnome \
    gnome-tweaks \
    file-roller \
    seahorse \
    gnome-shell-extension-pop-shell \
    gnome-shell-extension-pano \
    gnome-shell-extension-rounded-window-corners \
    gnome-shell-extension-blur-my-shell

  paru -Rncs --noconfirm gnome-contacts
  paru -Rncs --noconfirm gnome-weather
  paru -Rncs --noconfirm gnome-calendar
  paru -Rncs --noconfirm gnome-terminal
  paru -Rncs --noconfirm gnome-photos
  paru -Rncs --noconfirm gnome-maps
  paru -Rncs --noconfirm gnome-logs
  paru -Rncs --noconfirm totem
  paru -Rncs --noconfirm yelp
  paru -Rncs --noconfirm epiphany
  paru -Rncs --noconfirm cheese
  paru -Rncs --noconfirm simple-scan
  paru -Rncs --noconfirm gnome-text-editor
  paru -Rncs --noconfirm gnome-console
  paru -Rncs --noconfirm gnome-music
  paru -Rncs --noconfirm gnome-software
  paru -Rncs --noconfirm gnome-clocks
  paru -Rncs --noconfirm gnome-system-monitor
  paru -Rncs --noconfirm gnome-tour
  paru -Rncs --noconfirm gnome-connections

  gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ru')]"
  gsettings set org.gnome.desktop.input-sources xkb-options "['grp:alt_shift_toggle', 'grp:caps_toggle']"

  gnome-extensions enable pop-shell@system76.com
  gnome-extensions enable rounded-window-corners@yilozt
  gnome-extensions enable pano@elhan.io
  gnome-extensions enable blur-my-shell@aunetx

  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "alacritty"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Super>Return"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "alacritty"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name "nautilus"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding "<Super>e"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "nautilus"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name "brave"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding "<Super>b"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command "brave"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ name "code"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ binding "<Super>d"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ command "code"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-7 "['<Super>7']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-8 "['<Super>8']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-9 "['<Super>9']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-10 "['<Super>0']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1 "['<Super><Shift>1']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2 "['<Super><Shift>2']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3 "['<Super><Shift>3']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4 "['<Super><Shift>4']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5 "['<Super><Shift>5']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-6 "['<Super><Shift>6']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-7 "['<Super><Shift>7']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-8 "['<Super><Shift>8']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-9 "['<Super><Shift>9']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-10 "['<Super><Shift>0']"
  gsettings set org.gnome.shell.keybindings switch-to-application-1 "[]"
  gsettings set org.gnome.shell.keybindings switch-to-application-2 "[]"
  gsettings set org.gnome.shell.keybindings switch-to-application-3 "[]"
  gsettings set org.gnome.shell.keybindings switch-to-application-4 "[]"
  gsettings set org.gnome.shell.keybindings switch-to-application-5 "[]"
  gsettings set org.gnome.shell.keybindings switch-to-application-6 "[]"
  gsettings set org.gnome.shell.keybindings switch-to-application-7 "[]"
  gsettings set org.gnome.shell.keybindings switch-to-application-8 "[]"
  gsettings set org.gnome.shell.keybindings switch-to-application-9 "[]"
  gsettings set org.gnome.shell.keybindings toggle-message-tray "[]"
  gsettings set org.gnome.shell.extensions.pano global-shortcut "['<Super>v']"
  gsettings set org.gnome.shell.extensions.pano send-notifications-on-copy false
  gsettings set org.gnome.shell.extensions.blur-my-shell.panel blur false
  gsettings set org.gnome.shell.extensions.pop-shell active-hint true
  gsettings set org.gnome.shell.extensions.pop-shell active-hint-radius 16
  gsettings set org.gnome.shell.extensions.pop-shell hint-color-rgba "rgb(53,132,228)"
  gsettings set org.gnome.shell.extensions.pop-shell show-title false
  gsettings set org.gnome.shell.extensions.pop-shell smart-gaps true
  gsettings set org.gnome.shell.extensions.pop-shell stacking-with-mouse false
  gsettings set org.gnome.shell.extensions.pop-shell tile-by-default true
  gsettings set org.gnome.shell.extensions.pop-shell tile-enter "[]"
  gsettings set org.gnome.mutter center-new-windows true
  gsettings set org.gnome.mutter attach-modal-dialogs false
  gsettings set org.gnome.mutter edge-tiling false
  gsettings set org.gnome.mutter workspaces-only-on-primary true
  gsettings set org.gnome.desktop.wm.preferences focus-mode 'sloppy'
  gsettings set org.gnome.desktop.wm.preferences action-double-click-titlebar "none"
  gsettings set org.gnome.desktop.wm.preferences button-layout ":close"
  gsettings set org.gnome.desktop.media-handling autorun-never true
  gsettings set org.freedesktop.tracker.miner.files index-single-directories "[]"
  gsettings set org.freedesktop.tracker.miner.files index-recursive-directories "[]"
}

install_hyprland() {
  sudo pacman -S hyprland \
    xdg-desktop-portal-hyprland \
    waybar \
    polkit-gnome \
    cliphist \
    wofi \
    gdm \
    pavucontrol \
    grim \
    slurp \
    wl-clipboard \
    nautilus \
    jq

  sudo systemctl enable gdm
  cp -r ./configs/waybar ~/.config
  cp -r ./configs/hypr ~/.config
}

options=("gnome" "Install GNOME" on
  "hyprland" "Install Hyprland" on
  "terminal" "Install Terminal configuration" on
  "programming" "Install programming stuff" on
  "gaming" "Install games" on)

dialog_output=$(dialog --title "Choose the features" \
  --separate-output \
  --notags \
  --checklist "Select options using SPACE:" 20 78 7 \
  "${options[@]}" 2>&1 >/dev/tty)

selected_options=()
while read -r line; do
  selected_options+=("$line")
done <<<"$dialog_output"

install_essentials

for option in "${selected_options[@]}"; do
  case $option in
  "gnome")
    install_gnome
    ;;
  "hyprland")
    install_hyprland
    ;;
  "terminal")
    install_shell_config
    ;;
  "programming")
    install_programming_staff
    ;;
  "gaming")
    install_gaming_stuff
    ;;
  esac
done

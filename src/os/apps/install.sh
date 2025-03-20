#!/bin/bash

declare -r NODE_VERSION="20.13.1"

# Install packages
BREW_PACKAGES=(
    cloudfoundry-cli
    coreutils
    docker-compose
    fnm
    htop
    jq
    openssh
    yq
    zsh
    fzf
)

CASK_PACKAGES=(
    # IDEs
    visual-studio-code
    jetbrains-toolbox
    intellij-idea-ce
    webstorm
    dbeaver-community

    # window management
    rectangle
    raycast

    # browsers
    firefox
    google-chrome
    brave-browser
    arc

    # images
    gimp
    inkscape
    miro

    # tools
    docker
    obsidian
    onyx
    microsoft-teams

    # terminals
    warp
    ghostty
)

install_brew_package() {
    echo "Installing $1..."
    if brew install "$1" &>/dev/null; then
        print_succes "Installed $1"
    else
        print_error "⚠️ Failed to install $1. It might be already installed or there was an error."
    fi
}

# Function to install cask packages with error handling
install_cask_package() {
    echo "Installing $1..."
    if brew install --cask "$1" &>/dev/null; then
        print_succes "Installed $1"
    else
        print_error "⚠️ Failed to install $1. It might be already installed or there was an error."
    fi
}

echo "Installing brew packages..."
for package in "${BREW_PACKAGES[@]}"; do
    install_brew_package "$package"
done

# Install cask packages
echo "Installing cask packages..."
for package in "${CASK_PACKAGES[@]}"; do
    install_cask_package "$package"
done

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
# Clone the Oh My Zsh repository directly instead of using the installer script
git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

source "$ZSHRC"

if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)"
  print_success "Set Zsh as the default shell"
fi

fnm install $NODE_VERSION
fnm default $NODE_VERSION

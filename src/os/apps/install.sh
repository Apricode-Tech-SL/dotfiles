#!/bin/bash

# Install packages
BREW_PACKAGES=(
    coreutils
    docker-completion
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

    # images
    gimp
    inkscape
    miro

    # tools
    docker
    obsidian
    onyx

    # terminals
    warp
    ghostty
)

echo "Installing brew packages..."
brew install "${BREW_PACKAGES[@]}"

echo "Installing cask packages..."
brew install --cask "${CASK_PACKAGES[@]}"

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

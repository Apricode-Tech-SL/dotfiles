#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "utils.sh"


# Ensure Homebrew is installed
if ! command -v brew &>/dev/null; then
    print_in_yellow("Installing Homebrew...")
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

print_in_yellow("Updating Homebrew...")
brew update

# Install packages
BREW_PACKAGES=(
    docker
    docker-completion
)

CASK_PACKAGES=(
    visual-studio-code
    jetbrains-toolbox
    intellij-idea-ce
    rectangle
    raycast
    google-chrome
    firefox
    obsidian
)

echo "Installing brew packages..."
brew install "${BREW_PACKAGES[@]}"

echo "Installing cask packages..."
brew install --cask "${CASK_PACKAGES[@]}"

# Install oh-my-zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


# Install fnm (Fast Node Manager)
echo "Installing fnm..."
brew install fnm

# Configure p10k
echo "Configuring powerlevel10k..."
p10k configure

# Copy .gitconfig and gitignore to home directory
echo "Copying .gitconfig and .gitignore to home directory..."
cp -iV .gitconfig $HOME
cp -iV .gitignore $HOME


grep -qxF "ZSH_THEME=\"powerlevel10k/powerlevel10k\"" "$ZSHRC" || echo "ZSH_THEME=\"powerlevel10k/powerlevel10k\"" >> "$ZSHRC"
grep -qxF "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" "$ZSHRC" || echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$ZSHRC"
grep -qxF "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" "$ZSHRC" || echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> "$ZSHRC"

source "$ZSHRC"

# ask fot global git username and replace CHANGEME_GIT_NAME and CHANGEME_GIT_EMAIL with input in copied .gitconfig
echo "Enter your global git username:"
read GIT_USERNAME
sed -i '' "s/CHANGEME_GIT_NAME/$GIT_USERNAME/g" $HOME/.gitconfig

echo "Enter your global git email:"
read GIT_EMAIL
sed -i '' "s/CHANGEME_GIT_EMAIL/$GIT_EMAIL/g" $HOME/.gitconfig

print_in_yellow ".gitconfig" changed

print_in_green "macOS setup completed!"




echo "macOS setup completed!"

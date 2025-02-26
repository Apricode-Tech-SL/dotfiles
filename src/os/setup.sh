#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "utils.sh"


# Ensure Homebrew is installed
if ! command -v brew &>/dev/null; then
    print_in_purple " • Installing Homebrew...\n\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

print_in_purple "• Updating Homebrew...\n\n"
brew update

# Install packages
BREW_PACKAGES=(
    coreutils
    docker
    docker-completion
    fnm
    htop
    jq
    openssh
    yq
    zsh
)

CASK_PACKAGES=(
    # IDEs
    visual-studio-code
    jetbrains-toolbox
    intellij-idea-ce
    dbeaver-community

    # window management
    rectangle
    raycast

    # browsers
    firefox
    google-chrome

    # tools
    obsidian
    onyx

    # terminals
    warp
)

echo "Installing brew packages..."
brew install "${BREW_PACKAGES[@]}"

echo "Installing cask packages..."
brew install --cask "${CASK_PACKAGES[@]}"

# Install oh-my-zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Configure p10k
echo "Configuring powerlevel10k..."
p10k configure

# Copy .gitconfig and gitignore to home directory
print_in_purple "• Copying .gitconfig and .gitignore to home directory...\n\n"
cp -iV .gitconfig $HOME
cp -iV .gitignore $HOME


grep -qxF "ZSH_THEME=\"powerlevel10k/powerlevel10k\"" "$ZSHRC" || echo "ZSH_THEME=\"powerlevel10k/powerlevel10k\"" >> "$ZSHRC"
grep -qxF "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" "$ZSHRC" || echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$ZSHRC"
grep -qxF "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" "$ZSHRC" || echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> "$ZSHRC"

source "$ZSHRC"

# ask fot global git username and email
print_question "Enter your global git username:"
read GIT_USERNAME

print_question("Enter your global git email:")
read GIT_EMAIL

# Create .gitconfig.local with the [user] information 
./create_local_config_files.sh GIT_USERNAME GIT_EMAIL


print_success ".gitconfig.local created"

print_success "macOS setup completed!"



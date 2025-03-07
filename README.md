# dotfiles

This is a generic dotfiles repository to speed up the setup configuration of your MacOSX with default settings.

## Requirements

- [ ] Your apricodetech.com account created with access to Apricode team in GitHub
- [ ] Your Atlassian account created and access to BitBucket

> [!NOTE]
> The setup is not unattended, you will be required to confirm certain steps and require sudo privileges for installing apps

## Setup

```bash
bash -c "$(curl -LsS https://raw.github.com/Apricode-Tech-SL/dotfiles/main/src/os/setup.sh)"
```

That's all 🌈✨

Just follow the shell instructions

## Setup alternative

Clone the repository and run 

```bash
bash dotfiles/src/os/setup.sh
```

Follow the shell instructions


> [!CAUTION]
> This setup will install tools and applications that are commonly used by developers. If you don't want to install some of them, please remove the corresponding lines from the `apps/install.sh` script before running the setup script manually. Additionally, the setup will change some default macOS configurations.
> 
> If you want to customize the setup, you can fork this repository and modify the scripts to fit your needs.

- [ ] Development IDEs
  - [x] Visual Studio Code
  - [x] IntelliJ IDEA
  - [x] WebStorm
  - [x] DBEaver
- [ ] Launchers & window managers
  - [x] rectangle
  - [x] Raycast
- [ ] Browser
  - [x] Google Chrome
  - [x] Firefox
  - [x] Arc
  - [x] Brave
- [ ] Image editing
  - [x] GIMP
  - [x] Inkscape
- [ ] Communication
  - [x] Microsoft Teams
- [ ] Terminal
  - [x] Warp
  - [x] ghostty
  - [x] Oh My Zsh
  - [x] Powerlevel10k

## References

❤️ Inspired by a [curated list of dotfiles resources](https://github.com/webpro/awesome-dotfiles)

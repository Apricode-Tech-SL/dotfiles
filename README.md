# dotfiles

This is a generic dotfiles repository to speed up the setup configuration of your macos with default settings.

## Requirements

- [] git installed
- [] Your apricodetech.com account created and access to Apricode team in github
- [] 11teamsports.com account created and access to bitbucket

## Setup

### Private git repository SCENARIO

> ⚠️ This step could be automated with a public github repository

Start by configuring your git credentials and ssh key for Github

```bash
git config --global user.name "Monkey D. Luffy"
git config --global user.email "monkey.d.luffy@strawhatpirates.eb"
```

[Generate ssh key for Github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

```bash
mkdir ~/.ssh
ssh-keygen -t ed25519 -C "monkey.d.luffy@strawhatpirates.eb"
```

Copy the generated public ssh key into your [github account](https://github.com/settings/ssh/new)

```bash
pbcopy < ~/.ssh/generatedkey.pub
```

Clone the repository and run 

```bash
bash dotfiles/src/os/setup.sh
```

### Public git repository

```bash
bash -c "$(curl -LsS https://raw.github.com/Apricode-Tech-SL/dotfiles/main/src/os/setup.sh)"
```


That's all 🌈✨

Just follow the shell instructions


## TODO

- install macos stuff
  - ask for specific git username
  - ask for specifc git email
  - create .local files in home (ex. .gitignore.local)
  - install openssh, docker, docker-completion
  - 
- install specific development stuff (see project README.md)
  - fnm
  - nx   

## Override user specific settings using `.local` configurations


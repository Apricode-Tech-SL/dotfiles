#!/bin/bash

# -- Dotfiles repository --------------------------------------------------
declare -r GITHUB_REPOSITORY="Apricode-Tech-SL/dotfiles"
declare -r DOTFILES_ORIGIN="git@github.com:$GITHUB_REPOSITORY.git"
declare -r DOTFILES_TARBALL_URI="https://github.com/$GITHUB_REPOSITORY/tarball/main"
declare -r DOTFILES_UTILS_URI="https://raw.githubusercontent.com/$GITHUB_REPOSITORY/refs/heads/main/src/os/utils.sh"

declare dotfilesDirectory="$HOME/projects/dotfiles"
declare skipQuestions=false

declare BLACK='\033[38;2;0;0;0m'       # Almost black
declare ORANGE='\033[38;2;233;120;50m' # #E97832
declare BLUE='\033[38;2;147;247;238m'  # #93F7EE
declare LIGHT_ORANGE='\033[38;2;240;169;90m' # #F0A95A
declare LIGHT_BLUE='\033[38;2;147;247;238m'  # #93F7EE
declare RESET='\033[0m'                      # Reset color to default

declare RESET='\033[0m'                # Reset to default terminal color

# ----------------------------------------------------------------------
# | Helper Functions                                                   |
# ----------------------------------------------------------------------

print_logo() {

    echo -e ""
    echo -e ""
    echo -e "${ORANGE}                                                                    @@@@@@@@@@@@@                      @@@@@"
    echo -e "                                                            @@@@@@@@@@@@@@@@@@@@@@@@@@               @@@@@@@@@"
    echo -e "                                                        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@           @@@@@@@@@@"
    echo -e "                                                           @@@@@@@@@@@@@@@@@@@@@  @@@@@@@@        @@@@@@@@@             @@         @@"
    echo -e "                                                                @@@@@@@@@ @@@@@@@@@@  @@@@@      @@@@@@@               @@@         @@@"
    echo -e "                                                                  @@@@@@@@@   @@@@@@@@@  @@@    @@@@@@                            @@@@"
    echo -e "                                                                    @@@@@@@@@@@  @@@@@@@@  @    @@@@@           @@@@            @@@@@@@@@"
    echo -e "                                                                       @@@@@@@@@@@@  @@@@@@    @@@@@            @@@@         @@@@@@@@@@@@@@@"
    echo -e "                                                             @@@           @@@@@@@@@      @    @@@@                               @@@@@"
    echo -e "                                                @@   @@     @@@@@                              @@@                                 @@@"
    echo -e "                                                @@@@@@@     @@@@@             @@              @@@    @@@@@@@@@@@@@                 @@@"
    echo -e "                                                  @@@@                  @@@@@@@@@@@@@             @@@@@@@@@@@@@@@@@@@@              @"
    echo -e "                                                @@@@@@@            @@@@@@@@@@@@@@@@@@@@@        @@@@@@@@@@@@@@@@@@@@@@@@@@"
    echo -e "                                                @@   @@         @@@@@@@@@@@@@@@@@@@@@@@@@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@           @@@@"
    echo -e "                                                             @@@@@@@@@@@@@@@@@@ @@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@        @@@@"
    echo -e "                                                           @@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@  @@@@@@@@@@  @@@@@@@@@@@@@"
    echo -e "                                                          @@@@@@@@@@@@@@@@@ @@@@@@@@   @@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@           @@"
    echo -e "                                                        @@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@   @@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@        @@@@"
    echo -e "                                           @@@         @@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@   @@@@@@@@@ @@@@@@@@"
    echo -e "                                          @@@@@       @@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@"
    echo -e "                                           @@@       @@@@@@@@@@@@@@@@@@@@ @@@@ @@@@@@@@@@@@ @@@@@@@@@@@@  @@@@@@@@@@@@@@ @@@@@@@ @@@@@@@@"
    echo -e "                                                    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@ @@@@@@ @@@@@@@"
    echo -e "                                                   @@@@@@@@@@@@@@@@@@@@@ @@@@ @@@@@@@@@@@ @@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    echo -e "                                                   @@@@@@@@@@@@@@@@@@@@@ @@@@ @@@@@@@@@@  @@@@@@ @@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@      @@@"
    echo -e "                                                  @@@@@@@@@@@@ @@@@@@@@@ @@@@@@@@@@@@@@@ @@@@@@ @@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@ @@@@@@@     @@@@"
    echo -e "                                       @@@@      @@@@@@@@@@@@@@@@@@@@@@@ @@@@@ @@@@@@@@@ @@@@@@@@@@@       @@@@@@@@@@@ @@@@@@@@@@@@@ @@@@@@@"
    echo -e "                                       @@@@      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@ @@@@@@@@ @@@@@ @@@@@@ @@@@@@@"
    echo -e "                                                 @@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@ @@@@@@@@@@@@@@@"
    echo -e "                                                @@@@@@@ @@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@ @@@@@@ @@@@@@@@@@@@@@@@@@@@"
    echo -e "                                                @@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@@ @@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@"
    echo -e "                                                @@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@  @@@@@    @@@@@@@@@@@@ @@@@@ @@@@@@@@@@@ @@@@@@@@"
    echo -e "                                                @@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@   @@@@  @@@@ @@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@      @@@@"
    echo -e "                                                @@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@  @@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@     @@@@@"
    echo -e "                                                @@@@@@@@@ @@@@@@ @@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@       @@"
    echo -e "                                        @@@     @@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@ @@@@@@@ @@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    echo -e "                                       @@@@      @@        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@ @@@@@@ @@@@@@@@@@@            @@@@@@@@@"
    echo -e "                                                                 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@ @@@@@                        @@@@${RESET}"
    echo -e "${BLUE}                                                  @@@@@@@@@@@@       ${ORANGE}@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@  @         ${BLUE}@@@@@@@@@@@@@@@@${RESET}"
    echo -e "${BLUE}                                                  @@@@@@@@@@@@@@@@@     ${ORANGE}@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@        ${BLUE}@@@@@@@@@@@@@@@@@@@@@@@@@@${RESET}"
    echo -e "${BLUE}                                                   @@@@    @@@@@@@@@@@    ${ORANGE}@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     ${BLUE}@@@@@@@@@@@@@@@@@      @@@@@@@@${RESET}"
    echo -e "${BLUE}                                                   @@@@@@@@@@   @@@@@@@@@    ${ORANGE}@@@@@@@@@@@@@@@@@@@@@@@     ${BLUE}@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@${RESET}"
    echo -e "${BLUE}                                                    @@@@@@@@@@@@@   @@@@@@@@      ${ORANGE}@@@@@@@@@@@@@@       ${BLUE}@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@         @@@@${RESET}"
    echo -e "${BLUE}                                        @@@@          @@   @@@@@@@@@@  @@@@@@@@@@                   ${BLUE}@@@@@@@@@ @@@@@@@@@@@@   @@@@@     @          @@@@@${RESET}"
    echo -e "${BLUE}                                        @@@@          @@@@@@    @@@@@@@   @@@@@@@@@@@@            ${BLUE}@@@@@@@   @@@@@@@@   @@@@@@@@@@@@@@@             @@@${RESET}"
    echo -e "${BLUE}                                                       @@@@@@@@@   @@@@@@@   @@@@@@@@@@@@@@@  @@@@@@@@@  @@@@@@@@  @@@@@@@@@@@@@@@@@@@"
    echo -e "                                                          @@@@@@@@@@  @@@@@@@  @@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@ @@@@@@@@@@@@"
    echo -e "                                              @@@@@       @@@ @@@@@@@@@  @@@@@@@  @@@@@@@@@@@@@@@@  @@@@@@@@ @@@@@@@@@  @@@@@@@@@@@"
    echo -e "                                               @@@         @@@@@  @@@@@@@@  @@@@@@@ @@@@@@@@@@@@  @@@@@@@@ @@@@@@@@ @@@@@@@@@@@@@@"
    echo -e "                                                            @@@@@@@  @@@@@@@@ @@@@@@@@ @@@@@@@@@@@@@@@@@ @@@@@@@ @@@@@@@@@@"
    echo -e "                                                              @@@@@@@@  @@@@@@@  @@@@@@@@ @@@@@@@@@@@  @@@@@@  @@@@@@@@  @@@@@        @@@@@"
    echo -e "                                                                @@@@@@@@   @@@@@@@  @@@@@@@   @@@@@@@@@@@@@  @@@@@@@   @@@@@         @@@@@@@@"
    echo -e "                                                   @@@@@@         @@@@@@@@@   @@@@@@@  @@@@@@@  @@@@@@@@@  @@@@@@@  @@@@@@            @@@@@"
    echo -e "                                                    @@@@             @@@@@@@@@  @@@@@@@@ @@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@              @@ @@"
    echo -e "                                                                        @@@@@@@@@  @@@@@@@@ @@@@@@@@ @@@@@@@@@@@@@@@@"
    echo -e "                                                                           @@@@@@@@@@@@@@@@@@@ @@@@@@@@ @@@@@@@@@@"
    echo -e "                                                                                @@@@@@@@@@@@@@@   @@@@@@@  @@@"
    echo -e "                                                                                           @@@@${RESET}"
    echo -e ""
    echo -e ""
    echo -e ""
    echo -e "                                                                                                @@@@@             @@@@@"
    echo -e "                                     @@@          @@@@@@@@@@@@    @@@@@@@@@@@      @@@      @@@@@@@@@@@@@     @@@@@@@@@@@@@      @@@@@@@@@@@@@      @@@@@@@@@@@@@@"
    echo -e "                                    @@@@@         @@@@@@@@@@@@@@  @@@@@@@@@@@@@    @@@     @@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@    @@@@@@@@@@@@@@@    @@@@@@@@@@@@@@"
    echo -e "                                   @@@@@@@        @@@@      @@@@@ @@@@      @@@@   @@@    @@@@@@@    @@@@  @@@@@@@@    @@@@@@@   @@@@@@  @@@@@@@@@  @@@@@@"
    echo -e "                                   @@@@@@@@       @@@@       @@@@ @@@@      @@@@   @@@   @@@@@@        @   @@@@@@        @@@@@@  @@@@@@     @@@@@@  @@@@@@"
    echo -e "                                  @@@@ @@@@@      @@@@      @@@@@ @@@@      @@@@   @@@  @@@@@@            @@@@@           @@@@@@ @@@@@@      @@@@@@ @@@@@@@@@@@@"
    echo -e "                                 @@@@   @@@@@     @@@@@@@@@@@@@@  @@@@@@@@@@@@@    @@@  @@@@@             @@@@@           @@@@@@ @@@@@@      @@@@@@ @@@@@@@@@@@@"
    echo -e "                                @@@@     @@@@     @@@@@@@@@@@@    @@@@@@@@@@@      @@@  @@@@@@            @@@@@           @@@@@@ @@@@@@      @@@@@@ @@@@@@@@@@@@"
    echo -e "                               @@@@@      @@@@    @@@@            @@@@   @@@@      @@@   @@@@@@        @   @@@@@@        @@@@@@  @@@@@@     @@@@@@  @@@@@@"
    echo -e "                              @@@@@@@@@@@@@@@@@   @@@@            @@@@    @@@@@    @@@   @@@@@@@@    @@@@  @@@@@@@@   @@@@@@@@   @@@@@@ @@@@@@@@@@  @@@@@@"
    echo -e "                              @@@@         @@@@@  @@@@            @@@@     @@@@@   @@@     @@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@    @@@@@@@@@@@@@@@    @@@@@@@@@@@@@@"
    echo -e "                             @@@@           @@@@@ @@@@            @@@@       @@@@  @@@      @@@@@@@@@@@@@     @@@@@@@@@@@@@      @@@@@@@@@@@@@@     @@@@@@@@@@@@@@"
    echo -e "                                                                                                @@@@@@            @@@@@@"
    echo -e ""
    echo -e "                                                                                                         @@@@@@@@@@@   @@@@@@@@@@       @@@@@@@@      @@@@   @@@@"
    echo -e "                                                                                                         @@@@@@@@@@@   @@@@@@@@@@     @@@@@@@@@@@@   @@@@@   @@@@@"
    echo -e "                                                                                                            @@@@       @@@@@         @@@@@@   @@@    @@@@@   @@@@@"
    echo -e "                                                                                                            @@@@       @@@@@@@@@    @@@@@            @@@@@@@@@@@@@"
    echo -e "                                                                                                            @@@@       @@@@@@@@@    @@@@@            @@@@@@@@@@@@@"
    echo -e "                                                                                                            @@@@       @@@@@         @@@@@           @@@@@@@@@@@@@"
    echo -e "                                                                                                            @@@@       @@@@@@@@@@    @@@@@@@@@@@@@   @@@@@   @@@@@"
    echo -e "                                                                                                            @@@@       @@@@@@@@@@      @@@@@@@@@@@   @@@@@   @@@@@"
    echo -e ""
    echo -e ""
}

download() {

    local url="$1"
    local output="$2"

    if command -v "curl" &> /dev/null; then
        echo -e "downloading with curl ${url}"
        curl \
            --location \
            --verbose \
            --show-error \
            --output "$output" \
            "$url" \
                &> /dev/null

        return $?

    elif command -v "wget" &> /dev/null; then
        echo -e "downloading with wget ..."
        wget \
            --verbose \
            --output-document="$output" \
            "$url" \
                &> /dev/null

        return $?
    fi

    return 1

}

download_dotfiles() {

    local tmpFile=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_in_purple "\n • Download and extract archive\n\n"

    tmpFile="$(mktemp /tmp/XXXXX)"

    download "$DOTFILES_TARBALL_URI" "$tmpFile"
    print_result $? "Download archive" "true"
    printf "\n"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if ! $skipQuestions; then

        ask_for_confirmation "Do you want to store the dotfiles in '$dotfilesDirectory'?"

        if ! answer_is_yes; then
            dotfilesDirectory=""
            while [ -z "$dotfilesDirectory" ]; do
                ask "Please specify another location for the dotfiles (path): "
                dotfilesDirectory="$(get_answer)"
            done
        fi

        # Ensure the `dotfiles` directory is available
        while [ -e "$dotfilesDirectory" ]; do
            ask_for_confirmation "'$dotfilesDirectory' already exists, do you want to overwrite it?"
            if answer_is_yes; then
                rm -rf "$dotfilesDirectory"
                break
            else
                dotfilesDirectory=""
                while [ -z "$dotfilesDirectory" ]; do
                    ask "Please specify another location for the dotfiles (path): "
                    dotfilesDirectory="$(get_answer)"
                done
            fi
        done

        printf "\n"

    else

        rm -rf "$dotfilesDirectory" &> /dev/null

    fi

    mkdir -p "$dotfilesDirectory"
    print_result $? "Create '$dotfilesDirectory'" "true"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Extract archive in the `dotfiles` directory.

    extract "$tmpFile" "$dotfilesDirectory"
    print_result $? "Extract archive" "true"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    rm -rf "$tmpFile"
    print_result $? "Remove archive"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    cd "$dotfilesDirectory/src/os" \
        || return 1

}

download_utils() {

    local tmpFile=""

    tmpFile="$(mktemp /tmp/XXXXX)"

    echo -e "${LIGHT_BLUE} creating ${tmpFile} from ${DOTFILES_UTILS_URI} ${RESET}"
    download "$DOTFILES_UTILS_URI" "$tmpFile" \
        && . "$tmpFile" \
        && rm -rf "$tmpFile" \
        && return 0

   return 1

}

extract() {

    local archive="$1"
    local outputDir="$2"

    if command -v "tar" &> /dev/null; then

        tar \
            --extract \
            --gzip \
            --file "$archive" \
            --strip-components 1 \
            --directory "$outputDir"

        return $?
    fi

    return 1

}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

print_logo

echo -e "${ORANGE} -› Starting dotfiles setup ...${RESET}"

cd "$(dirname "${BASH_SOURCE[0]}")" 

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Load utils

echo -e "${BLUE}   -› checking utils.sh ...${RESET}"
if [ -x "utils.sh" ]; then
    . "utils.sh" || printf "  [✖] utils.sh not found\n" && exit 1
else
    download_utils || printf "  [✖] Error downloading utils.sh\n" && exit 1
fi

skip_questions "$@" && skipQuestions=true

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ask_for_sudo

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Check if this script was run directly (./<path>/setup.sh),
# and if not, it most likely means that the dotfiles were not
# yet set up, and they will need to be downloaded.

echo -e "${BLUE}   -› checking dotfiles project ...${RESET}"
printf "%s" "${BASH_SOURCE[0]}" | grep "setup.sh" &> /dev/null
    || download_dotfiles


cd "$(dirname "${BASH_SOURCE[0]}")" && . "utils.sh"

ask_for_confirmation "During the installation you will be asked for your name and email to configure the GIT. Do you want to continue?"
if ! answer_is_yes; then
    print_error "Please, run the script again when you are ready."
    exit 1
fi

ask "Please enter your name to create the GIT configuration: "
GIT_NAME="$(get_answer)"

ask "Please enter your Apricode Tech's email to create the GitHub configuration: "
GITHUB_EMAIL="$(get_answer)"

ask "Please enter your 11TS's email to create the BitBucket configuration: "
BITBUCKET_EMAIL="$(get_answer)"

print_in_purple "Your name is: $GIT_NAME" && printf "\n"
print_in_purple "Your GitHub's email is: $GITHUB_EMAIL" && printf "\n"
print_in_purple "Your BitBucket's email is: $BITBUCKET_EMAIL" && printf "\n"

# --- Install symlinks
./create_symlinks.sh "$@"

# --- Create local config files
./create_local_config_files.sh $GIT_NAME $GITHUB_EMAIL

# --- Install apps
./apps/install.sh

# Ensure Homebrew is installed
if ! cmd_exists "brew"; then
    print_in_purple " • Installing Homebrew...\n\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

print_in_purple "• Updating Homebrew...\n\n"
brew update

# --- MacOSX preferences
./preferences/main.sh

# --- Create ssh key
./set_github_ssh_key.sh $GIT_NAME $GITHUB_EMAIL
#./set_bitbucket_ssh_key.sh $GIT_NAME $BITBUCKET_EMAIL


print_success "🚀 macOS setup completed!"

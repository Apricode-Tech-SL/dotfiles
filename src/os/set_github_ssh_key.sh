#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

add_ssh_configs() {

    printf "%s\n" \
        "Host github.com" \
        "  IdentityFile $1" \
        "  LogLevel ERROR" >> ~/.ssh/config

    print_result $? "Add SSH configs"

}

copy_public_ssh_key_to_clipboard () {

    if cmd_exists "pbcopy"; then

        pbcopy < "$1"
        print_result $? "Copy public SSH key to clipboard"

    elif cmd_exists "xclip"; then

        xclip -selection clip < "$1"
        print_result $? "Copy public SSH key to clipboard"

    else
        print_warning "Please copy the public SSH key ($1) to clipboard"
    fi

}

generate_ssh_keys() {

    print_in_purple "Generating ssh key for ${GITHUB_EMAIL}:" && printf " \n"
    ssh-keygen -t ed25519 -C "${GITHUB_EMAIL}" -f "$1"

    print_result $? "Generate SSH keys"

}

open_github_ssh_page() {

    declare -r GITHUB_SSH_URL="https://github.com/settings/ssh"

    # The order of the following checks matters
    # as on Ubuntu there is also a utility called `open`.

    if cmd_exists "xdg-open"; then
        xdg-open "$GITHUB_SSH_URL"
    elif cmd_exists "open"; then
        open "$GITHUB_SSH_URL"
    else
        print_warning "Please add the public SSH key to GitHub ($GITHUB_SSH_URL)"
    fi

}

set_github_ssh_key() {

    local sshKeyFileName="$HOME/.ssh/github"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # If there is already a file with that
    # name, generate another, unique, file name.

    if [ -f "$sshKeyFileName" ]; then
        sshKeyFileName="$(mktemp -u "$HOME/.ssh/github_XXXXX")"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # if we cannot generate_ssh_keys, we cannot continue
    if ! generate_ssh_keys "$sshKeyFileName"; then
        print_error "SSH key generation failed"
        exit 1
    fi

    if ! add_ssh_configs "$sshKeyFileName"; then
        print_error "SSH config failed"
        exit 1
    fi


    copy_public_ssh_key_to_clipboard "${sshKeyFileName}.pub"
    # Start the ssh-agent in the background and continue script
    eval $(ssh-agent) \
        &&

    open_github_ssh_page
    test_ssh_connection

}

test_ssh_connection() {
    while true; do

        ssh -T git@github.com &> /dev/null
        [ $? -eq 1 ] && break

        sleep 5

    done

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    GITHUB_EMAIL=$1

    print_in_purple "\n • Set up GitHub SSH keys for ${GITHUB_EMAIL}\n\n"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ -z "$GITHUB_EMAIL" ]; then
        print_error "Please provide an email address as a parameter"
        exit 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    ssh -T git@github.com &> /dev/null

    if [ $? -ne 1 ]; then
        set_github_ssh_key
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_result $? "Set up GitHub SSH keys"

}

main "$@"
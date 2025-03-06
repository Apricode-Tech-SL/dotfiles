#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

add_ssh_configs() {

    printf "%s\n" \
        "Host bitbucket.org" \
        "  AddKeysToAgent yes" \
        "  IdentityFile $1" >> ~/.ssh/config

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

    print_in_purple "Generating ssh key for ${BITBUCKET_EMAIL}:" && printf " \n"
    ssh-keygen -t ed25519 -b 4096 -C "${BITBUCKET_EMAIL}" -f "$1"

    print_result $? "Generate SSH keys"

}

open_bitbucket_ssh_page() {

    declare -r BITBUCKET_SSH_URL="https://bitbucket.org/account/settings/ssh-keys/"
    print_warning "Opening BitBucket SSH page..."
    # The order of the following checks matters
    # as on Ubuntu there is also a utility called `open`.

    if cmd_exists "xdg-open"; then
        xdg-open "$BITBUCKET_SSH_URL"
    elif cmd_exists "open"; then
        open "$BITBUCKET_SSH_URL"
    else
        print_warning "Please add the public SSH key to BitBucket ($BITBUCKET_SSH_URL)"
    fi

}

set_bitbucket_ssh_key() {

    local sshKeyFileName="$HOME/.ssh/bitbucket"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # If there is already a file with that
    # name, generate another, unique, file name.

    if [ -f "$sshKeyFileName" ]; then
        sshKeyFileName="$(mktemp -u "$HOME/.ssh/bitbucket_XXXXX")"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    generate_ssh_keys "$sshKeyFileName"
    add_ssh_configs "$sshKeyFileName"
    copy_public_ssh_key_to_clipboard "${sshKeyFileName}.pub"
    # Start the ssh-agent in the background and continue script
    eval $(ssh-agent) \
        &&

    open_bitbucket_ssh_page
    test_ssh_connection

}

test_ssh_connection() {

    local timeout=60  # Timeout in seconds
    local interval=5  # Interval between checks in seconds
    local elapsed=0

    while [ $elapsed -lt $timeout ]; do

        output=$(ssh -T git@bitbucket.org 2>&1)
        if [[ $output == *"authenticated via ssh key"* ]]; then
            print_result 0 "SSH connection to BitBucket successful"
            return 0
        fi

        sleep $interval
        elapsed=$((elapsed + interval))

    done

    print_error "SSH connection to BitBucket timed out"
    return 1

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    BITBUCKET_EMAIL=$1

    if [ -z "$BITBUCKET_EMAIL" ]; then
        print_error "Please set the BITBUCKET_EMAIL"
        exit 1
    fi

    print_in_purple "\n • Set up BitBucket SSH keys for ${BITBUCKET_EMAIL}\n\n"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check that your SSH authentication works
    ssh -T git@bitbucket.org &> /dev/null

    if [ $? -ne 1 ]; then
        set_bitbucket_ssh_key
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_result $? "Set up BitBucket SSH keys"

}

main "$@"

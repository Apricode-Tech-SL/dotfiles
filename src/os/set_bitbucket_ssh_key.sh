#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

add_ssh_configs() {

    printf "%s\n" \
        "Host bitbucket.org-${BITBUCKET_USERNAME}" \
        "  HostName bitbucket.org" \
        "  User git" \
        "  IdentityFile $1" \
        "  IdentitiesOnly yes" \
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

    print_in_purple "Generating ssh key for $(BITBUCKET_EMAIL):" && printf " \n"
    ssh-keygen -t rsa -b ed25519 -C "$(BITBUCKET_EMAIL)" -f "$1"

    print_result $? "Generate SSH keys"

}

open_bitbucket_ssh_page() {

    declare -r BITBUCKET_SSH_URL="https://bitbucket.org/account/settings/ssh-keys/"

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

    local sshKeyFileName="$HOME/.ssh/github"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # If there is already a file with that
    # name, generate another, unique, file name.

    if [ -f "$sshKeyFileName" ]; then
        sshKeyFileName="$(mktemp -u "$HOME/.ssh/github_XXXXX")"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    generate_ssh_keys "$sshKeyFileName"
    add_ssh_configs "$sshKeyFileName"
    copy_public_ssh_key_to_clipboard "${sshKeyFileName}.pub"
    eval $(ssh-agent)
    open_bitbucket_ssh_page
    test_ssh_connection \
        && rm "${sshKeyFileName}.pub"

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

    if [ -z "$BITBUCKET_EMAIL" ]; then
        print_error "Please set the BITBUCKET_EMAIL"
        exit 1
    fi

    # Get username from email address
    BITBUCKET_USERNAME=$(echo $BITBUCKET_EMAIL | cut -d "@" -f 1)

    print_in_purple "\n • Set up BitBucket SSH keys\n\n"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if ! is_git_repository; then
        print_error "Not a Git repository"
        exit 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check that your SSH authentication works
    ssh -T git@bitbucket.org &> /dev/null

    if [ $? -ne 1 ]; then
        set_bitbucket_ssh_key
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_result $? "Set up BitBucket SSH keys"

}

main
#!/usr/bin/env bash
script_name='./simpass.sh'
usage="📘 A simple password manager created by Jim Lin.\nUsage: ${script_name} {view|edit|encode|decode} your_password_file"
if [[ "$1" == "-h" || "$1" == "--help" || "$#" != 2 ]]; then
    echo -e "${usage}"
    exit 0
fi

function encode() {
    # Encrypt it
    ansible-vault encrypt --vault-password-file="$1" "$2"
}

function decode() {
    # Decrypt it
    ansible-vault decrypt --vault-password-file="$1" "$2"
}

command=$1
password_file=$2
# For more information please see: https://www.computerhope.com/unix/bash/read.htm
IFS= read -p $'Please enter your password:' -s -r password
# Dump your vault password file
vault_password_file=$(mktemp)
printf "%s" "${password}" > "${vault_password_file}"
printf '\n'

case "${command}" in
    view)
        decode "$vault_password_file" "$password_file"
        view "$password_file"
        encode "$vault_password_file" "$password_file"
    ;;
    edit)
        decode "$vault_password_file" "$password_file"
        vim "$password_file"
        encode "$vault_password_file" "$password_file"
    ;;
    encode)
        encode "$vault_password_file" "$password_file"
    ;;
    decode)
        decode "$vault_password_file" "$password_file"
    ;;
esac

# Remove your vault password file
rm -f "$vault_password_file"
exit 0

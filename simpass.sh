#!/usr/bin/env bash
script_name='./simpass.sh'
usage="📘 A simple password manager created by Jim Lin.\nUsage: ${script_name} {view|edit|encode|decode} your_password_file"
if [[ "$1" == "-h" || "$1" == "--help" || "$#" != 2 ]]; then
    echo -e "${usage}"
    exit 0
fi

function encode() {
    # Encrypt it
    ansible-vault encrypt --vault-password-file=<(printf "%s" "$1") "$2"
}

function decode() {
    # Decrypt it
    ansible-vault decrypt --vault-password-file=<(printf "%s" "$1") "$2"
}

command=$1
password_file=$2
# For more information please see: https://www.computerhope.com/unix/bash/read.htm
IFS= read -p 'Please enter your password:' -s -r password
printf '\n'

case "${command}" in
    view)
        decode "$password" "$password_file"
        view "$password_file"
        encode "$password" "$password_file"
    ;;
    edit)
        decode "$password" "$password_file"
        vim "$password_file"
        encode "$password" "$password_file"
    ;;
    encode)
        encode "$password" "$password_file"
    ;;
    decode)
        decode "$password" "$password_file"
    ;;
esac
exit 0

#!/bin/bash -eu
# -----------------------------------------------------------------------------
#  Downloader of the Official PHP Source Archive
# -----------------------------------------------------------------------------
# This script will:
#   1. Download the official latest master PHP srouce ZIP archive from GitHub.
#   2. Extracts the archive and re-archives it to 7zip.
#   3. The archived file will be SHA-256-signed with KEINOS' private RSA key.
#     - Public key: https://github.com/KEINOS.keys (The first one)
#   4. Overwrites the "VERSION_INFO.txt"
#
# - Requirements: 7z (p7zip), curl, unzip, diff
# - Note: Basically this script will be called from "run-update.sh"

# -----------------------------------------------------------------------------
#  Constants
# -----------------------------------------------------------------------------
ALGO_SIGN='SHA256' # The algorithm to sign with openssl
LEVEL_COMPRESS=9   # 9=Max compression of 7z
PHP_URL="https://github.com/php/php-src/archive/master.zip"

NAME_DIR_SRC_EXTRACTED='php-src-master'
NAME_FILE_BUILD_INFO='info-build.txt'
ID_SRC_ARCHIVE=$(date '+%Y%m%d')

PATH_DIR_RETURN="${PWD}"
PATH_DIR_SELF=$(cd "$(dirname "${BASH_SOURCE:-$0}")" && pwd)

PATH_DIR_SRC="${PATH_DIR_SELF}/src"
PATH_DIR_SRC_EXTRACTED="${PATH_DIR_SRC}/php"
PATH_DIR_SRC_EXTRACTED_VERIFY="${PATH_DIR_SRC}/php2"

PATH_FILE_ZIP="${PATH_DIR_SRC}/php.zip"                        # original source code
PATH_FILE_7Z="${PATH_DIR_SRC}/php.7z"                          # re-archived
PATH_FILE_SIGN="${PATH_DIR_SRC}/php.7z.sig"                    # sign
PATH_FILE_KEY_PUBLIC_PKCS8="${PATH_DIR_SELF}/id_rsa.pkcs8.pub" # pub key in PKCS8
PATH_FILE_PEM_PRIVATE=$(ls ~/.ssh/id_rsa.private.pem)
PATH_FILE_BUILD_INFO="${PATH_DIR_SELF}/${NAME_FILE_BUILD_INFO}"

# -----------------------------------------------------------------------------
#  Functions
# -----------------------------------------------------------------------------

function compare_archive_contents() {
    cd "$PATH_DIR_SRC"

    echo '- Comparing both extracted archive'

    echo -n '  Extracting 7zip archive ... '
    7z x -o"$PATH_DIR_SRC_EXTRACTED_VERIFY" "$PATH_FILE_7Z" | grep Everything | grep Ok || {
        echo '  ❌  Failed to extract 7zip archive.'
        exit 1
    }

    echo -n '  Diff between extracted zip and 7zip archive directories ... '
    if diff -r "$PATH_DIR_SRC_EXTRACTED" "$PATH_DIR_SRC_EXTRACTED_VERIFY"; then
        echo 'OK'
    else
        echo '  ❌  Failed to archive files. Diff did not match.'
        exit 1
    fi

    cd "$PATH_DIR_RETURN"
}

function delete_dir_archive_extracted() {
    echo -n '- Deleting extracted source code ...'
    if rm -rf "$PATH_DIR_SRC_EXTRACTED" "$PATH_DIR_SRC_EXTRACTED_VERIFY" "$PATH_FILE_ZIP"; then
        echo 'OK'
    else
        echo '  ❌  Failed to delete extacted source code directories.'
        exit 1
    fi
}

function download_archive_php_src() {
    cd "$PATH_DIR_SELF" && rm -rf src

    echo -n '- Downloading latest master archive ... '
    mkdir -p "$PATH_DIR_SRC_EXTRACTED"
    if curl --silent --show-error --location --output "$PATH_FILE_ZIP" "${PHP_URL}"; then
        echo 'OK'
    else
        echo '  ❌  Failed to download official PHP source archive.'
        echo 'Request header: '
        curl -s -I "$PHP_URL" |
            while read -r line; do
                echo "    ${line}"
            done
        exit 1
    fi
}

function get_core_number() {
    if which nproc 2>/dev/null 1>/dev/null; then
        nproc
    else
        sysctl -n hw.logicalcpu_max
    fi
}

function rearchive_php_src_to_7z() {
    echo '- Re-archiving zip to 7z archive:'
    echo -n '  Extracting zip archive ... '
    if unzip -q "$PATH_FILE_ZIP" -d "${PATH_DIR_SRC_EXTRACTED}"; then
        echo 'OK'
    else
        exit 1
    fi

    echo -n '  Archiving to 7z ... '
    cd "$PATH_DIR_SRC_EXTRACTED"
    NUM_CORE=$(get_core_number)
    7z a -mmt"${NUM_CORE:-1}" -mx$LEVEL_COMPRESS "$PATH_FILE_7Z" $NAME_DIR_SRC_EXTRACTED | tail -n1

    cd "$PATH_DIR_RETURN"
}

function sign_file() {
    echo -n '- Signing archive ... '

    INPUTFILE="$1"
    OUTPUTFILE="$2"
    if ! openssl dgst -$ALGO_SIGN -sign "$PATH_FILE_PEM_PRIVATE" "$INPUTFILE" >"$OUTPUTFILE"; then
        echo '  ❌  Failed to sign archive file.'
        exit 1
    fi
    echo 'Signed. This file can be verified with the public key in GitHub.'
}

function verify_signed_file() {
    echo -n '- Verifying signed file ... '

    PATH_FILE_SIGN="${1}"
    PATH_FILE_TARGET="${2}"

    openssl dgst -$ALGO_SIGN -verify "$PATH_FILE_KEY_PUBLIC_PKCS8" -signature "$PATH_FILE_SIGN" "$PATH_FILE_TARGET" || {
        echo '  ❌  Failed to verify signed archive file.'
        exit 1
    }
}

# -----------------------------------------------------------------------------
#  Main
# -----------------------------------------------------------------------------

download_archive_php_src
rearchive_php_src_to_7z
compare_archive_contents
sign_file "$PATH_FILE_7Z" "$PATH_FILE_SIGN"
verify_signed_file "$PATH_FILE_SIGN" "$PATH_FILE_7Z"
delete_dir_archive_extracted

echo "ID_SRC_ARCHIVE=${ID_SRC_ARCHIVE}" >>"$PATH_FILE_BUILD_INFO"

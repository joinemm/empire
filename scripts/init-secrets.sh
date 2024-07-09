#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
    echo "please give path to the folder where secrets.yaml should be created"
    exit 2
fi

CONFIG_PATH=$1
TARGET=$(basename "$CONFIG_PATH")

echo "> Initializing secrets for $TARGET"

TMPDIR=$(mktemp -d)
if [ -z "$2" ]; then
    echo "> Generating new ed25519 key"
    ssh-keygen -t ed25519 -a 100 -C "$TARGET" -f "$TMPDIR/host_id_ed25519" -N ''
else
    echo "> Using $2 as the host key"
    cp "$2" "$TMPDIR/host_id_ed25519"
    cp "$2.pub" "$TMPDIR/host_id_ed25519"
fi
AGE=$(ssh-to-age <"$TMPDIR/host_id_ed25519.pub")

SECRETS="$CONFIG_PATH/secrets.yaml"
if [ -f "$SECRETS" ]; then
    read -p "> $SECRETS exists, overwrite? [y/N]: " -r REPLY
else
    REPLY="Y"
fi

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "> Creating secrets.yaml"
    echo "ssh_host_ed25519_key: |" >"$SECRETS"
    sed -e 's/^/  /' "$TMPDIR/host_id_ed25519" >>"$SECRETS"
    sops -e -i "$SECRETS"
else
    echo "> Using existing secret file"
fi

echo
echo "> You can now run the following command to edit secrets"
echo "sops $SECRETS"

echo
echo "> Add the following to .sops.yaml"
echo "  - &$TARGET $AGE"

echo
echo "> Then remember to run"
echo "sops updatekeys $SECRETS"

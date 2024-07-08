#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "please give path to the folder where secrets.yaml should be created"
    exit 2
fi

CONFIG_PATH=$1
TARGET=$(basename "$CONFIG_PATH")

echo "> Initializing secrets for $TARGET"

TMPDIR=$(mktemp -d)
ssh-keygen -t ed25519 -a 100 -C "$TARGET" -f "$TMPDIR/host_id_ed25519" -N ''
AGE=$(ssh-to-age <"$TMPDIR/host_id_ed25519.pub")

echo "> Creating secrets.yaml"
SECRETS="$CONFIG_PATH/secrets.yaml"
echo "ssh_host_ed25519_key: |" >"$SECRETS"
sed -e 's/^/  /' "$TMPDIR/host_id_ed25519" >>"$SECRETS"
sops -e -i "$SECRETS"

echo
echo "> You can now run the following command to edit secrets"
echo "sops $SECRETS"

echo
echo "> Add the following to .sops.yaml"
echo "  - &$TARGET $AGE"

echo
echo "> Then remember to run"
echo "sops updatekeys $SECRETS"

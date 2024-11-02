#!/bin/sh

nix eval --json .#deploy.list 2>/dev/null | jq -r '. | to_entries[] | [.key, .value] | @tsv' | column -t

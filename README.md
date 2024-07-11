<img alt="NixOS" src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake-white.svg" width="150px"/>


# Snowflake

My personal NixOS flake, building dotfiles for all of my systems and servers.

The configuration is modular, with modules imported to each host as needed.

Shell scripts are built from the flake at <https://github.com/joinemm/bin>

## Hosts

- `zeus` - Desktop workstation/gaming pc
- `x1` - Thinkpad X1 Carbon gen11 work laptop
- `monitoring` - Grafana and prometheus server for monitoring Miso Bot
- `apollo` - Syncthing central sync node and cloud server for web services
- `archimedes` - Raspberry Pi 4B, local homelab for local services such as DNS

## Installation

For a given `host`

```sh
nixos-rebuild switch --flake .#$HOST
```

## Installing to remote servers

The included script will install the system, and add `ssh_host_ed25519_key` specified in `secrets.yaml`

```sh
./scripts/install .#$HOST $REMOTE_IP --secrets hosts/$HOST/secrets.yaml
```

## SD card images

The raspberry pi config can be built as flashable sd card image for initial installation:

```sh
nix build .#nixosConfigurations.archimedes.config.system.build.sdImage

# check sd card device
lsblk
# flash to sd card
sudo dd if=result/nixos-sd-image-xxx-aarch64-linux.img of=/dev/sda bs=4M conv=fsync status=progress
```

This sd card can now be inserted into a raspberry pi and it will boot the configuration.

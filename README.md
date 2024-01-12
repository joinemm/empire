# NixOS

This is my NixOS flake.

The configuration is split into nixos modules and home-manager modules, 
which are then imported from each host according to it's needs.

Shell scripts built from the flake in https://github.com/joinemm/bin

# Installation

For a given `host`

```
nixos-rebuild switch --flake .#host
```

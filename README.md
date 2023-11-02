# NixOS

This is my NixOS flake.

There is separate configuration for each host.

## Installation

First, take ownership of `/etc/nixos`:

```
chown -R $USER:users /etc/nixos
```

You should be able to clone this repo into `/etc/nixos` now and run `nixos-rebuild switch`.

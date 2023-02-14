# NixOS

This is my NixOS "Erase your darlings" setup.

On boot, the root subvolume is rolled back to an empty btrfs snapshot before the persistent subvolumes are mounted onto it.

This means the system state is always fresh and fully managed by configuration.nix.

Persistance is opt-in.

Heavily inspired by these blog posts:
 - https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
 - https://grahamc.com/blog/erase-your-darlings

## filesystem layout

```sh
/           btrfs   root subvolume
 - /boot    fat32   boot partition
 - /persist btrfs   files that persist between reboots
 - /var/log btrfs   logging subvolume
 - /nix     btrfs   nix store subvolume
 - /home    btrfs   home subvolume
```

## Partitioning

```sh
fdisk /dev/sda
  g # create new empty GTP partition table
  n # add a new partition
    +512M # we need around 512Mb for our boot partition
  a # set the bootable flag to our boot partition
  n # make the root partition
  p # print the partition table and make sure it's how you want it to be
  v # verify the partition table
  w # write the changes to the disk
```

## Encryption setup

```sh
cryptsetup --verify-passphrase -v luksFormat /dev/sda2
cryptsetup open /dev/sda2 enc
```

## Formatting with btrfs

> ! `/dev/mapper/enc` is where the luks decrypted drive mounts.

```sh
mkfs.vfat -n BOOT /dev/sda1
mkfs.btrfs /dev/mapper/enc
```

## Btrfs setup

```sh
mount -t btrfs /dev/mapper/enc /mnt
```

We first create the subvolumes:

```sh
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/log
```

We then take an empty *readonly* snapshot of the root subvolume,
which we'll eventually rollback to on every boot.

```sh
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

umount /mnt
```

Then we mount the subvolumes to where they need to be

```sh
mount -o subvol=root,compress=zstd,noatime /dev/mapper/enc /mnt

mkdir /mnt/home
mount -o subvol=home,compress=zstd,noatime /dev/mapper/enc /mnt/home

mkdir /mnt/nix
mount -o subvol=nix,compress=zstd,noatime /dev/mapper/enc /mnt/nix

mkdir /mnt/persist
mount -o subvol=persist,compress=zstd,noatime /dev/mapper/enc /mnt/persist

mkdir -p /mnt/var/log
mount -o subvol=log,compress=zstd,noatime /dev/mapper/enc /mnt/var/log

mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
```

## Generate nixos hardware config

```sh
nixos-generate-config --root /mnt
```

add `needFotBoot = true;` into mount settings of `/var/log` & `/persist` in `hardware-configuration.nix`

Now you are ready to install nixos

```sh
nixos-install
reboot
```

## Getting my configs

First, take ownership of `/etc/nixos`:

```
chown -R $USER:users /etc/nixos
```

You should be able to clone this repo into `/etc/nixos` now and `nixos-rebuild switch`.

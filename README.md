# NixOS configs

My personal NixOS configurations.

## Usage

Run `./apply-system.sh` to build and apply the NixOS configuration
with the current host name.

## Secrets management

Using [git-crypt](https://github.com/AGWA/git-crypt). All files
declared in `.gitattributes` file will be encrypted.

```
# check what files will be encrypted
git-crypt status

# export symmetric key
git-crypt export-key /path/to/key

# unlock with symmetric key
git-crypt unlock /path/to/key
```

## How to install NixOS in a Raspberry (without monitor)

Steps for installing NixOS (aarch64) in a Raspberry Pi 4B without a monitor.

### 1. Create a custom installation image containing ssh and wifi configuration.

[Example](https://gist.github.com/miltoneiji/bc1113ef47bad3c5c602166e01bfe518).

### 2. Generate the image

Add this to your system configuration to simulate aarch64:

``` nix
boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
```

Generate the image with this command:

``` bash
nix-build '<nixpkgs/nixos>' -A config.system.build.sdImage -I nixos-config=./configuration.nix --argstr system aarch64-linux --option sandbox false
```

### 3. Last steps

Power the Raspberry. It will automatically connect to your wifi and
be available via ssh.

There is no necessity to partition the SD card.

Generate the initial configuration: `nixos-generate-configuration`.

Add this to your configuration:

``` nix
boot = {
  loader.generic-extlinux-compatible.enable = true;
  loader.grub.enable = false;
  loader.raspberryPi.enable = true;
  loader.raspberryPi.version = 4;
  kernelPackages = pkgs.linuxPackages_rpi4;
};
```

Apply the configuration: `nixos-rebuild switch` (it may be necessary to run: `nix-channel --update`).

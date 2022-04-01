# NixOS config

My personal NixOS configuration.

## Usage

Clone this repository to `~/repos/nixos-config`, navigate to this directory and run `./apply-system.sh`.

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

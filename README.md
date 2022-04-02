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

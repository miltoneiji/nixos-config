#!/usr/bin/env nix-shell
#! nix-shell -i bash -p jq nix-prefetch-git gnugrep gnused

config_info=($(
  nix-prefetch-git --quiet \
    https://github.com/miltoneiji/emacs.d \
    | jq '.sha256,.rev,.date' --raw-output
))

sha256="${config_info[0]}"
rev="${config_info[1]}"
release_date="${config_info[2]}"

current_rev=$(
  grep 'rev\s*=' "default.nix" \
    | sed -Ene 's/.*"(.*)".*/\1/p'
)

current_sha256=$(
  grep 'sha256\s*=' "default.nix" \
    | sed -Ene 's/.*"(.*)".*/\1/p'
)

if [[ "$current_rev" = "$rev" ]]; then
  echo "Emacs config is already up-to-date"
  exit 0
fi

echo "Updating from ${current_rev} to ${rev}, released on ${release_date}"

sed --regexp-extended \
  -e 's/rev\s*=\s*"[^"]*"\s*;/rev = "'${rev}'";/' \
  -e 's/sha256\s*=\s*"[^"]*"\s*;/sha256 = "'${sha256}'";/' \
  -i "default.nix"

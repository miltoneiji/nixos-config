#!/usr/bin/env bash

pushd ~/repos/nixos-config
# Build the NixOS configuration with the current host name
sudo nixos-rebuild switch --flake '.#'
popd

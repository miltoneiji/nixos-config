#!/usr/bin/env bash

pushd ~/repos/nixos-config
sudo nixos-rebuild switch --flake '.#'
popd

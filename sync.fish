#!/usr/bin/env fish
set -l config $HOME/.config/nvim
mkdir -p $config/undo $config/spell $config/backup
rm -rf $config/lua
env MACOSX_DEPLOYMENT_TARGET=10.15 PACKER_SYNC=1 \
   nvim "+au User PackerComplete qa" "+PackerSync" "+silent TSUpdateSync"

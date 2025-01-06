#!/bin/bash
filepath=$(cd "$(dirname "$0")"; pwd)
cd "$filepath"
option=$1
if [[ $option -eq 1 ]]
then
make --always-make CHAR_FLAGS=
else
make --always-make RGBDS=rgbds-cn/ CHAR_FLAGS="-D RGBDS_WCHAR"
fi

mkdir roms
mkdir roms/rb
cp pokered.gbc roms/rb/pokered."$option".gbc
cp pokered_vc.gbc roms/rb/pokered_vc."$option".gbc
cp pokered_debug.gbc roms/rb/pokered_debug."$option".gbc

cp pokeblue.gbc roms/rb/pokeblue."$option".gbc
cp pokeblue_vc.gbc roms/rb/pokeblue_vc."$option".gbc
cp pokeblue_debug.gbc roms/rb/pokeblue_debug."$option".gbc

cp pokered.patch roms/rb/pokered."$option".patch

cp pokeblue.patch roms/rb/pokeblue."$option".patch
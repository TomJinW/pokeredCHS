filepath=$(cd "$(dirname "$0")"; pwd)
cd $filepath
make --always-make RGBDS=rgbds-061/

mkdir roms
mkdir roms/rb
cp pokered.gbc roms/rb/pokered.gbc
cp pokered_vc.gbc roms/rb/pokered_vc.gbc
cp pokered_debug.gbc roms/rb/pokered_debug.gbc

cp pokeblue.gbc roms/rb/pokeblue.gbc
cp pokeblue_vc.gbc roms/rb/pokeblue_vc.gbc
cp pokeblue_debug.gbc roms/rb/pokeblue_debug.gbc

cp pokered.patch roms/rb/pokered.patch

cp pokeblue.patch roms/rb/pokeblue.patch
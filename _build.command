filepath=$(cd "$(dirname "$0")"; pwd)
cd "$filepath"
option=$1
if [[ $option -eq 1 ]]
then
make --always-make RGBDS=rgbds-061/ CHAR_FLAGS=
else
make --always-make RGBDS=rgbds-cn/ CHAR_FLAGS="-D RGBDS_WCHAR"
fi

mkdir roms
mkdir roms/rgb

cp pokered.gbc roms/rgb/pokered.gbc
cp pokered_vc.gbc roms/rgb/pokered_vc.gbc
cp pokered_debug.gbc roms/rgb/pokered_debug.gbc
cp pokegreen.gbc roms/rgb/pokegreen.gbc
cp pokegreen_vc.gbc roms/rgb/pokegreen_vc.gbc
cp pokegreen_debug.gbc roms/rgb/pokegreen_debug.gbc
cp pokeblue.gbc roms/rgb/pokeblue.gbc
cp pokeblue_vc.gbc roms/rgb/pokeblue_vc.gbc
cp pokeblue_debug.gbc roms/rgb/pokeblue_debug.gbc

cp pokered.patch roms/rgb/pokered.patch
cp pokegreen.patch roms/rgb/pokegreen.patch
cp pokeblue.patch roms/rgb/pokeblue.patch
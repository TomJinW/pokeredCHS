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
mkdir roms/rgb

cp pokered.gbc roms/rgb/pokered."$option".gbc
cp pokered_vc.gbc roms/rgb/pokered_vc."$option".gbc
cp pokered_debug.gbc roms/rgb/pokered_debug."$option".gbc
cp pokegreen.gbc roms/rgb/pokegreen."$option".gbc
cp pokegreen_vc.gbc roms/rgb/pokegreen_vc."$option".gbc
cp pokegreen_debug.gbc roms/rgb/pokegreen_debug."$option".gbc
cp pokeblue.gbc roms/rgb/pokeblue."$option".gbc
cp pokeblue_vc.gbc roms/rgb/pokeblue_vc."$option".gbc
cp pokeblue_debug.gbc roms/rgb/pokeblue_debug."$option".gbc

cp pokered.patch roms/rgb/pokered."$option".patch
cp pokegreen.patch roms/rgb/pokegreen."$option".patch
cp pokeblue.patch roms/rgb/pokeblue."$option".patch
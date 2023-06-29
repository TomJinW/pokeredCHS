filepath=$(cd "$(dirname "$0")"; pwd)
cd "$filepath"

md5 roms/rb/pokered.1.gbc
md5 roms/rb/pokered.2.gbc
echo 
md5 roms/rb/pokeblue.1.gbc
md5 roms/rb/pokeblue.2.gbc
echo

md5 roms/rb/pokered_vc.1.gbc
md5 roms/rb/pokered_vc.2.gbc
echo
md5 roms/rb/pokeblue_vc.1.gbc
md5 roms/rb/pokeblue_vc.2.gbc

echo
echo RGB Version
echo
md5 roms/rgb/pokered.1.gbc
md5 roms/rgb/pokered.2.gbc
echo
md5 roms/rgb/pokegreen.1.gbc
md5 roms/rgb/pokegreen.2.gbc
echo
md5 roms/rgb/pokeblue.1.gbc
md5 roms/rgb/pokeblue.2.gbc

echo
md5 roms/rgb/pokered_vc.1.gbc
md5 roms/rgb/pokered_vc.2.gbc
echo
md5 roms/rgb/pokegreen_vc.1.gbc
md5 roms/rgb/pokegreen_vc.2.gbc
echo
md5 roms/rgb/pokeblue_vc.1.gbc
md5 roms/rgb/pokeblue_vc.2.gbc
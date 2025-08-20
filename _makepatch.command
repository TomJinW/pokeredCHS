filepath=$(cd "$(dirname "$0")"; pwd)
cd "$filepath"

mv roms/pokered.gb roms/pokered.gbc
mv roms/pokeblue.gb roms/pokeblue.gbc

echo making patch for Red and Blue
./tools/flips -c roms/pokered.gbc roms/rb/pokered.1.gbc -i roms/rb/pokered.1.ips
./tools/flips -c roms/pokeblue.gbc roms/rb/pokeblue.1.gbc -i roms/rb/pokeblue.1.ips

echo
echo making patch for Red, Green and Blue
./tools/flips -c roms/pokered.gbc roms/rgb/pokered.1.gbc -i roms/rgb/pokered.1.ips
./tools/flips -c roms/pokeblue.gbc roms/rgb/pokeblue.1.gbc -i roms/rgb/pokeblue.1.ips
./tools/flips -c roms/pokeblue.gbc roms/rgb/pokegreen.1.gbc -i roms/rgb/pokegreen.1.ips

echo
echo copying patches
rm -rf roms/tmp
mkdir roms/tmp
cp roms/rb/pokered.1.ips roms/tmp/rb-pokered.ips
cp roms/rb/pokeblue.1.ips roms/tmp/rb-pokeblue.ips
cp roms/rgb/pokered.1.ips roms/tmp/rgb-pokered.ips
cp roms/rgb/pokegreen.1.ips roms/tmp/rgb-pokegreen.ips
cp roms/rgb/pokeblue.1.ips roms/tmp/rgb-pokeblue.ips
cp roms/rb/pokered.1.patch roms/tmp/rb-pokered.patch
cp roms/rb/pokeblue.1.patch roms/tmp/rb-pokeblue.patch
cp roms/rgb/pokered.1.patch roms/tmp/rgb-pokered.patch
cp roms/rgb/pokegreen.1.patch roms/tmp/rgb-pokegreen.patch
cp roms/rgb/pokeblue.1.patch roms/tmp/rgb-pokeblue.patch

echo
echo Testing... Applying Patch
./tools/flips -a roms/tmp/rb-pokered.ips roms/pokered.gbc roms/tmp/rb-pokered.gbc
./tools/flips -a roms/tmp/rb-pokeblue.ips roms/pokeblue.gbc roms/tmp/rb-pokeblue.gbc
./tools/flips -a roms/tmp/rgb-pokered.ips roms/pokered.gbc roms/tmp/rgb-pokered.gbc
./tools/flips -a roms/tmp/rgb-pokegreen.ips roms/pokeblue.gbc roms/tmp/rgb-pokegreen.gbc
./tools/flips -a roms/tmp/rgb-pokeblue.ips roms/pokeblue.gbc roms/tmp/rgb-pokeblue.gbc
cp roms/rb/pokered_debug.1.gbc roms/tmp/rb-pokered_debug.gbc
cp roms/rb/pokeblue_debug.1.gbc roms/tmp/rb-pokeblue_debug.gbc
cp roms/rgb/pokered_debug.1.gbc roms/tmp/rgb-pokered_debug.gbc
cp roms/rgb/pokegreen_debug.1.gbc roms/tmp/rgb-pokegreen_debug.gbc
cp roms/rgb/pokeblue_debug.1.gbc roms/tmp/rgb-pokeblue_debug.gbc
./_compareVersion.command
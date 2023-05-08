filepath=$(cd "$(dirname "$0")"; pwd)
cd "$filepath"

mv roms/pokered.gb roms/pokered.gbc
mv roms/pokeblue.gb roms/pokeblue.gbc

echo making patch for Red and Blue
./tools/flips -c roms/pokered.gbc roms/rb/pokered.gbc -i roms/rb/pokered.ips
./tools/flips -c roms/pokeblue.gbc roms/rb/pokeblue.gbc -i roms/rb/pokeblue.ips

echo making patch for Red, Green and Blue
./tools/flips -c roms/pokered.gbc roms/rgb/pokered.gbc -i roms/rgb/pokered.ips
./tools/flips -c roms/pokeblue.gbc roms/rgb/pokeblue.gbc -i roms/rgb/pokeblue.ips
./tools/flips -c roms/pokeblue.gbc roms/rgb/pokegreen.gbc -i roms/rgb/pokegreen.ips

rm -rf roms/tmp
mkdir roms/tmp
./tools/flips -a roms/rb/pokered.ips roms/pokered.gbc roms/tmp/US.pRed.gbc
./tools/flips -a roms/rb/pokeblue.ips roms/pokeblue.gbc roms/tmp/US.pBlue.gbc
./tools/flips -a roms/rgb/pokered.ips roms/pokered.gbc roms/tmp/SJP.pRed.gbc
./tools/flips -a roms/rgb/pokeblue.ips roms/pokeblue.gbc roms/tmp/SJP.Blue.gbc
./tools/flips -a roms/rgb/pokegreen.ips roms/pokeblue.gbc roms/tmp/SJP.pGreen.gbc
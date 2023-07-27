filepath=$(cd "$(dirname "$0")"; pwd)
cd "$filepath"
mkdir tmp


python3 tools/_genJSON.py xlsx/xlsxList.txt 1 5 0 > _G1RB.json


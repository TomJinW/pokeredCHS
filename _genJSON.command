filepath=$(cd "$(dirname "$0")"; pwd)
cd "$filepath"
# mkdir tmp

# cd /Users/tom/Library/CloudStorage/OneDrive-Personal/Office/pokeredCHS
# cp buildingsA.xlsx $filepath/xlsx/buildingsA.xlsx
# cp buildingsB.xlsx $filepath/xlsx/buildingsB.xlsx
# cp core.xlsx $filepath/xlsx/core.xlsx
# cp data.xlsx $filepath/xlsx/data.xlsx
# cp indoor.xlsx $filepath/xlsx/indoor.xlsx
# cp outdoor.xlsx $filepath/xlsx/outdoor.xlsx
# cp routes.xlsx $filepath/xlsx/routes.xlsx
# cp dex.xlsx $filepath/xlsx/dex.xlsx
# cp dexEntry.xlsx $filepath/xlsx/dexEntry.xlsx
# cp dexRGB.xlsx $filepath/xlsx/dexRGB.xlsx

# cd $filepath

python3 tools/_genJSON.py xlsx/xlsxList.txt 1 5 0 > _G1RB.json


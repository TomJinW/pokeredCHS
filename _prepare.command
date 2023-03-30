filepath=$(cd "$(dirname "$0")"; pwd)
cd $filepath
mkdir tmp

cd /Users/tom/Library/CloudStorage/OneDrive-Personal/Office/pokeredCHS
cp buildingsA.xlsx $filepath/xlsx/buildingsA.xlsx
cp buildingsB.xlsx $filepath/xlsx/buildingsB.xlsx
cp core.xlsx $filepath/xlsx/core.xlsx
cp data.xlsx $filepath/xlsx/data.xlsx
cp indoor.xlsx $filepath/xlsx/indoor.xlsx
cp outdoor.xlsx $filepath/xlsx/outdoor.xlsx
cp routes.xlsx $filepath/xlsx/routes.xlsx

cd $filepath
python3 tools/_backup.py xlsx/xlsxList.txt xlsx/ 0

python3 tools/_importText.py xlsx/outdoor.xlsx 5

python3 tools/_importDexEntry.py xlsx/dexEntry.xlsx 13 1
python3 tools/_importTextData.py xlsx/data.xlsx 1


make --always-make RGBDS=rgbds-061/

python3 tools/_backup.py xlsx/xlsxList.txt xlsx/ 1

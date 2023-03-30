filepath=$(cd "$(dirname "$0")"; pwd)
cd $filepath
mkdir tmp
python3 tools/_importDexEntry.py xlsx/dexEntry.xlsx 13 1
python3 tools/_importTextData.py xlsx/data.xlsx 1

python3 tools/_importDexEntry.py xlsx/dexEntry.xlsx 6 0

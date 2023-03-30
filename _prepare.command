filepath=$(cd "$(dirname "$0")"; pwd)
cd $filepath
mkdir tmp
python3 tools/_importTextData.py xlsx/data.xlsx 1

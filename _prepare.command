#!/bin/bash
filepath=$(cd "$(dirname "$0")"; pwd)
cd "$filepath"
# mkdir tmp

mkdir buildRGB
echo Creating build folder...
rsync -a --exclude='buildRGB' ./* ./buildRGB/

cd buildRGB

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

# python3 tools/_backup.py xlsx/xlsxList.txt xlsx/ 0
clear

# echo Which rgbds? Enter number and hit return.
# echo 1. Original RGBDS installed with the system
# echo 2. Modded RGBDS for CHINESE Characters in rgbds-cn/
# read option

if [ -z "${option}" ]
then
    echo The Option is not set, using the default one.
    option=1
fi

python3 tools/_importText.py xlsx/outdoor.xlsx 5 RGB $option
python3 tools/_importText.py xlsx/dexRGB.xlsx 5 RGB $option
python3 tools/_importText.py xlsx/buildingsA.xlsx 5 RGB $option
python3 tools/_importText.py xlsx/buildingsB.xlsx 5 RGB $option
python3 tools/_importText.py xlsx/indoor.xlsx 5 RGB $option
python3 tools/_importText.py xlsx/routes.xlsx 5 RGB $option
python3 tools/_importText.py xlsx/core.xlsx 5 RGB $option
python3 tools/_importDexEntry.py xlsx/dexEntry.xlsx 13 1 $option RGB
python3 tools/_importTextData.py xlsx/data.xlsx 1 RGB $option

chmod +x _build.command
./_build.command $option

# echo Restore Backup?
# echo 1.Yes
# echo 2.No
# read restoreOption
# if [ -z "${restoreOption}" ]
# then
#     echo The Option is not set, using the default one.
#     restoreOption=1
# fi

# if [[ $restoreOption -eq 2 ]]
# then
# echo done!
# else
# python3 tools/_backup.py xlsx/xlsxList.txt xlsx/ 1
echo done!
# fi


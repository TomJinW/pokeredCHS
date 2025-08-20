#!/bin/bash
filepath=$(cd "$(dirname "$0")"; pwd)
cd "$filepath"
mkdir tmp


python3 tools/_checkValid.py xlsx/routes.xlsx 1 5 0
python3 tools/_checkValid.py xlsx/core.xlsx 1 5 0
python3 tools/_checkValid.py xlsx/buildingsA.xlsx 1 5 0
python3 tools/_checkValid.py xlsx/buildingsB.xlsx 1 5 0
python3 tools/_checkValid.py xlsx/dex.xlsx 1 5 0
python3 tools/_checkValid.py xlsx/outdoor.xlsx 1 5 0
python3 tools/_checkValid.py xlsx/indoor.xlsx 1 5 0
python3 tools/_checkValid.py xlsx/dexRGB.xlsx 1 5 0


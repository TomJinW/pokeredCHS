filepath=$(cd "$(dirname "$0")"; pwd)
cd "$filepath"

time python3 tools/match.py xlsx/buildingsA.xlsx 1
time python3 tools/match.py xlsx/buildingsB.xlsx 1
time python3 tools/match.py xlsx/indoor.xlsx 1
time python3 tools/match.py xlsx/routes.xlsx 1
time python3 tools/match.py xlsx/core.xlsx 1
time python3 tools/match.py xlsx/towns.xlsx 1
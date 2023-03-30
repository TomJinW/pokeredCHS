filepath=$(cd "$(dirname "$0")"; pwd)
cd "$filepath"

# python3 ./_extractText.py ./__exporterList/towns.txt ./__exporterText/towns.xlsx
# python3 ./_extractText.py ./__exporterList/buildingsA.txt ./__exporterText/buildingsA.xlsx
# python3 ./_extractText.py ./__exporterList/buildingsB.txt ./__exporterText/buildingsB.xlsx
python3 ./_extractText.py ./__exporterList/indoor.txt ./__exporterText/indoor.xlsx
python3 ./_extractText.py ./__exporterList/routes.txt ./__exporterText/routes.xlsx
# python3 ./_extractText.py ./__exporterList/roots.txt ./__exporterText/roots.xlsx

# python3 ./_extractText.py ./__exporterList/pokedex.txt ./__exporterText/pokedex.xlsx
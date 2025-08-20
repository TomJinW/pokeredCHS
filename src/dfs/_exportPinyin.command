filepath=$(cd "$(dirname "$0")"; pwd)
cd "$filepath"
python3 ./_exportIMEPointer.py > IMEPinTable.asm
python3 ./_exportIMECharCode.py > IMECharTable.asm


# bkcompile.sh FILENAME.asm
F=${1%%asm}
macro11 -yus -ysl 16 -o ${F}obj -l ${F}lst $1
dumpobj ${F}obj >${F}dump
#bk-obj2bin <${F}dump >${F}bin
bk-obj2bin ${F}dump ${F}bin

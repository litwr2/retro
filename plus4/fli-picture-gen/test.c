#include<stdio.h>
#include"svn.h"
#include"flilib.c"
#define START 0x1030
int main() {
    FILE *fi = fopen("out.prg", "r");
    int co = fread(prg + 0xfff, 1, 65535, fi);
    fclose(fi);
    /* the start of graphics */
    prg[0x100e] = 5; //border color
    prg[START + 1] = START&0xff, prg[START + 2] = START >> 8; //no further assembly code
    for (int x = 0; x < 160; x++)
        for (int y = 0; y < VSIZE; y++)
            setpa(x, y, 5, 1);
    for(int x = 0; x < 160; x++) {
       setpa(x, x, 0x77, 2);
       setpa(x, x + 2, 0x52, 0);
       setpa(x, x + 3, 0x4c, 3);
       setpa(159 - x, x, 0x4c, 3);
       setpa(159 - x, x + 2, 0x52, 0);
       setpa(159 - x, x + 3, 0x77, 2);
       setpa(x, x + VSIZE - 160, 0x77, 2);
       setpa(x, x + VSIZE - 162, 0x52, 0);
       setpa(x, x + VSIZE - 163, 0x4c, 3);
       setpa(159 - x, x + VSIZE - 160, 0x4c, 3);
       setpa(159 - x, x + VSIZE - 162, 0x52, 0);
       setpa(159 - x, x + VSIZE - 163, 0x77, 2);
    }
    for(int y = 1; y < 0x7f; y++)
        for (int x = 0; x < 160; x++)
            setpa(x, y + 16, y, 0);
    for (int y = 0; y < VSIZE; y++) {
        setpa(80, y, 0x77, 2);
        setpa(81, y, 0x52, 1);
        setpa(82, y, 0x4c, 3);
        setpa(83, y, 0x52, 1);
        setpa(85, y, 0x66, 2);
        setpa(87, y, 0x66, 2);
    }
    /* the finish of graphics */
    fi = fopen("out1.prg", "w");
    fwrite(prg + 0xfff, 1, co, fi);
    fclose(fi);
}


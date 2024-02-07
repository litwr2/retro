//generates a mosaic that contans all the C+4 colors
#include<stdio.h>
#include"flilib.c"
#define START 0x1030
void settile(int x, int y, int c1, int c2, int *mc) {
    int l[2][4] = {{0, 0, 3, 3}, {3, 0, 0, 3}},
        c[2][4] = {{0, 0, 1, 1}, {2, 3, 3, 2}};
    if (y%2 == 0) {
        setpa(x*4, y*2, c1, 1);
        setbm(x*4, y*2 + 1, 1);
        setpa(x*4 + 1, y*2, c2, 2);
        setbm(x*4 + 1, y*2 + 1, 2);
        setpa(x*4 + 2, y*2, mc[c[0][x%4]], l[0][x%4]);
        setbm(x*4 + 3, y*2, l[0][x%4]);
        setpa(x*4 + 2, y*2 + 1, mc[c[1][x%4]], l[1][x%4]);
        setbm(x*4 + 3, y*2 + 1, l[1][x%4]);
    } else {
        setpa(x*4 + 2, y*2, c1, 1);
        setbm(x*4 + 2, y*2 + 1, 1);
        setpa(x*4 + 3, y*2, c2, 2);
        setbm(x*4 + 3, y*2 + 1, 2);
        setpa(x*4, y*2, mc[c[0][x%4]], l[0][x%4]);
        setbm(x*4 + 1, y*2, l[0][x%4]);
        setpa(x*4, y*2 + 1, mc[c[1][x%4]], l[1][x%4]);
        setbm(x*4 + 1, y*2 + 1, l[1][x%4]);
    }
}
int seqcolor() {
    static int n = -16;
    n += 16;
    if (n > 127) n = n + 1 & 0xf;
    if (n == 0) n = 0x70;
    return n;
}
void setline(int y) {
    int mc[4] = {seqcolor(), seqcolor(), seqcolor(), seqcolor()};
    for(int x = 0; x < 40; x++)
        settile(x, y, seqcolor(), seqcolor(), mc);
}
int main() {
    FILE *fi = fopen("out.prg", "r");
    int co = fread(prg + 0xfff, 1, 65535, fi);
    fclose(fi);
    prg[START + 1] = START&0xff, prg[START+2] = START >> 8; //no further assembly code
    /* the start of graphics */
    //prg[0x100e] = 5; //border color
    for (int y = 0; y < YMAX/2; y++)
        setline(y);
    /* the finish of graphics */
    fi = fopen("out1.prg", "w");
    fwrite(prg + 0xfff, 1, co, fi);
    fclose(fi);
}

#include<stdio.h>
#include<stdlib.h>
#include"svn.h"
#include"../fli-picture-gen/flilib.c"
#define START 0x1030

#define xmax 160
#define ymax VSIZE

#define x_scale 4
#define y_scale 2

#define Xmax (xmax*x_scale)
#define Ymax (ymax*y_scale)

void fillscr() {
    int c = 8;
    for (int y = 0; y < ymax/2; y++)
        for (int x = 0; x < xmax/2; x++) {
            //setpa22_a5(x, y, 0x6e, 2);
            //setpa22_a5(x, y, c);
            c = abs((x - y))%128; if (c < 8) c = (c + 8); setpa22_a5(x, y, c);
            //c = y%128; if (c < 8) c = (c + 8); setpa22_a5(x, y, c);
            //c = x%128; if (c < 8) c = (c + 80); setpa22_a5(x, y, c);
            if (++c > 127) c = 8;
        }
}
int main() {
    FILE *fi = fopen("out.prg", "r");
    int co = fread(prg + 0xfff, 1, 65535, fi);
    fclose(fi);
    /* the start of graphics */
    prg[0x100e] = 5; //border color
    //prg[START + 1] = START&0xff, prg[START + 2] = START >> 8; //no further assembly code
    fillscr();
    /* the finish of graphics */
    fi = fopen("out1.prg", "w");
    fwrite(prg + 0xfff, 1, co, fi);
    fclose(fi);
}


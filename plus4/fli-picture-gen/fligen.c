#include<stdio.h>
int abase1[4] = {0x2800, 0x3000, 0x3800, 0x9000};
int abase2[4] = {0x9800, 0x7000, 0x8000, 0x8800};
unsigned char prg[65536];
void setbm(int x, int y, int cs) {
    int bm = 0x4000,
        p = 312*(y >> 3) + ((x&0xfc) << 1) + y,
        px = 6 - ((x&3) << 1);
    if (y >= 192 && (y < 200 || y < 208 && x < 96)) bm = 0x6000;
    prg[bm + p] = prg[bm + p] & ~(3 << px) | cs << px;
}
#define BA 0x1066  //4198
void setbmc(int x, int y, int c, int cs) {
//cs: 0 - multicolor 1, 1 - background, 2 - foreground, 3 - multicolor 2
    int z = cs == 3;
    int p = BA + y*17 + 5*z;
    setbm(x, y, cs);
    switch (cs) {
    case 0:
    case 3:
        if (y%2 == 0) {
            if (y < 192)
		        prg[p] = c;
		    else if (y == 192)
		        prg[BA - 4 + 2*z] = c;
		    else
		        prg[p + 2] = c;
		}
        else {
		    if (y < 193)
		        prg[p - 3] = c;
		    else
		        prg[p - 1] = c;
		}
		return;
    case 1:
    case 2:
        int ba = abase2[y/2%4] - 0x400;
        int p = (y >> 3)*40 + (x >> 2);
        if (y < 192) ba = abase1[y/2%4];
        else if (y < 200 || y < 208 && x < 96) ba = abase2[y/2%4];
        int cc = prg[ba + p + 0x400];
        int cl = prg[ba + p];
        if (cs == 2) {
            cc &= 0xf0;
            cl &= 0xf;
            prg[ba + p + 0x400] = cc | c&0xf;
            prg[ba + p] = cl | c&0xf0;
        } else {
            cc &= 0xf;
            cl &= 0xf0;
            prg[ba + p + 0x400] = cc | (c&0xf) << 4;
            prg[ba + p] = cl | (c&0xf0) >> 4;
        }
    }
}
int main() {
    FILE *fi = fopen("out.prg", "r");
    int co = fread(prg + 0xfff, 1, 50000, fi);
    fclose(fi);
    /* the start of graphics */
    prg[0x100e] = 5; //border color
#define YMAX 280
    for (int x = 0; x < 160; x++)
        for (int y = 0; y < YMAX; y++)
            setbmc(x, y, 5, 1);
    for(int x = 0; x < 160; x++) {
       setbmc(x, x, 0x77, 2);
       setbmc(x, x + 2, 0x52, 0);
       setbmc(x, x + 3, 0x4c, 3);
       setbmc(159 - x, x, 0x4c, 3);
       setbmc(159 - x, x + 2, 0x52, 0);
       setbmc(159 - x, x + 3, 0x77, 2);
       setbmc(x, x + YMAX - 160, 0x77, 2);
       setbmc(x, x + YMAX - 162, 0x52, 0);
       setbmc(x, x + YMAX - 163, 0x4c, 3);
       setbmc(159 - x, x + YMAX - 160, 0x4c, 3);
       setbmc(159 - x, x + YMAX - 162, 0x52, 0);
       setbmc(159 - x, x + YMAX - 163, 0x77, 2);
    }
    for(int y = 1; y < 0x7f; y++)
        for (int x = 0; x < 160; x++)
            setbmc(x, y + 16, y, 0);
    for (int y = 0; y < YMAX; y++) {
        setbmc(80, y, 0x77, 2);
        setbmc(81, y, 0x52, 1);
        setbmc(82, y, 0x4c, 3);
        setbmc(83, y, 0x52, 1);
        setbmc(85, y, 0x66, 2);
        setbmc(87, y, 0x66, 2);
    }
    /* the finish of graphics */
    fi = fopen("out1.prg", "w");
    fwrite(prg + 0xfff, 1, co, fi);
    fclose(fi);
}

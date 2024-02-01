#include<cstdio>
#include<map>
using namespace std;
#include "p4colors.h"
int abase1[4] = {0x2800, 0x3000, 0x3800, 0x9000};
int abase2[4] = {0x6800, 0x7000, 0x8000, 0x8800};
map<int, int> colscn;
unsigned char prg[65536];
void init() {
    for (int i = 0; i < 121; i++)
        colscn[p4palette[i][1]] = p4palette[i][0];
}
void setbm(int x, int y, int cs) {
    int bm = 0x4000,
        p = 312*(y >> 3) + ((x&0xfc) << 1) + y,
        px = 6 - ((x&3) << 1);
    if (y >= 192 && (y < 200 || y < 208 && x < 96)) bm = 0x6000;
    prg[bm + p] = prg[bm + p] & ~(3 << px) | cs << px;
}
#define BA 0x105e  //4190
void setbmc(int x, int y, int c, int cs) {
//cs: 0 - multicolor 1, 1 - background, 2 - foreground, 3 - multicolor 2
    int z = cs == 3;
    setbm(x, y, cs);
    switch (cs) {
    case 0:
    case 3:
        if (y%2 == 0) {
            if (y < 192)
		        prg[BA + y*17 + 5*z] = c;
		    else if (y == 192)
		        prg[BA - 4 + 2*z] = c;
		    else
		        prg[BA + 2 + y*17 + 5*z] = c;
		}
        else {
            y -= 1;
		    if (y < 192)
		        prg[BA + 14 + y*17 + 5*z] = c;
		    else if (y == 192)
		        prg[BA + 3280 + 5*z] = c;
		    else
		        prg[BA + 16 + y*17 + 5*z] = c;
		}
		return;
    case 1:
    case 2:
        int ba = abase2[y/2%4] - 0x400;
        int p = (y >> 3)*40 + (x >> 2);
        y &= 0xffe;
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
    for(int x = 0; x < 160; x++) {
       setbmc(x, x, 0x77, 2);
       setbmc(x, x + 2, 0x52, 0);
       setbmc(x, x + 3, 0x4c, 3);
       setbmc(159 - x, x, 0x4c, 3);
       setbmc(159 - x, x + 2, 0x52, 0);
       setbmc(159 - x, x + 3, 0x77, 2);
       setbmc(x, x + 96, 0x77, 2);
       setbmc(x, x + 94, 0x52, 0);
       setbmc(x, x + 93, 0x4c, 3);
       setbmc(159 - x, x + 96, 0x4c, 3);
       setbmc(159 - x, x + 94, 0x52, 0);
       setbmc(159 - x, x + 93, 0x77, 2);
    }
    for(int y = 1; y < 0x7f; y++)
        for (int x = 0; x < 160; x++)
            setbmc(x, y + 20, y, 0);
    for (int y = 0; y < 256; y++) {
        setbmc(80, y, 0x77, 2);
        setbmc(82, y, 0x77, 2);
    }
    fi = fopen("out1.prg", "w");
    fwrite(prg + 0xfff, 1, 0x8800, fi);
    fclose(fi);
}

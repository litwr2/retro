//plus4 fli converter, 2x2 pixels to the A5-world
#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <map>
using namespace std;
#define BSZ 512
#include "svn.h"
#define VS VSIZE
#define HS 160
int pic[HS][VS], picr[HS][VS], picc[HS][VS], mc1[VS], mc2[VS];
struct Cell {
   int c1, c2;
} cell[HS/4][VS/2];
int vs, hs;
#include "p4prg.cpp"
int getR(int c) {
   return c >> 16;
}
int getG(int c) {
   return (c >> 8)&255;
}
int getB(int c) {
   return c&255;
}
int main(int argc, char **argv) {
    unsigned char b[BSZ];
    char fno[80], fn[80], eno[16], *p, fbuf[2048];
    int t;
    if (argc != 3) {
        fprintf(stderr, "wrong number of arguments\n");
        return 3;
    }
    FILE *fi = fopen(argv[1], "r"), *fo;
    if (fi == 0) {
        fprintf(stderr, "%s not found\n", argv[1]);
        return 4;
    }
    p = strchr(argv[2], '.');
    if (p == 0)
        strcpy(fn, argv[2]), eno[0] = 0;
    else
        strcpy(eno, p + 1), strncpy(fn, argv[2], p - argv[2]), fn[p - argv[2]] = 0;
    fgets((char*)b, BSZ, fi);
    strcpy(fbuf, (char*)b);
    if (strstr((char*)b, "P6") != (char*)b) {
E1:     fprintf(stderr, "incorrect format\n");
        return 2;
    }
    for(;;) {
       fgets((char*)b, BSZ, fi);
       if (b[0] != '#') break;
       strcat(fbuf + strlen(fbuf), (char*)b);
    }
    t = sscanf((char*)b, "%d %d", &hs, &vs);
    if (t != 2 || hs%4 != 0 || vs%2 !=0 || hs > HS || vs > VS) goto E1;
    sprintf(fbuf + strlen(fbuf), "%d %d\n", hs*2, vs);
    fgets((char*)b, BSZ, fi);
    strcat(fbuf + strlen(fbuf), (char*)b);
    t = atoi((char*)b);
    if (t != 255) goto E1;  //wrong format
    for (int y = 0; y < vs; y++)
        for (int x = 0; x < hs; x++) {
				fread(b, 1, 3, fi);
				picc[x][y] = b[0] << 16 | b[1] << 8 | b[2];
		}
	    fclose(fi);
        for (int y = 0; y < vs; y++) {
            for (int x = 0; x < hs; x++)
                if (x >= 0 && x < hs)
                    pic[x][y] = picc[x][y];
        }
        if (eno[0] == 0)
            sprintf(fno, "%s.ppm", fn);
        else
            sprintf(fno, "%s.%s", fn, eno);
        fo = fopen(fno, "w");
        fwrite(fbuf, 1, strlen(fbuf), fo);
		for (int y = 0; y < vs; y += 2)
		    for (int x = 0; x < hs; x += 4) {
		        int m = 0, c1 = pic[x][y], c2 = c1;
				for (int ix = 0; ix < 4; ix++)
		            for (int iy = 0; iy < 2; iy++) {
		                int c = pic[x + ix][y + iy];
		                if (c != c1) {
		                    c2 = c;
		                    break;
		                }
		            }
		        cell[x/4][y/2].c1 = c1;
		        cell[x/4][y/2].c2 = c2;
			}
		for (int y = 0; y < vs; y += 2)
		    for (int x = 0; x < hs; x += 4)
		        for (int ix = 0; ix < 4; ix++)
		            for (int iy = 0; iy < 2; iy++) {
		                int c = pic[x + ix][y + iy];
		                if (c == cell[x/4][y/2].c1)
		                    picr[x + ix][y + iy] = cell[x/4][y/2].c1;
		                else
		                    picr[x + ix][y + iy] = cell[x/4][y/2].c2;
		            }
		t = 0;
		for (int y = 0; y < vs; y++)
		    for (int x = 0; x < hs; x++) {
		            if (pic[x][y] != picr[x][y]) t++;
		            b[0] = getR(picr[x][y]);
		            b[1] = getG(picr[x][y]);
		            b[2] = getB(picr[x][y]);
					fwrite(b, 1, 3, fo);
					fwrite(b, 1, 3, fo);
				};
		fclose(fo);
		fprintf(stdout, "%.4f\n", 100.*t/hs/vs);
#if 0
		for (int i = 0; i < vs; i++)
		    fprintf(stderr, "%d %06x %06x\n", i, mc1[i], mc2[i]);
		for (int y = 0; y < vs; y += 2)
		    for (int x = 0; x < hs; x += 4)
		        fprintf(stderr, "%d %d %06x %06x\n", x, y, cell[x/4][y/2].c1, cell[x/4][y/2].c2);
#endif
		fi = fopen("out.prg", "r");
		if (fi == 0) {
		    fprintf(stderr, "out.prg not found\n");
            return 5;
		}
		int co = fread(prg + 0xfff, 1, 65536, fi);
		fclose(fi);
		prginit();
		setattr();
		setbm();
		sprintf(fno, "out-a5.prg");
		fo = fopen(fno, "w");
		fwrite(prg + 0xfff, 1, co, fo);
		fclose(fo);
    return 0;
}


//simple plus4 hires converter
#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <map>
using namespace std;
#include "p4colors.h"
#define BSZ 512
#define VS 256
#define HS 320
map<int, int> colscn, n2rgb;
int pic[HS][VS];
struct Cell {
   int c1, c2;
} cell[HS/8][VS/8];
int vs, hs;
void prginit() {
    for (int i = 0; i < 128; i++)
        colscn[p4palette[i][1]] = p4palette[i][0],
        n2rgb[p4palette[i][0]] = p4palette[i][1];
    colscn[-1] = 0;
}
int main(int argc, char **argv) {
    unsigned char b[BSZ];
    int bg, err = 0;
    if (argc != 2) {
        fprintf(stderr, "wrong number of arguments\n");
        return 3;
    }
    FILE *fi = fopen(argv[1], "r");
    if (fi == 0) {
        fprintf(stderr, "%s not found\n", argv[1]);
        return 4;
    }
    fgets((char*)b, BSZ, fi);
    if (strstr((char*)b, "P6") != (char*)b) {
E1:     fprintf(stderr, "incorrect format %d\n", err);
        return 2;
    }
    for(;;) {
       fgets((char*)b, BSZ, fi);
       if (b[0] != '#') break;
    }
    err++;
    if (sscanf((char*)b, "%d %d", &hs, &vs) != 2 || hs%8 != 0 || vs%8 !=0 || hs > HS || vs > VS)
        goto E1;
    fgets((char*)b, BSZ, fi);
    err++;
    if (atoi((char*)b) != 255) goto E1;  //wrong format
    for (int y = 0; y < vs; y++)
        for (int x = 0; x < hs; x++) {
				fread(b, 1, 3, fi);
				pic[x][y] = b[0] << 16 | b[1] << 8 | b[2];
			}
	fclose(fi);
	prginit();
    bg = pic[0][0];  //heuristic!
    for (int y = 0; y < vs/8; y++)
    	for (int x = 0; x < hs/8; x++) {
    		cell[x][y].c1 = bg;
    		int fg = bg;
    		for (int yl = 0; yl < 8; yl++)
    		   for (int xl = 0; xl < 8; xl++)
    		       if (pic[x*8 + xl][y*8 + yl] != bg) fg = pic[x*8 + xl][y*8 + yl];
    		cell[x][y].c2 = fg;
    	}
    fi = fopen("pic.s", "w");
    fputs(" org $1800\n", fi);
    for (int y = 0; y < 25; y++)
	    for (int x = 0; x < 40; x++)
	        fprintf(fi, " byte $%x\n", colscn[cell[x][y].c2]/16 + (colscn[cell[x][y].c1]&0xf0));
    fputs(" org $1c00\n", fi);
    for (int y = 0; y < 25; y++)
	    for (int x = 0; x < 40; x++)
	        fprintf(fi, " byte $%x\n", (colscn[cell[x][y].c1]&15) + ((colscn[cell[x][y].c2]&15) << 4));
	fputs(" org $2000\n", fi);
    for (int y = 0; y < 199; y += 8)
	    for (int x = 0; x < 40; x++) {
	        fputs(" byte ", fi);
	        for (int yl = 0; yl < 8; yl++) {
	            int px = 0;
	            for (int xl = 0; xl < 8; xl++)
	                px = px << 1 | pic[8*x + xl][y + yl] != bg;
	            fprintf(fi, "$%x", px);
	            if (yl == 7) fputs("\n", fi); else fputs(",", fi);
	        }
	    }
	fputs(" org $4140\n", fi);
    for (int y = 200; y < 256; y += 8)
	    for (int x = 0; x < 40; x++) {
	        fputs(" byte ", fi);
	        for (int yl = 0; yl < 8; yl++) {
	            int px = 0;
	            for (int xl = 0; xl < 8; xl++)
	                px = px << 1 | pic[8*x + xl][y + yl] != bg;
	            fprintf(fi, "$%x", px);
	            if (yl == 7) fputs("\n", fi); else fputs(",", fi);
	        }
	    }
    fputs(" org $53e8\n", fi);
    for (int y = 25; y < 26; y++)
	    for (int x = 0; x < 24; x++)
    	    fprintf(fi, " byte $%x\n", colscn[cell[x][y].c2]/16 + (colscn[cell[x][y].c1]&0xf0));
    fputs(" org $57e8\n", fi);
    for (int y = 25; y < 26; y++)
	    for (int x = 0; x < 24; x++)
    	    fprintf(fi, " byte $%x\n", (colscn[cell[x][y].c1]&15) + ((colscn[cell[x][y].c2]&15) << 4));
	fputs(" org $5000\n", fi);
    for (int y = 25; y < 32; y++)
	    for (int x = 0; x < 40; x++)
	        if (y > 25 || x > 23)
    	    	fprintf(fi, " byte $%x\n", colscn[cell[x][y].c2]/16 + (colscn[cell[x][y].c1]&0xf0));
    fputs(" org $5400\n", fi);
    for (int y = 25; y < 32; y++)
	    for (int x = 0; x < 40; x++)
	        if (y > 25 || x > 23)
    	    	fprintf(fi, " byte $%x\n", (colscn[cell[x][y].c1]&15) + ((colscn[cell[x][y].c2]&15) << 4));
	fclose(fi);
    return 0;
}


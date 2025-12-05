//simple plus4 multicolor converter
#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <map>
using namespace std;
#include "p4colors.h"
#define BSZ 512
#define VS 256
#define HS 160
map<int, int> colscn, n2rgb, co, extras;
multimap<int, int> freqs;
int vs, hs, bg, fg, mc1, mc2;
int pic[HS][VS];
int* cs[4] = {&fg, &mc2, &mc1, &bg};
void prginit() {
    for (int i = 0; i < 128; i++)
        colscn[p4palette[i][1]] = p4palette[i][0],
        n2rgb[p4palette[i][0]] = p4palette[i][1];
    colscn[-1] = 0;
}
int vaddr0(int x, int y) {
    if (y < 25) return 0x1800 + y*40 + x;
    if (y == 25 && x < 24) return 0x53e8 + x;
    return 0x5000 + (y - 25)*40 + x - 24;
}
int vaddr1(int x, int y) {
    if (y < 25) return 0x800 + y*40 + x;
    if (y == 25 && x < 24) return 0x5be8 + x;
    return 0x5800 + (y - 25)*40 + x - 24;
}
int checkfg(int xi, int yi) {
    for (int x = 0; x < 4; x++)
        for (int y = 0; y < 8; y++)
            if (yi > 19 || xi > 52 && xi < 104)
            	if (colscn[pic[xi + x][yi + y]] == fg)
                	return 1;
    return 0;
}
int main(int argc, char **argv) {
    unsigned char b[BSZ];
    int err = 0, addr;
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
    err = 1;
    if (sscanf((char*)b, "%d %d", &hs, &vs) != 2 || hs%4 != 0 || vs%4 !=0 || hs > HS || vs > VS)
        goto E1;
    fgets((char*)b, BSZ, fi);
    err = 2;
    if (atoi((char*)b) != 255) goto E1;  //wrong format
    for (int y = 0; y < vs; y++)
        for (int x = 0; x < hs; x++) {
				fread(b, 1, 3, fi);
				pic[x][y] = b[0] << 16 | b[1] << 8 | b[2];
			}
	fclose(fi);
	fi = fopen("si-mc-2026-ep.txt", "r");
	if (fi == 0)
        fputs("extras data not found\n", stderr);
	for(;;) {
	    int a, v;
	    fgets((char*)b, BSZ, fi);
	    if (*b == '#' && !feof(fi)) continue;
	    if (sscanf((char*)b, "%x %x", &a, &v) != 2 || feof(fi)) break;
	    extras[a] = v;
	}
	fclose(fi);
	prginit();
    for (int y = 0; y < vs; y++)
    	for (int x = 0; x < hs; x++)
    	    co[colscn[pic[x][y]]]++;
    err = 3;
    if (co.size() != 4) goto E1;
    for (map<int, int>::iterator i = co.begin(); i != co.end(); i++)
        freqs.insert(pair<int, int>(i->second, i->first));
    for (multimap<int, int>::iterator i = freqs.begin(); i != freqs.end(); i++)
        *cs[distance(freqs.begin(), i)] = i->second;
    fi = fopen("pic-mc-fg0.s", "w");
    for (int y = 0; y < vs/8; y++)
	    for (int x = 0; x < hs/4; x++)
	        if (checkfg(x*4, y*8))
	            fprintf(fi, "  sta $%x\n  stx $%x\n", vaddr0(x, y), vaddr0(x, y) + 0x400);
    fclose(fi);
    fi = fopen("pic-mc-fg1.s", "w");
    for (int y = 0; y < vs/8; y++)
	    for (int x = 0; x < hs/4; x++)
	        if (checkfg(x*4, y*8))
	            fprintf(fi, "  sta $%x\n  stx $%x\n", vaddr1(x, y), vaddr1(x, y) + 0x400);
    fclose(fi);
    fi = fopen("pic-mc.s", "w");
    fprintf(fi, ";FG = $%x (%d)\nBG = $%x ;(%d)\nMC1 = $%x ;(%d)\nMC2 = $%x ;(%d)\n", fg, freqs.begin()->first,
        bg, next(next(next(freqs.begin())))->first, mc1, next(next(freqs.begin()))->first, mc2, next(freqs.begin())->first);
    fprintf(fi, "\n org $%x\n", addr = 0x1800);
    for (int y = 0; y < 25; y++)
	    for (int x = 0; x < 40; x++) {
	        if (extras.find(addr) != extras.end())
	            fprintf(fi, " byte $%x\n", extras[addr]);
	        else
	        	fprintf(fi, " byte $%x\n", bg/16 + (fg&0xf0));
	        addr++;
	    }
    fprintf(fi, "\n org $%x\n", addr = 0x1c00);
    for (int y = 0; y < 25; y++)
	    for (int x = 0; x < 40; x++) {
	        if (extras.find(addr) != extras.end())
	            fprintf(fi, " byte $%x\n", extras[addr]);
	        else
	        	fprintf(fi, " byte $%x\n", (fg&15) + ((bg&15) << 4));
	        addr++;
	    }
	fputs("\n org $2000\n", fi);
    for (int y = 0; y < 199; y += 8)
	    for (int x = 0; x < 40; x++) {
	        fputs(" byte ", fi);
	        for (int yl = 0; yl < 8; yl++) {
	            int px = 0;
	            for (int xl = 0; xl < 4; xl++)
	                px = px << 2 | colscn[pic[4*x + xl][y + yl]] == bg | (colscn[pic[4*x + xl][y + yl]] == fg)*2 | (colscn[pic[4*x + xl][y + yl]] == mc2)*3;
	            fprintf(fi, "$%x", px);
	            if (yl == 7) fputs("\n", fi); else fputs(",", fi);
	        }
	    }
	fputs("\n org $4140\n", fi);
    for (int y = 200; y < 256; y += 8)
	    for (int x = 0; x < 40; x++) {
	        fputs(" byte ", fi);
	        for (int yl = 0; yl < 8; yl++) {
	            int px = 0;
	            for (int xl = 0; xl < 4; xl++)
	                px = px << 2 | colscn[pic[4*x + xl][y + yl]] == bg | (colscn[pic[4*x + xl][y + yl]] == fg)*2 | (colscn[pic[4*x + xl][y + yl]] == mc2)*3;
	            fprintf(fi, "$%x", px);
	            if (yl == 7) fputs("\n", fi); else fputs(",", fi);
	        }
	    }
    fputs("\n org $53e8\n", fi);
    for (int y = 25; y < 26; y++)
	    for (int x = 0; x < 24; x++)
    	    fprintf(fi, " byte $%x\n", bg/16 + (fg&0xf0));
    fputs("\n org $57e8\n", fi);
    for (int y = 25; y < 26; y++)
	    for (int x = 0; x < 24; x++)
    	    fprintf(fi, " byte $%x\n", (fg&15) + ((bg&15) << 4));
	fputs("\n org $5000\n", fi);
    for (int y = 25; y < 32; y++)
	    for (int x = 0; x < 40; x++)
	        if (y > 25 || x > 23)
    	    	fprintf(fi, " byte $%x\n", bg/16 + (fg&0xf0));
    fputs("\n org $5400\n", fi);
    for (int y = 25; y < 32; y++)
	    for (int x = 0; x < 40; x++)
	        if (y > 25 || x > 23)
    	    	fprintf(fi, " byte $%x\n", (fg&15) + ((bg&15) << 4));
	fclose(fi);
    return 0;
}


#include "p4colors.h"
int abase1[4] = {0x2800, 0x3000, 0x3800, 0x9000};
int abase2[4] = {0x9800, 0x7000, 0x8000, 0x8800};
map<int, int> colscn;
unsigned char prg[65536];
void prginit() {
    for (int i = 0; i < 121; i++) 
        colscn[p4palette[i][1]] = p4palette[i][0];
    colscn[-1] = 0;
}
void setbm() {
    for (int y = 0; y < vs; y++)
        for (int x = 0; x < hs; x++) {
			int bm = 0x4000,
				p = 312*(y >> 3) + ((x&0xfc) << 1) + y,
				px = 6 - ((x&3) << 1),
				cs = 3;
			if (y >= 192 && (y < 200 || y < 208 && x < 96)) bm = 0x6000;
			if (picr[x][y] == cell[x/4][y/2].c1) cs = 1;
			else if (picr[x][y] == cell[x/4][y/2].c2) cs = 2;
			else if (picr[x][y] == mc2[y]) cs = 0;
			prg[bm + p] = prg[bm + p] & ~(3 << px) | cs << px;
	    }
}
void setattr(void) {
    for (int x = 0; x < hs/4; x++)
        for (int y = 0; y < vs; y += 2) {
            int c1 = colscn[cell[x][y/2].c1],
                c2 = colscn[cell[x][y/2].c2],
                ba = abase2[y/2%4] - 0x400,
                p = (y >> 3)*40 + x;
            if (y < 192) ba = abase1[y/2%4];
            else if (y < 200 || y < 208 && x < 24) ba = abase2[y/2%4];
            prg[ba + p] = c2 & 0xf0 | (c1 & 0xf0) >> 4;
            prg[ba + p + 0x400] = c2 & 15 | (c1 & 15) << 4;
        }
}
#define BA 0x1066  //4198
void setmc(void) {
    for (int y = 0; y < vs; y++) {
        int c[2] = {colscn[mc2[y]], colscn[mc1[y]]};
        for (int z = 0; z < 2; z++)
		    if (y%2 == 0) {
		        if (y < 192)
				    prg[BA + y*17 + 5*z] = c[z];
				else if (y == 192)
				    prg[BA - 4 + 2*z] = c[z];
				else
				    prg[BA + 2 + y*17 + 5*z] = c[z];
			}
		    else {
				if (y < 193)
				    prg[BA - 3 + y*17 + 5*z] = c[z];
				else if (y == 193)
				    prg[BA + 3280 + 5*z] = c[z];
				else
				    prg[BA - 1 + y*17 + 5*z] = c[z];
			}
    }
}


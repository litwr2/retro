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
void setpa(int x, int y, int c, int cs) {
//cs: 0 - multicolor 1, 1 - background, 2 - foreground, 3 - multicolor 2
    int z = cs == 3;
    int p, ba;
    setbm(x, y, cs);
    switch (cs) {
    case 0:
    case 3:
        p = BA + y*17 + 5*z;
        if (y%2 == 0)
            if (y < 192)
		        prg[p] = c;
		    else if (y == 192)
		        prg[BA - 4 + 2*z] = c;
		    else
		        prg[p + 2] = c;
        else
		    if (y < 193)
		        prg[p - 3] = c;
		    else
		        prg[p - 1] = c;
		return;
    case 1:
    case 2:
        p = (y >> 3)*40 + (x >> 2);
        ba = abase2[y/2%4] - 0x400;
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


int getcs(int x, int y, int *px) {
    int bm = 0x4000,
        p = 312*(y >> 3) + ((x&0xfc) << 1) + y;
    *px = 6 - ((x&3) << 1);
    if (y >= 192 && (y < 200 || y < 208 && x < 96)) bm = 0x6000;
    return (prg[bm + p] & (3 << *px)) >> *px;
}
int getcsaddr(int x, int y) {
    int bm = 0x4000,
        p = 312*(y >> 3) + ((x&0xfc) << 1) + y;
    if (y >= 192 && (y < 200 || y < 208 && x < 96)) bm = 0x6000;
    return bm + p;
}
int getnextxaddr(int addr, int x, int y) {
    if (x == 96 && y >= 200 && y < 208) return 0x6000 + y - 200;
    return addr + 8;
}
int getnextyaddr(int addr, int x, int y) {
    if ((y&7) < 7) return addr + 1;
    return getcsaddr(x, y + 1);
}
int getcsbyte(int x, int y) {
    return prg[getcsaddr(x, y)];
}
void setmc(int y, int mc1, int mc2) {
    int c[2] = {mc1, mc2};
    for (int z = 0; z < 2; z++) {
		int p = BA + y*17 + 5*z;
		if (y%2 == 0)
		    if (y < 192)
			    prg[p] = c[z];
			else if (y == 192)
			    prg[BA - 4 + 2*z] = c[z];
			else
			    prg[p + 2] = c[z];
		else
			if (y < 193)
			    prg[p - 3] = c[z];
			else
			    prg[p - 1] = c[z];
    }
}
void getpa(int x, int y, int *cs, int *bg, int *fg, int *mc1, int *mc2) {
//cs: 0 - multicolor 1, 1 - background, 2 - foreground, 3 - multicolor 2
    int p, ba, cc, cl;
    *cs = getcs(x, y, &p);
    p = BA + y*17;
    if (y%2 == 0)
        if (y < 192)
	        *mc1 = prg[p];
		else if (y == 192)
		    *mc1 = prg[BA - 4];
		else
		    *mc1 = prg[p + 2];
    else
		if (y < 193)
		    *mc1 = prg[p - 3];
		else
		    *mc1 = prg[p - 1];
    p += 5;
    if (y%2 == 0)
        if (y < 192)
	        *mc2 = prg[p];
		else if (y == 192)
		    *mc2 = prg[BA - 2];
		else
		    *mc2 = prg[p + 2];
    else
		if (y < 193)
		    *mc2 = prg[p - 3];
		else
		    *mc2 = prg[p - 1];
    p = (y >> 3)*40 + (x >> 2);
    ba = abase2[y/2%4] - 0x400;
    if (y < 192) ba = abase1[y/2%4];
    else if (y < 200 || y < 208 && x < 96) ba = abase2[y/2%4];
    cc = prg[ba + p + 0x400];
    cl = prg[ba + p];
    *bg = (cc & 0xf0) >> 4 | (cl & 0xf) << 4;
    *fg = (cc & 0xf) | (cl & 0xf0);
}
int getcolor(int x, int y) {
//cs: 0 - multicolor 1, 1 - background, 2 - foreground, 3 - multicolor 2
    int p, ba, cs, cc, cl;
    cs = getcs(x, y, &p);
    if (cs == 0 || cs == 3) {
        int z = cs == 3;
        p = BA + y*17 + 5*z;
        if (y%2 == 0)
            if (y < 192)
		        return prg[p];
		    else if (y == 192)
		        return prg[BA - 4 + 2*z];
		    else
		        return prg[p + 2];
        else
		    if (y < 193)
		        return prg[p - 3];
		    else
		        return prg[p - 1];
    }
    p = (y >> 3)*40 + (x >> 2);
    ba = abase2[y/2%4] - 0x400;
    if (y < 192) ba = abase1[y/2%4];
    else if (y < 200 || y < 208 && x < 96) ba = abase2[y/2%4];
    cc = prg[ba + p + 0x400];
    cl = prg[ba + p];
    if (cs == 1)
        return (cc & 0xf0) >> 4 | (cl & 0xf) << 4;
    else
        return (cc & 0xf) | (cl & 0xf0);
}


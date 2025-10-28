int getaddr22(int x, int y) {  //x, y are doubled
    int ba, p;
    p = (y >> 2)*40 + (x >> 1);
    ba = abase2[y&3] - 0x400;
    if (y < 96) ba = abase1[y&3];
    else if (y < 100 || y < 104 && x < 48) ba = abase2[y&3];
    return ba + p;
}
int nextaddr22(int addr, int x, int y) {  //x, y are doubled
    int a;
    a = addr + 1;
    if (x == 48 && y >=100 && y < 104) a = abase2[y&3];
    return a;
}
int getcolor22(int x, int y) {  //x, y are doubled
    int addr, cs, cc, cl;  //cs: 1 - background, 2 - foreground
    addr = getaddr22(x, y);
    if ((x&1) == 0) cs = 2; else cs = 1;
    cc = prg[addr + 0x400];
    cl = prg[addr];
    if (cs == 1)
        return cc >> 4 | cl << 4;
    else
        return cc & 0xf | cl & 0xf0;
}
int getcolor22f(int addr, int cs) {  //x, y are doubled
    int cc, cl;  //cs: 1 - background, 2 - foreground
    cc = prg[addr + 0x400];
    cl = prg[addr];
    if (cs == 1)
        return cc >> 4 | cl << 4;
    else
        return cc & 0xf | cl & 0xf0;
}
void setcolor22(int x, int y, int c) {  //x, y are doubled
    int addr, cs, cc, cl;  //cs: 1 - background, 2 - foreground
    addr = getaddr22(x, y);
    if ((x&1) == 0) cs = 2; else cs = 1;
    cc = prg[addr + 0x400];
    cl = prg[addr];
    if (cs == 1)
        prg[addr + 0x400] = cc & 0xf | c << 4, prg[addr] = cl & 0xf0 | c >> 4;
    else
        prg[addr + 0x400] = cc & 0xf0 | c & 0xf, prg[addr] = cl & 0xf | c & 0xf0;
}
void setcolor22f(int addr, int cs, int c) {  //x, y are doubled
    int cc, cl;  //cs: 1 - background, 2 - foreground
    cc = prg[addr + 0x400];
    cl = prg[addr];
    if (cs == 1)
        prg[addr + 0x400] = cc & 0xf | c << 4, prg[addr] = cl & 0xf0 | c >> 4;
    else
        prg[addr + 0x400] = cc & 0xf0 | c & 0xf, prg[addr] = cl & 0xf | c & 0xf0;
}
void setcolu22(int x, int y, int co, int lu) {  //x, y are doubled
    int p, ba;
    p = (y >> 2)*40 + (x >> 1);
    ba = abase2[y&3] - 0x400;
    if (y < 96) ba = abase1[y&3];
    else if (y < 100 || y < 104 && x < 48) ba = abase2[y&3];
    prg[ba + p + 0x400] = co;
    prg[ba + p] = lu;
}

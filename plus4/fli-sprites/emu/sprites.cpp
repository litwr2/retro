struct Sprite {
    static const int xsize = 16, ysize = 16;
    unsigned char data[xsize][ysize], saved[xsize][ysize];
    unsigned char xpos, ypos, xindex, yindex;
    int color[2], visible;
    void put0() {
        for (int i = 0; i < xsize; i++)
            for (int k = 0; k < ysize; k++) {
                if (data[i][k] == 3)
                    smap[xpos + i][ypos + k] = saved[(i + xindex)&0xf][(k + yindex)&0xf]^0x7f;
                else if (data[i][k] == 0)
                    smap[xpos + i][ypos + k] = saved[(i + xindex)&0xf][(k + yindex)&0xf];
                else
                    smap[xpos + i][ypos + k] = color[data[i][k] - 1];
            }
    }
    void put() {
        if (visible) return;
        xindex = yindex = 0;
        for (int i = 0; i < xsize; i++)
            for (int k = 0; k < ysize; k++) {
                saved[i][k] = smap[xpos + i][ypos + k];
                if (data[i][k] == 3)
                    smap[xpos + i][ypos + k] = smap[xpos + i][ypos + k]^0x7f;
                else if (data[i][k] != 0)
                    smap[xpos + i][ypos + k] = color[data[i][k] - 1];
            }
        visible = 1;
    }
    void remove() {
        if (!visible) return;
        for (int i = 0; i < xsize; i++)
            for (int k = 0; k < ysize; k++)
            	smap[xpos + i][ypos + k] = saved[(i + xindex)&0xf][(k + yindex)&0xf];
        visible = 0;
    }
    int left0() {
        if (xpos == 0) return 0;
        xpos--;
        if (!visible) return 0;
        if (xindex == 0) xindex = xsize - 1; else xindex--;
        for (int i = 0; i < ysize; i++)
            smap[xpos + xsize][ypos + i] = saved[xindex][(i + yindex)&0xf],
            saved[xindex][(i + yindex)&0xf] = smap[xpos][ypos + i];
        return 1;
    }
    void left() {
        if (left0()) put0();
    }
    int right0() {
        if (xpos + xsize == xmax) return 0;
        if (!visible) {xpos++; return 0;}
        for (int i = 0; i < ysize; i++)
            smap[xpos][ypos + i] = saved[xindex][(i + yindex)&0xf],
            saved[xindex][(i + yindex)&0xf] = smap[xpos + xsize][ypos + i];
        xindex++;
        if (xindex == xsize) xindex = 0;
        xpos++;
        return 1;
    }
    void right() {
        if (right0()) put0();
    }
    int up0() {
        if (ypos == 0) return 0;
        ypos--;
        if (!visible) return 0;
        if (yindex == 0) yindex = ysize - 1; else yindex--;
        for (int i = 0; i < xsize; i++)
            smap[xpos + i][ypos + ysize] = saved[(i + xindex)&0xf][yindex],
            saved[(i + xindex)&0xf][yindex] = smap[xpos + i][ypos];
		return 1;
    }
    void up() {
        if (up0()) put0();
    }
    int down0() {
        if (ypos + ysize == ymax) return 0;
        if (!visible) {ypos++; return 0;}
        for (int i = 0; i < xsize; i++)
            smap[xpos + i][ypos] = saved[(i + xindex)&0xf][yindex],
            saved[(i + xindex)&0xf][yindex] = smap[xpos + i][ypos + ysize];
        yindex++;
        if (yindex == ysize) yindex = 0;
        ypos++;
        return 1;
    }
    void down() {
        if (down0()) put0();
    }
    void upleft() {
        if ((ypos&&xpos) == 0) return;
        ypos--, xpos--;
        if (!visible) return;
        int oyindex = yindex, oxindex = xindex;
        if (yindex == 0) yindex = ysize - 1; else yindex--;
        if (xindex == 0) xindex = xsize - 1; else xindex--;
        for (int i = 0; i < xsize; i++)
            smap[xpos + i + 1][ypos + ysize] = saved[(i + oxindex)&0xf][yindex],
            saved[(i + xindex)&0xf][yindex] = smap[xpos + i][ypos];
        for (int i = 0; i < ysize - 1; i++)
            smap[xpos + xsize][ypos + i + 1] = saved[xindex][(i + oyindex)&0xf],
            saved[xindex][(i + 1 + yindex)&0xf] = smap[xpos][ypos + i + 1];
        put0();
    }
    void downright() {
        if (xpos + xsize == xmax) return;
        if (down0() && right0()) put0();
    }
    void downleft() {
        if (xpos == 0) return;
        if (down0() && left0()) put0();
    }
    void upright() {
        if (xpos + xsize == xmax) return;
        if (up0() && right0()) put0();
    }
    Sprite(int x, int y, int c0, int c1) {
         xpos = x, ypos = y;
         visible = 0;
         color[0] = c0;
         color[1] = c1;
         for (int x = 0; x < xsize; x++)
            for (int y = 0; y < ysize; y++)
                 if (x < 2 || y < 2 || x > 13 || y > 13)
                     data[x][y] = 1;
                 else if (x < 4 || y < 4 || x > 11 || y > 11)
                     data[x][y] = 0;
                 else if (x < 6 || y < 6 || x > 9 || y > 9)
                     data[x][y] = 2;
                 else
                     data[x][y] = 3;
    }
};

Sprite s1(7, 70, 0, 0x7e);


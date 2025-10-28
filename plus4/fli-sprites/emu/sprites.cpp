unsigned char s6data[18][4] = {
   0x00,0x05,0x50,0x00,
   0x00,0x55,0x55,0x00,
   0x01,0x55,0x55,0x40,
   0x01,0x55,0x55,0x40,
   0x05,0x95,0x55,0x50,
   0x0a,0xa9,0x55,0xa0,
   0x0a,0xaa,0xaa,0xa0,
   0x02,0xa6,0x9a,0x80,
   0x00,0xa6,0x9a,0x00,
   0x02,0x6a,0xa9,0x80,
   0x0a,0x5a,0xa5,0xa0,
   0x2a,0x55,0x55,0xa8,
   0x2a,0x55,0x55,0xa8,
   0x0a,0x95,0x56,0xa0,
   0x02,0xaa,0xaa,0x80,
   0x02,0xa8,0x2a,0x80,
   0x02,0xa8,0x2a,0x80,
   0x00,0x54,0x15,0x00
}, s6colors[2][18] = {
  0x68,0x68,0x68,0x68,0x68,0x68,0x68,0x6d,0x6d,0x5b,0x5b,0x5b,0x5b,0x5b,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x72,0x72,0x72,0x72,0x72,0x72,0x72,0x72,0x72,0x46,0x46,0x46,0x48,0x21
};
unsigned char s7data[1][4] = {
   0x55,0x55,0x55,0x00
}, s7colors[2][1] = {0x68, 0x68};
unsigned char tab1[16] = {0xa5, 0xa0, 0xaf, 0xa3, 0x5, 0, 0xf, 0x3, 0xf5, 0xf0, 0xff, 0xf3, 0x35, 0x30, 0x3f, 0x33},
              tab2[16] = {0xa5, 0xa0, 0xaf, 0xac, 0x5, 0, 0xf, 0xc, 0xf5, 0xf0, 0xff, 0xfc, 0xc5, 0xc0, 0xcf, 0xcc},
              tab3t[4] = {0xa5, 5, 0xf5, 0x35},
              tab3b[4] = {0xa5, 5, 0xf5, 0xc5},
              tab5t[4] = {0xa5, 0xa0, 0xaf, 0xa3},
              tab5b[4] = {0xa5, 0xa0, 0xaf, 0xac};

struct Sprite {
    static const int xsize = 16, ysize = 16;
    unsigned char data[xsize/4][ysize];  //0 - transparent, 1 - mc1, 2 - mc2, 3 - mc1 and mc2 dithering
    unsigned char xpos, ypos;
    unsigned char color[ysize][2], visible;
/*    int get2(int x, int y) {
        return (data[x/4][y] >> (x&3)*2)&3;
    }*/
    void set2(int x, int y, int v) {
        unsigned char a = data[x/4][y];
        int b = 6 - (x&3)*2;
        data[x/4][y] = a & ~(3 << b) | v << b;
    }
    void put00(int h) {
        int addr;
        unsigned char d, nd;
        for (int y = 0; y < ysize; y++) {
            if (h) {
                setmc(ypos + 2*y, color[y]);
                setmc(ypos + 2*y + 1, color[y]);
            }
            addr = getcsaddr(xpos, ypos + 2*y);  //getnextyaddr()
            d = data[0][y];
            if (xpos&2) {
                nd  = d >> 6;
                prg[addr] = tab5t[nd];
                prg[addr + 1] = tab5b[nd];

	            addr = getnextxaddr(addr, xpos + 2, ypos + 2*y);
	            nd = (d & 0x3f) >> 2;
	            prg[addr] = tab1[nd];
		        prg[addr + 1] = tab2[nd];
		        for (int x = 1; x < xsize/4; x++) {
                    d = (d & 3) << 6 | data[x][y] >> 2;
                    addr = getnextxaddr(addr, xpos + 8*x - 2, ypos + 2*y);
		            nd  = d >> 4;
		            prg[addr] = tab1[nd];
		            prg[addr + 1] = tab2[nd];

                    addr = getnextxaddr(addr, xpos + 8*x + 2, ypos + 2*y);
		            nd = d & 0xf;
		            prg[addr] = tab1[nd];
		            prg[addr + 1] = tab2[nd];
		            d = data[x][y];
                }
                addr = getnextxaddr(addr, xpos + 30, ypos + 2*y);
                nd = d & 3;
                prg[addr] = tab3t[nd];
                prg[addr + 1] = tab3b[nd];
            } else {
                nd  = d >> 4;
	            prg[addr] = tab1[nd];
	            prg[addr + 1] = tab2[nd];

	            addr = getnextxaddr(addr, xpos + 4, ypos + 2*y);
	            nd = d & 0xf;
	            prg[addr] = tab1[nd];
		        prg[addr + 1] = tab2[nd];
                for (int x = 1; x < 4; x++) {
		            addr = getnextxaddr(addr, xpos + 8*x, ypos + 2*y);
                    d = data[x][y];
		            nd  = d >> 4;
		            prg[addr] = tab1[nd];
		            prg[addr + 1] = tab2[nd];

		            addr = getnextxaddr(addr, xpos + 8*x + 4, ypos + 2*y);
		            nd = d & 0xf;
		            prg[addr] = tab1[nd];
		            prg[addr + 1] = tab2[nd];
                }
            }
        }
    }
    void put0(int h) {
        if (!visible) return;
        put00(h);
    }
    void put() {
        if (visible) return;
        put00(1);
        visible = 1;
    }
    void remove() {
        int addr;
        if (!visible) return;
        for (int y = 0; y < ysize; y++) {
            addr = getcsaddr(xpos, ypos + 2*y);  //getnextyaddr()
            if (xpos&2) {
                prg[addr + 1] = prg[addr] = prg[addr] & 0xf0 | 5;
	            addr = getnextxaddr(addr, xpos + 2, ypos + 2*y);
                prg[addr + 1] = prg[addr] = 0xa5;
		        for (int x = 1; x < xsize/4; x++) {
		            addr = getnextxaddr(addr, xpos + 8*x - 2, ypos + 2*y);
                    prg[addr + 1] = prg[addr] = 0xa5;

		            addr = getnextxaddr(addr, xpos + 8*x + 2, ypos + 2*y);
                    prg[addr + 1] = prg[addr] = 0xa5;
                }
                addr = getnextxaddr(addr, xpos + 30, ypos + 2*y);
                prg[addr + 1] = prg[addr] = prg[addr] & 0xf | 0xa0;
            } else {
	            prg[addr + 1] = prg[addr] = 0xa5;
	            addr = getnextxaddr(addr, xpos + 4, ypos + 2*y);
	            prg[addr + 1] = prg[addr] = 0xa5;
	            for (int x = 1; x < xsize/4; x++) {
		            addr = getnextxaddr(addr, xpos + 8*x, ypos + 2*y);
		            prg[addr + 1] = prg[addr] = 0xa5;

		            addr = getnextxaddr(addr, xpos + 8*x + 4, ypos + 2*y);
		            prg[addr + 1] = prg[addr] = 0xa5;
                }
            }
        }
        visible = 0;
    }
    void left0() {
        int addr, d;
        xpos -= 2;
        if (!visible) return;
        addr = getcsaddr(xpos + 2*xsize, ypos);  //getnextyaddr()
        if (xpos&2) {
            d = prg[addr] << 4;
	        prg[addr] = (d == 0x50 ? 0xa0 : d) | 5;
	        d = prg[addr + 1] << 4;
	        prg[addr + 1] = (d == 0x50 ? 0xa0 : d) | 5;
            for (int y = 1; y < ysize; y++) {
                if (((ypos + 2*y)&7) == 0)
                    addr = getcsaddr(xpos + 2*xsize, ypos + 2*y);
                else
                    addr += 2;
	            d = prg[addr] << 4;
		        prg[addr] = (d == 0x50 ? 0xa0 : d) | 5;
		        d = prg[addr + 1] << 4;
		        prg[addr + 1] = (d == 0x50 ? 0xa0 : d) | 5;
            }
        } else {
            prg[addr + 1] = prg[addr] = 0xa5;
        	for (int y = 1; y < ysize; y++) {
                if (((ypos + 2*y)&7) == 0)
                	addr = getcsaddr(xpos + 2*xsize, ypos + 2*y);
                else
                    addr += 2;
                prg[addr + 1] = prg[addr] = 0xa5;
            }
        }
    }
    void left() {
        if (xpos == 0) return;
        left0();
        put0(0);
    }
#if 1
    void right0() {
        if (!visible) {xpos += 2; return;}
        remove();
        visible = 1;
        //for (int y = 0; y < ysize; y++)
        //    setpa22rr(xpos, ypos + 2*y);
        xpos += 2;
        put00(0);
    }
#else
     void right0() {
        int addr, d;
        xpos += 2;
        if (!visible) return;
        addr = getcsaddr(xpos - 2, ypos);  //getnextyaddr()
        if (xpos&2) {
            d = prg[addr] >> 4;
	        prg[addr] = 0xa0 | (d == 0xa ? 5 : d);
	        d = prg[addr + 1] >> 4;
	        prg[addr + 1] = 0xa0 | (d == 0xa ? 5 : d);
            for (int y = 1; y < ysize; y++) {
                if (((ypos + 2*y)&7) == 0)
                    addr = getcsaddr(xpos - 2, ypos + 2*y);
                else
                    addr += 2;
	            prg[addr] = 0xa0 | prg[addr] >> 4;
    	        prg[addr + 1] = 0xa0 | prg[addr + 1] >> 4;
            }
        } else {
            prg[addr + 1] = prg[addr] = 0xa5;
        	for (int y = 1; y < ysize; y++) {
                if (((ypos + 2*y)&7) == 0)
                	addr = getcsaddr(xpos - 2, ypos + 2*y);
                else
                    addr += 2;
                prg[addr + 1] = prg[addr] = 0xa5;
            }
        }
    }
#endif
    void right() {
        if (xpos + 2*xsize == xmax) return;
        right0();
        put0(0);
    }
    void up0() {
        int addr, p;
        ypos -= 2;
        if (!visible) return;
        p = xpos & 0xfc;
        addr = getcsaddr(xpos, ypos + 2*ysize);  //getnextyaddr()
        prg[addr + 1] = prg[addr] = 0xa5;
        for (int x = 1; x < xsize/2 + ((xpos&2)>>1); x++) {
            addr = getnextxaddr(addr, p + 4*x, ypos + 2*ysize);
	        prg[addr + 1] = prg[addr] = 0xa5;
        }
    }
    /*void up0() {
        ypos -= 2;
        if (!visible) return;
        for (int x = 0; x < xsize; x++)
            setpa22rr(xpos + 2*x, ypos + 2*ysize);
    }*/
    void up() {
        if (ypos == 0) return;
        up0();
        put0(1);
    }
    void down0() {
        int addr, p;
        if (!visible) {ypos += 2; return;}
        p = xpos & 0xfc;
        addr = getcsaddr(xpos, ypos);  //getnextyaddr()
        prg[addr + 1] = prg[addr] = 0xa5;
        for (int x = 1; x < xsize/2 + ((xpos&2)>>1); x++) {
            addr = getnextxaddr(addr, p + 4*x, ypos);
	        prg[addr + 1] = prg[addr] = 0xa5;
        }
        ypos += 2;
    }
    void down() {
        if (ypos + 2*ysize == ymax) return;
        down0();
        put0(1);
    }
    void upleft() {
        if (xpos == 0 || ypos == 0) return;
        up0();
        left0();
        put0(1);
    }
    void downright() {
        if (xpos + 2*xsize == xmax || ypos + 2*ysize == ymax) return;
        down0();
        right0();
        put0(1);
    }
    void downleft() {
        if (xpos == 0 || ypos + 2*ysize == ymax) return;
        down0();
        left0();
        put0(1);
    }
    void upright() {
        if (xpos + 2*xsize == xmax || ypos == 0) return;
        up0();
        right0();
        put0(1);
    }
    void fill_square() {
        for (int x = 0; x < xsize; x++)
            for (int y = 0; y < ysize; y++)
                 if (x < 2 || y < 2 || x > 13 || y > 13)
                     set2(x, y, 1);
                 else if (x < 4 || y < 4 || x > 11 || y > 11)
                     set2(x, y, 0);
                 else if (x < 6 || y < 6 || x > 9 || y > 9)
                     set2(x, y, 2);
                 else
                     set2(x, y, 3);
    }
    void fill_sphere() {
        for (int x = 0; x < xsize; x++)
            for (int y = 0; y < ysize; y++) {
                 double dx = x - (xsize - 1)/2., dy = y - (ysize - 1)/2.; 
                 if (dx*dx + dy*dy > 57)
                     set2(x, y, 0);
                 else if (dx*dx + dy*dy > 49)  //43
                     set2(x, y, 2);
                 else if (dx*dx + dy*dy > 36)
                     set2(x, y, 1);
                 else if (dx*dx + dy*dy > 16)
                     set2(x, y, 3);
                 else
                     set2(x, y, 0);
            }
    }
    void fill_rectangle(int f) {
        for (int x = 0; x < xsize; x++)
            for (int y = 0; y < ysize; y++)
                set2(x, y, f);
    }
    Sprite(int x, int y, unsigned char (*c)[2]) {
         xpos = x, ypos = y;
         visible = 0;
         for (int y = 0; y < ysize; y++)
             for (int k = 0; k < 2; k++)
                 color[y][k] = c[k][y];
         //fill_square();
         fill_sphere();
         //fill_rectangle(1);
         for (y = 0; y < ysize; y++) {
            for (x = 0; x < xsize/4 - 1; x++)
                printf("$%02x, ", data[x][y]);
            printf("$%02x\n", data[xsize/4 - 1][y]);
         }
         for (x = 0; x < 2; x++) {
             for (y = 0; y < ysize - 1; y++)
                printf("$%02x, ", color[y][x]);
            printf("$%02x\n", color[y][x]);
         }
    }
    Sprite(int x, int y, unsigned char (*d)[4], unsigned char (*co)[ysize]) {
         xpos = x, ypos = y;
         visible = 0;
         for (int y = 0; y < ysize; y++)
             for (int i = 0; i < 2; i++)
                 color[y][i] = co[i][y];
         for (int y = 0; y < ysize; y++)
             for (int i = 0; i < xsize/4; i++)
                 data[i][y] = d[y][i];
         for (y = 0; y < ysize; y++) {
            for (x = 0; x < xsize/4 - 1; x++)
                printf("$%02x, ", data[x][y]);
            printf("$%02x\n", data[xsize/4 - 1][y]);
         }
         for (x = 0; x < 2; x++) {
             for (y = 0; y < ysize - 1; y++)
                printf("$%02x, ", color[y][x]);
            printf("$%02x\n", color[y][x]);
         }
    }
};

unsigned char colors1[16][2] = {
{0, 0x7e},
{0, 0x6e},
{0, 0x5e},
{0, 0x4e},
{0, 0x3e},
{0, 0x2e},
{0x53, 0x5d},
{0x63, 0x4d},
{0x63, 0x4d},
{0x53, 0x5d},
{0, 0x2e},
{0, 0x3e},
{0, 0x4e},
{0, 0x5e},
{0, 0x6e},
{0, 0x7e}};
Sprite s1(70, 202, colors1);
//Sprite s1(70, 202, s6data, s6colors);
//Sprite s1(72, 204, s7data, s7colors);

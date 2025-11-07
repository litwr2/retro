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
unsigned char s3data[2][2] = {
  0x66,0x66,
  0x99,0x99
}, s3colors[2][2] = {
  0x7e, 0x6e,
  0x53, 0x42};
unsigned char s7data[1][4] = {
   0x55,0x55,0x55,0x00
}, s7colors[2][1] = {0x68, 0x68};
unsigned char tab1[256] = {
0xa5, 0xa4, 0xa7, 0xa6, 0xa1, 0xa0, 0xa3, 0xa2, 0xad, 0xac, 0xaf, 0xae, 0xa9, 0xa8, 0xab, 0xaa,
0x85, 0x84, 0x87, 0x86, 0x81, 0x80, 0x83, 0x82, 0x8d, 0x8c, 0x8f, 0x8e, 0x89, 0x88, 0x8b, 0x8a,
0xb5, 0xb4, 0xb7, 0xb6, 0xb1, 0xb0, 0xb3, 0xb2, 0xbd, 0xbc, 0xbf, 0xbe, 0xb9, 0xb8, 0xbb, 0xba,
0x95, 0x94, 0x97, 0x96, 0x91, 0x90, 0x93, 0x92, 0x9d, 0x9c, 0x9f, 0x9e, 0x99, 0x98, 0x9b, 0x9a,
0x25, 0x24, 0x27, 0x26, 0x21, 0x20, 0x23, 0x22, 0x2d, 0x2c, 0x2f, 0x2e, 0x29, 0x28, 0x2b, 0x2a,
0x05, 0x04, 0x07, 0x06, 0x01, 0x00, 0x03, 0x02, 0x0d, 0x0c, 0x0f, 0x0e, 0x09, 0x08, 0x0b, 0x0a,
0x35, 0x34, 0x37, 0x36, 0x31, 0x30, 0x33, 0x32, 0x3d, 0x3c, 0x3f, 0x3e, 0x39, 0x38, 0x3b, 0x3a,
0x15, 0x14, 0x17, 0x16, 0x11, 0x10, 0x13, 0x12, 0x1d, 0x1c, 0x1f, 0x1e, 0x19, 0x18, 0x1b, 0x1a,
0xe5, 0xe4, 0xe7, 0xe6, 0xe1, 0xe0, 0xe3, 0xe2, 0xed, 0xec, 0xef, 0xee, 0xe9, 0xe8, 0xeb, 0xea,
0xc5, 0xc4, 0xc7, 0xc6, 0xc1, 0xc0, 0xc3, 0xc2, 0xcd, 0xcc, 0xcf, 0xce, 0xc9, 0xc8, 0xcb, 0xca,
0xf5, 0xf4, 0xf7, 0xf6, 0xf1, 0xf0, 0xf3, 0xf2, 0xfd, 0xfc, 0xff, 0xfe, 0xf9, 0xf8, 0xfb, 0xfa,
0xd5, 0xd4, 0xd7, 0xd6, 0xd1, 0xd0, 0xd3, 0xd2, 0xdd, 0xdc, 0xdf, 0xde, 0xd9, 0xd8, 0xdb, 0xda,
0x65, 0x64, 0x67, 0x66, 0x61, 0x60, 0x63, 0x62, 0x6d, 0x6c, 0x6f, 0x6e, 0x69, 0x68, 0x6b, 0x6a,
0x45, 0x44, 0x47, 0x46, 0x41, 0x40, 0x43, 0x42, 0x4d, 0x4c, 0x4f, 0x4e, 0x49, 0x48, 0x4b, 0x4a,
0x75, 0x74, 0x77, 0x76, 0x71, 0x70, 0x73, 0x72, 0x7d, 0x7c, 0x7f, 0x7e, 0x79, 0x78, 0x7b, 0x7a,
0x55, 0x54, 0x57, 0x56, 0x51, 0x50, 0x53, 0x52, 0x5d, 0x5c, 0x5f, 0x5e, 0x59, 0x58, 0x5b, 0x5a};

struct Sprite {
    static const int xsize = 16, ysize = 18;
    unsigned char data[xsize/4][ysize];  //0 - transparent, 1 - mc1, 2 - mc2, 3 - bg inversion
    unsigned char xpos, ypos;
    unsigned char color[ysize][2], visible;
    void set2(int x, int y, int v) {
        unsigned char a = data[x/4][y];
        int b = 6 - (x&3)*2;
        data[x/4][y] = a & ~(3 << b) | v << b;
    }
    void put00(int h) {
        int addr, x;
        unsigned char d, nd, z = xpos&3;
        for (int y = 0; y < ysize; y++) {
            if (h)
                setmc(ypos + y, color[y][0], color[y][1]);
            addr = getcsaddr(xpos, ypos + y);  //getnextyaddr()
            d = data[0][y];
            if (z) {
                prg[addr] = tab1[d >> 2*z];
		        for (x = 1; x < xsize/4; x++) {
                    addr = getnextxaddr(addr, (xpos & 0xfc) + 4*x, ypos + y);
                    nd = data[x][y];
		            prg[addr] = tab1[(unsigned char)(d << 8 - 2*z | nd >> 2*z)];
		            d = nd;
                }
                addr = getnextxaddr(addr, (xpos & 0xfc) + 4*x, ypos + y);
                prg[addr] = tab1[(unsigned char)(d << 8 - 2*z)];
            } else {
	            prg[addr] = tab1[d];
                for (int x = 1; x < xsize/4; x++) {
		            addr = getnextxaddr(addr, xpos + 4*x, ypos + y);
                    nd = data[x][y];
		            prg[addr] = tab1[nd];
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
        int addr, x, p, l;
        if (!visible) return;
        p = xpos&0xfc;
        l = xsize/4 + ((xpos&3) != 0);
        for (int y = 0; y < ysize; y++) {
            addr = getcsaddr(xpos, ypos + y);  //getnextyaddr()
            prg[addr] = 0xa5;
            for (int x = 1; x < l; x++) {
	            addr = getnextxaddr(addr, p + 4*x, ypos + y);
	            prg[addr] = 0xa5;
            }
        }
        visible = 0;
    }
    void left0() {
        int addr;
        xpos--;
        if (!visible) return;
        if ((xpos&3) == 0) {
            addr = getcsaddr(xpos + xsize, ypos);  //getnextyaddr()
	        prg[addr] = 0xa5;
            for (int y = 1; y < ysize; y++) {
                if (((ypos + y)&7) == 0)
                    addr = getcsaddr(xpos + xsize, ypos + y);
                else
                    addr++;
		        prg[addr] = 0xa5;
            }
        }
    }
    void left() {
        if (xpos == 0) return;
        left0();
        put0(0);
    }
#if 0
    void right0() {
        if (!visible) {xpos++; return;}
        remove();
        visible = 1;
        //for (int y = 0; y < ysize; y++)
        //    setpa22rr(xpos, ypos + 2*y);
        xpos++;
        put00(0);
    }
#else
     void right0() {
        int addr;
        xpos++;
        if (!visible) return;
        if ((xpos&3) == 0) {
            addr = getcsaddr(xpos - 1, ypos);  //getnextyaddr()
	        prg[addr] = 0xa5;
            for (int y = 1; y < ysize; y++) {
                if (((ypos + y)&7) == 0)
                    addr = getcsaddr(xpos - 1, ypos + y);
                else
                    addr++;
	            prg[addr] = 0xa5;
            }
        }
    }
#endif
    void right() {
        if (xpos + xsize == xmax) return;
        right0();
        put0(0);
    }
    void up0() {
        int addr, p, l;
        ypos--;
        if (!visible) return;
        addr = getcsaddr(xpos, ypos + ysize);  //getnextyaddr()
        prg[addr] = 0xa5;
        l = xsize/4 + ((xpos&3) != 0);
        p = xpos & 0xfc;
        for (int x = 1; x < l; x++) {
            addr = getnextxaddr(addr, p + 4*x, ypos + ysize);
	        prg[addr] = 0xa5;
        }
    }
    void up() {
        if (ypos == 0) return;
        up0();
        put0(1);
    }
    void down0() {
        int addr, p, l;
        if (!visible) {ypos++; return;}
        p = xpos & 0xfc;
        addr = getcsaddr(xpos, ypos);  //getnextyaddr()
        prg[addr] = 0xa5;
        l = xsize/4 + ((xpos&3) != 0);
        for (int x = 1; x < l; x++) {
            addr = getnextxaddr(addr, p + 4*x, ypos);
	        prg[addr] = 0xa5;
        }
        ypos++;
    }
    void down() {
        if (ypos + ysize == ymax) return;
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
                 color[y][k] = c[y][k];
         //fill_square();
         //fill_sphere();
         fill_rectangle(2);
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
    Sprite(int x, int y, unsigned char (*d)[xsize/4], unsigned char (*co)[ysize]) {
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
//Sprite s1(87, 201, colors1);
Sprite s1(70, 22, s6data, s6colors);  //202
//Sprite s1(72, 204, s6data, s6colors);
//Sprite s1(0, 0, s3data, s3colors);


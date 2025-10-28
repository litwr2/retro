struct Sprite {
    static const int xsize = 16, ysize = 16;
    unsigned char data[xsize/4][ysize];  //0 - transparent, 1 - mc1, 2 - mc2, 3 - mc1 and mc2 dithering
    unsigned char xpos, ypos;
    unsigned char color[ysize][2], visible;
    int get2(int x, int y) {
        return (data[x/4][y] >> (6 - (x&3)*2))&3;
    }
    void set2(int x, int y, int v) {
        unsigned char a = data[x/4][y];
        int b = 6 - (x&3)*2;
        data[x/4][y] = a & ~(3 << b) | v << b;
    }
    void put0() {
        if (!visible) return;
        for (int y = 0; y < ysize; y++) {
            setmc(2*(ypos + y), color[y]);
            setmc(2*(ypos + y) + 1, color[y]);
            for (int x = 0; x < xsize; x++) {
                int d = get2(x, y);
                if (d == 3)
                    setpa22mcd(xpos + x, ypos + y);
                else if (d == 0)
                    setpa22rr(xpos + x, ypos + y);
                else
                    setpa22mc(xpos + x, ypos + y, d^1);
            }
        }
    }
    void put() {
        if (visible) return;
        for (int y = 0; y < ysize; y++) {
            setmc(2*(ypos + y), color[y]);
            setmc(2*(ypos + y) + 1, color[y]);
            for (int x = 0; x < xsize; x++) {
                int d = get2(x, y);
                if (d == 3)
                    setpa22mcd(xpos + x, ypos + y);
                else if (d != 0)
                    setpa22mc(xpos + x, ypos + y, d^1);
            }
        }
        visible = 1;
    }
    void remove() {
        if (!visible) return;
        for (int i = 0; i < xsize; i++)
            for (int k = 0; k < ysize; k++)
            	setpa22rr(xpos + i, ypos + k);
        visible = 0;
    }
    void left0() {
        xpos--;
        if (!visible) return;
        for (int i = 0; i < ysize; i++)
            setpa22rr(xpos + xsize, ypos + i);
    }
    void left() {
        if (xpos == 0) return;
        left0();
        put0();
    }
    void right0() {
        if (!visible) {xpos++; return;}
        for (int i = 0; i < ysize; i++)
            setpa22rr(xpos, ypos + i);
        xpos++;
    }
    void right() {
        if (xpos + xsize == xmax/2) return;
        right0();
        put0();
    }
    void up0() {
        ypos--;
        if (!visible) return;
        for (int i = 0; i < xsize; i++)
            setpa22rr(xpos + i, ypos + ysize);
    }
    void up() {
        if (ypos == 0) return;
        up0();
        put0();
    }
    void down0() {
        if (!visible) {ypos++; return;}
        for (int i = 0; i < xsize; i++)
            setpa22rr(xpos + i, ypos);
        ypos++;
    }
    void down() {
        if (ypos + ysize == ymax/2) return;
        down0();
        put0();
    }
    void upleft() {
        if (xpos == 0 || ypos == 0) return;
        up0();
        left0();
        put0();
    }
    void downright() {
        if (xpos + xsize == xmax/2 || ypos + ysize == ymax/2) return;
        down0();
        right0();
        put0();
    }
    void downleft() {
        if (xpos == 0 || ypos + ysize == ymax/2) return;
        down0();
        left0();
        put0();
    }
    void upright() {
        if (xpos + xsize == xmax/2 || ypos == 0) return;
        up0();
        right0();
        put0();
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
         for (int i = 0; i < ysize; i++)
             for (int k = 0; k < 2; k++)
                 color[i][k] = c[i][k];
         fill_square();
         //fill_sphere();
         //fill_rectangle(3);
         for (y = 0; y < ysize; y++) {
            for (x = 0; x < xsize/4 - 1; x++)
                printf("%02x ", data[x][y]);
            printf("%02x\n", data[xsize/4 - 1][y]);
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
Sprite s1(41, 101, colors1);


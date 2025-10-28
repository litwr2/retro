#define XSIZE 2
#define YSIZE 2
struct Sprite2 {
    static const int xsize = XSIZE, ysize = YSIZE;
    unsigned char data[xsize][ysize], saved[xsize][ysize];  //4-7 - lum, 0-3 - color
    unsigned char xpos, ypos, xindex, yindex;
    unsigned char visible;
    void put00() {
        int addr, x;
        unsigned int b1, b2;
        for (int y = 0; y < ysize; y++) {
            x = 0;
            addr = getaddr22(xpos, y + ypos);
            if ((xpos&1) == 0) {
                if (data[x][y] == 0)
		            b1 = saved[(x + xindex)%xsize][(y + yindex)%ysize];
		        else
		            b1 = data[x][y];
		        if (data[x + 1][y] == 0)
		            b2 = saved[(x + 1 + xindex)%xsize][(y + yindex)%ysize];
		        else
		            b2 = data[x + 1][y];
	            prg[addr] = b1 & 0xf0 | b2 >> 4;
                prg[addr + 0x400] = b1 & 0xf | b2 << 4;
		        for (x = 2; x < xsize; x += 2) {
		            addr = nextaddr22(addr, x + xpos, y + ypos);
	                if (data[x][y] == 0)
			            b1 = saved[(x + xindex)%xsize][(y + yindex)%ysize];
			        else
			            b1 = data[x][y];
			        if (data[x + 1][y] == 0)
			            b2 = saved[(x + 1 + xindex)%xsize][(y + yindex)%ysize];
			        else
			            b2 = data[x + 1][y];
 	                prg[addr] = b1 & 0xf0 | b2 >> 4;
                    prg[addr + 0x400] = b1 & 0xf | b2 << 4;
			    }
	        } else {
                if (data[0][y])
                    b1 = data[0][y];
	            else
	                b1 = saved[xindex][(y + yindex)%ysize];
                prg[addr] = prg[addr] & 0xf0 | b1 >> 4;
                prg[addr + 0x400] = prg[addr + 0x400] & 0xf | b1 << 4;
		        for (x = 1; x < xsize - 1; x += 2) {
		            addr = nextaddr22(addr, x + xpos, y + ypos);
	                if (data[x][y] == 0)
			            b1 = saved[(x + xindex)%xsize][(y + yindex)%ysize];
			        else
			            b1 = data[x][y];
			        if (data[x + 1][y] == 0)
			            b2 = saved[(x + 1 + xindex)%xsize][(y + yindex)%ysize];
			        else
			            b2 = data[x + 1][y];
	                prg[addr] = b1 & 0xf0 | b2 >> 4;
                    prg[addr + 0x400] = b1 & 0xf | b2 << 4;
			    }
			    addr = nextaddr22(addr, x + xpos, y + ypos);
			    if (data[x][y])
                    b2 = data[x][y];
	            else
	                b2 = saved[(x + xindex)%xsize][(y + yindex)%ysize];
	            prg[addr] = prg[addr] & 0xf | b2 & 0xf0;
	            prg[addr + 0x400] = prg[addr + 0x400] & 0xf0 | b2 & 0xf;
	        }
	    } 
    }
    void put0() {
        if (!visible) return;
        put00();
    }
    void put() {
        int addr;
        unsigned char cl, cc, b1, b2, x;
        if (visible) return;
        xindex = yindex = 0;
        for (int y = 0; y < ysize; y++) {
            addr = getaddr22(xpos, y + ypos);
            if ((xpos&1) == 0) {
                cc = prg[addr + 0x400];
                cl = prg[addr];
                saved[0][y] = cc & 0xf | cl & 0xf0;
            	saved[1][y] = cc >> 4 | cl << 4;
                if ((data[0][y] | data[1][y]) == 0);
	            else {
			        if (data[0][y] == 0)
			            b1 = saved[0][y],
		                b2 = data[1][y];
			        else if (data[1][y] == 0)
			            b1 = data[0][y],
		                b2 = saved[1][y];
			        else
			            b1 = data[0][y],
			            b2 = data[1][y];
			        prg[addr] = b1 & 0xf0 | b2 >> 4;
		            prg[addr + 0x400] = b1 & 0xf | b2 << 4;
                }
		        for (x = 2; x < xsize; x += 2) {
		            addr = nextaddr22(addr, x + xpos, y + ypos);
		            cc = prg[addr + 0x400];
                    cl = prg[addr];
                    saved[x][y] = cc & 0xf | cl & 0xf0;
            	    saved[x + 1][y] = cc >> 4 | cl << 4;
			        if ((data[x][y] | data[x + 1][y]) == 0);
			        else {
					    if (data[x][y] == 0)
			                b1 = saved[x][y],
		                    b2 = data[x + 1][y];
			            else if (data[x + 1][y] == 0)
			                b1 = data[x][y],
		                    b2 = saved[x + 1][y];
			            else
			                b1 = data[x][y],
			                b2 = data[x + 1][y];
			            prg[addr] = b1 & 0xf0 | b2 >> 4;
		                prg[addr + 0x400] = b1 & 0xf | b2 << 4;
                    }
			    }
            } else {
                cc = prg[addr + 0x400];
                cl = prg[addr];
                saved[0][y] = cc >> 4 | cl << 4;
                if (data[0][y])
                    b1 = data[0][y],
                    prg[addr] = cl & 0xf0 | b1 >> 4,
                    prg[addr + 0x400] = cc & 0xf | b1 << 4;
		        for (x = 1; x < xsize - 1; x += 2) {
		            addr = nextaddr22(addr, x + xpos, y + ypos);
		            cc = prg[addr + 0x400];
                    cl = prg[addr];
                    saved[x][y] = cc & 0xf | cl & 0xf0;
            	    saved[x + 1][y] = (cc & 0xf0) >> 4 | (cl & 0xf) << 4;
			        if ((data[x][y] | data[x + 1][y]) == 0);
			        else {
					    if (data[x][y] == 0)
			                b1 = saved[x][y],
		                    b2 = data[x + 1][y];
			            else if (data[x + 1][y] == 0)
			                b1 = data[x][y],
		                    b2 = saved[x + 1][y];
			            else
			                b1 = data[x][y],
			                b2 = data[x + 1][y];
			            prg[addr] = b1 & 0xf0 | b2 >> 4;
		                prg[addr + 0x400] = b1 & 0xf | b2 << 4;
                    }
			    }
			    addr = nextaddr22(addr, x + xpos, y + ypos);
			    cc = prg[addr + 0x400];
                cl = prg[addr];
                saved[x][y] = cc & 0xf | cl & 0xf0;
			    if (data[x][y])
                    b2 = data[x][y],
	                prg[addr] = cl & 0xf | b2 & 0xf0,
	                prg[addr + 0x400] = cc & 0xf0 | b2 & 0xf;
	        }
        }
        visible = 1;
    }
    void remove() {
        int addr;
        unsigned char cl, cc, b1, b2, x;
        if (!visible) return;
        for (int y = 0; y < ysize; y++) {
            addr = getaddr22(xpos, y + ypos);
            if ((xpos&1) == 0) {
                b1 = saved[xindex][(y + yindex)%ysize];
                b2 = saved[(1 + xindex)%xsize][(y + yindex)%ysize];
                prg[addr] = b2 >> 4 | b1 & 0xf0;
                prg[addr + 0x400] = b2 << 4 | b1 & 0xf;
                for (x = 2; x < xsize; x += 2) {
                    addr = nextaddr22(addr, x + xpos, y + ypos);
                    b1 = saved[(x + xindex)%xsize][(y + yindex)%ysize];
                    b2 = saved[(x + 1 + xindex)%xsize][(y + yindex)%ysize];
                    prg[addr] = b2 >> 4 | b1 & 0xf0;
                    prg[addr + 0x400] = b2 << 4 | b1 & 0xf;
	            }
            } else {
                b2 = saved[xindex][(y + yindex)%ysize];
                prg[addr] = prg[addr] & 0xf0 | b2 >> 4;
                prg[addr + 0x400] = prg[addr + 0x400] & 0xf | b2 << 4;
                for (x = 1; x < xsize - 1; x += 2) {
                    addr = nextaddr22(addr, x + xpos, y + ypos);
                    b1 = saved[(x + xindex)%xsize][(y + yindex)%ysize];
                    b2 = saved[(x + 1 + xindex)%xsize][(y + yindex)%ysize];
                    prg[addr] = b2 >> 4 | b1 & 0xf0;
                    prg[addr + 0x400] = b2 << 4 | b1 & 0xf;
	            }
	            addr = nextaddr22(addr, x + xpos, y + ypos);
	            b1 = saved[(x + xindex)%xsize][(y + yindex)%ysize];
	            prg[addr] = prg[addr] & 0xf | b1 & 0xf0;
	            prg[addr + 0x400] = prg[addr + 0x400] & 0xf0 | b1 & 0xf;
            }
        }
        visible = 0;
    }
    void left0() {
        xpos--;
        if (!visible) return;
        if (xindex == 0) xindex = xsize - 1; else xindex--;
        for (int y = 0; y < ysize; y++)
            setcolor22(xpos + xsize, ypos + y, saved[xindex][(y + yindex)%ysize]),
            saved[xindex][(y + yindex)%ysize] = getcolor22(xpos, ypos + y);
    }
    void left() {
        if (xpos == 0) return;
        left0();
        put0();
    }
#if 0
    void right0() {
        if (!visible) {xpos++; return;}
        remove();
        visible = 0;
        xpos++;
        put();
    }
#else
     void right0() {
        if (!visible) {xpos++; return;}
        for (int y = 0; y < ysize; y++)
            setcolor22(xpos, ypos + y, saved[xindex][(y + yindex)%ysize]),
            saved[xindex][(y + yindex)%ysize] = getcolor22(xpos + xsize, ypos + y);
        xindex++;
        if (xindex == xsize) xindex = 0;
        xpos++;
    }
#endif
    void right() {
        if (xpos + xsize == xmax/2) return;
        right0();
        put0();
    }
    void up0() {
        int addr;
        unsigned char cl, cc, b1, b2, x;
        ypos--;
        if (!visible) return;
        if (yindex == 0) yindex = ysize - 1; else yindex--;
        addr = getaddr22(xpos, ypos + ysize);
        if ((xpos&1) == 0) {
            b2 = saved[(xindex + 1)%xsize][yindex];
            b1 = saved[xindex][yindex];
            prg[addr] = b1 & 0xf0 | b2 >> 4;
            prg[addr + 0x400] = b1 & 0xf | b2 << 4;
            for (x = 2; x < xsize; x += 2)
		        addr = nextaddr22(addr, x + xpos, ypos + ysize),
		        b2 = saved[(xindex + x + 1)%xsize][yindex],
                b1 = saved[(x + xindex)%xsize][yindex],
                prg[addr] = b1 & 0xf0 | b2 >> 4,
                prg[addr + 0x400] = b1 & 0xf | b2 << 4;
	    } else {
            b2 = saved[xindex][yindex];
            prg[addr] = prg[addr] & 0xf0 | b2 >> 4;
            prg[addr + 0x400] = prg[addr + 0x400] & 0xf | b2 << 4;
            for (x = 1; x < xsize - 1; x += 2) {
		        addr = nextaddr22(addr, x + xpos, ypos + ysize),
		        b2 = saved[(xindex + x + 1)%xsize][yindex],
                b1 = saved[(x + xindex)%xsize][yindex],
                prg[addr] = b1 & 0xf0 | b2 >> 4,
                prg[addr + 0x400] = b1 & 0xf | b2 << 4;
		    }
		    addr = nextaddr22(addr, x + xpos, ypos + ysize);
            b1 = saved[(x + xindex)%xsize][yindex];
            prg[addr] = prg[addr] & 0xf | b1 & 0xf0;
            prg[addr + 0x400] = prg[addr + 0x400] & 0xf0 | b1 & 0xf;
	    }
	    addr = getaddr22(xpos, ypos);
        if ((xpos&1) == 0) {
            cc = prg[addr + 0x400];
            cl = prg[addr];
            saved[(xindex + 1)%xsize][yindex] = cc >> 4 | cl << 4;
            saved[xindex][yindex] = cc & 0xf | cl & 0xf0;
            for (x = 2; x < xsize; x += 2)
   		        addr = nextaddr22(addr, x + xpos, ypos),
                cc = prg[addr + 0x400],
                cl = prg[addr],
                saved[(xindex + x + 1)%xsize][yindex] = cc >> 4 | cl << 4,
                saved[(xindex + x)%xsize][yindex] = cc & 0xf | cl & 0xf0;
	    } else {
            saved[xindex][yindex] = prg[addr + 0x400] >> 4 | prg[addr] << 4;
            for (x = 1; x < xsize - 1; x += 2) {
   		        addr = nextaddr22(addr, x + xpos, ypos),
                cc = prg[addr + 0x400],
                cl = prg[addr],
                saved[(xindex + x + 1)%xsize][yindex] = cc >> 4 | cl << 4,
                saved[(xindex + x)%xsize][yindex] = cc & 0xf | cl & 0xf0;
		    }
	        addr = nextaddr22(addr, x + xpos, ypos);
            cc = prg[addr + 0x400];
            cl = prg[addr];
            saved[(xindex + x)%xsize][yindex] = cc & 0xf | cl & 0xf0;
	    }
    }
    void up() {
        if (ypos == 0) return;
        up0();
        put0();
    }
    void down0() {
        int addr;
        unsigned char cl, cc, b1, b2, x;
        if (!visible) {ypos++; return;}
        addr = getaddr22(xpos, ypos);
        if ((xpos&1) == 0) {
            b2 = saved[(xindex + 1)%xsize][yindex];
            b1 = saved[xindex][yindex];
            prg[addr] = b1 & 0xf0 | b2 >> 4;
            prg[addr + 0x400] = b1 & 0xf | b2 << 4;
            for (x = 2; x < xsize; x += 2)
                addr = nextaddr22(addr, x + xpos, ypos),
		        b2 = saved[(xindex + x + 1)%xsize][yindex],
                b1 = saved[(x + xindex)%xsize][yindex],
                prg[addr] = b1 & 0xf0 | b2 >> 4,
                prg[addr + 0x400] = b1 & 0xf | b2 << 4;
	    } else {
            b2 = saved[xindex][yindex];
            prg[addr] = prg[addr] & 0xf0 | b2 >> 4;
            prg[addr + 0x400] = prg[addr + 0x400] & 0xf | b2 << 4;
            for (x = 1; x < xsize - 1; x += 2) {
                addr = nextaddr22(addr, x + xpos, ypos),
		        b2 = saved[(xindex + x + 1)%xsize][yindex],
                b1 = saved[(x + xindex)%xsize][yindex],
                prg[addr] = b1 & 0xf0 | b2 >> 4,
                prg[addr + 0x400] = b1 & 0xf | b2 << 4;
		    }
		    addr = nextaddr22(addr, x + xpos, ypos);
            b1 = saved[(x + xindex)%xsize][yindex];
            prg[addr] = prg[addr] & 0xf | b1 & 0xf0;
            prg[addr + 0x400] = prg[addr + 0x400] & 0xf0 | b1 & 0xf;
	    }
        addr = getaddr22(xpos, ypos + ysize);
        if ((xpos&1) == 0) {
            cc = prg[addr + 0x400];
            cl = prg[addr];
            saved[(xindex + 1)%xsize][yindex] = cc >> 4 | cl << 4;
            saved[xindex][yindex] = cc & 0xf | cl & 0xf0;
            for (x = 2; x < xsize; x += 2)
   		        addr = nextaddr22(addr, x + xpos, ypos + ysize),
                cc = prg[addr + 0x400],
                cl = prg[addr],
                saved[(xindex + x + 1)%xsize][yindex] = cc >> 4 | cl << 4,
                saved[(xindex + x)%xsize][yindex] = cc & 0xf | cl & 0xf0;
	    } else {
            saved[xindex][yindex] = prg[addr + 0x400] >> 4 | prg[addr] << 4;
            for (x = 1; x < xsize - 1; x += 2) {
   		        addr = nextaddr22(addr, x + xpos, ypos + ysize),
                cc = prg[addr + 0x400],
                cl = prg[addr],
                saved[(xindex + x + 1)%xsize][yindex] = cc >> 4 | cl << 4,
                saved[(xindex + x)%xsize][yindex] = cc & 0xf | cl & 0xf0;
		    }
	        addr = nextaddr22(addr, x + xpos, ypos + ysize);
            saved[(xindex + x)%xsize][yindex] = prg[addr + 0x400] & 0xf | prg[addr] & 0xf0;
	    }
        yindex++;
        if (yindex == ysize) yindex = 0;
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
                     data[x][y] = 0x52;
                 else if (x < 4 || y < 4 || x > 11 || y > 11)
                     data[x][y] = 0x00;
                 else if (x < 6 || y < 6 || x > 9 || y > 9)
                     data[x][y] = 0x77;
                 else
                     data[x][y] = 0x64;
    }
    void fill_sphere() {
        for (int x = 0; x < xsize; x++)
            for (int y = 0; y < ysize; y++) {
                 double dx = x - (xsize - 1)/2., dy = y - (ysize - 1)/2.; 
                 if (dx*dx + dy*dy > 57)
                     data[x][y] = 0x55;
                 else if (dx*dx + dy*dy > 49)  //43
                     data[x][y] = 0x52;
                 else if (dx*dx + dy*dy > 36)
                     data[x][y] = 0x77;
                 else if (dx*dx + dy*dy > 16)
                     data[x][y] = 0x00;
                 else
                     data[x][y] = 0x6e;
            }
    }
    void fill_rectangle(int f) {
        for (int x = 0; x < xsize; x++)
            for (int y = 0; y < ysize; y++)
                data[x][y] = f;
    }
    Sprite2(int x, int y) {
         xpos = x, ypos = y;
         visible = 0;
         //fill_square();
         fill_sphere();
         //fill_rectangle(2);
         for (y = 0; y < ysize; y++) {
            for (x = 0; x < xsize - 1; x++)
                printf("$%02x, ", data[x][y]);
            printf("$%02x\n", data[xsize - 1][y]);
         }
    }
    Sprite2(int x, int y, unsigned char * d) {
         xpos = x, ypos = y;
         visible = 0;
         for (y = 0; y < ysize; y++)
            for (x = 0; x < xsize; x++)
               data[x][y] = d[y*xsize + x];
         for (y = 0; y < ysize; y++) {
            for (x = 0; x < xsize - 1; x++)
                printf("$%02x, ", data[x][y]);
            printf("$%02x\n", data[xsize - 1][y]);
         }
    }
};

//Sprite2 s1(16, 101);
unsigned char d1[] = {0,0x62,
                      0x6f,0};
//unsigned char d1[] = {0x62,0x62,0,0,
//                      0,0,0x66,0x66};
Sprite2 s1(40,100,d1);

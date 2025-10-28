#define XSIZE 16
#define YSIZE 16
struct Sprite2 {
    static const int xsize = XSIZE, ysize = YSIZE;
    unsigned char data[xsize][ysize], saved[xsize][ysize];  //4-7 - lum, 0-3 - color
    unsigned char xpos, ypos, xindex, yindex;
    unsigned char visible;
    void put00() {
        int addr;
        for (int y = 0; y < ysize; y++) {
            addr = getaddr22(xpos, y + ypos);
            if ((xpos&1) == 0) {
                if (data[0][y])
	                setcolor22f(addr, 2, data[0][y]);
	            else
	                setcolor22f(addr, 2, saved[xindex%xsize][(y + yindex)%ysize]);
	            if (data[1][y])
	                setcolor22f(addr, 1, data[1][y]);
	            else
	                setcolor22f(addr, 1, saved[(1 + xindex)%xsize][(y + yindex)%ysize]);
		        for (int x = 2; x < xsize; x += 2) {
		            addr = nextaddr22(addr, x + xpos, y + ypos);
			        if (data[x][y])
			            setcolor22f(addr, 2, data[x][y]);
			        else
			            setcolor22f(addr, 2, saved[(x + xindex)%xsize][(y + yindex)%ysize]);
			        if (data[x + 1][y])
			            setcolor22f(addr, 1, data[x + 1][y]);
			        else
			            setcolor22f(addr, 1, saved[(x + 1 + xindex)%xsize][(y + yindex)%ysize]);
			    }
	        } else {
                if (data[0][y])
	                setcolor22f(addr, 1, data[0][y]);
	            else
	                setcolor22f(addr, 1, saved[xindex%xsize][(y + yindex)%ysize]);
		        for (int x = 1;; x += 2) {
		            addr = nextaddr22(addr, x + xpos, y + ypos);
			        if (data[x][y])
			            setcolor22f(addr, 2, data[x][y]);
			        else
			            setcolor22f(addr, 2, saved[(x + xindex)%xsize][(y + yindex)%ysize]);
			        if (x == xsize - 1) break;
			        if (data[x + 1][y])
			            setcolor22f(addr, 1, data[x + 1][y]);
			        else
			            setcolor22f(addr, 1, saved[(x + 1 + xindex)%xsize][(y + yindex)%ysize]);
			    }
	        }
	    } 
    }
    void put0() {
        if (!visible) return;
        put00();
    }
    void put() {
        int addr;
        if (visible) return;
        xindex = yindex = 0;
        for (int y = 0; y < ysize; y++) {
            addr = getaddr22(xpos, y + ypos);
            if ((xpos&1) == 0) {
            	saved[0][y] = getcolor22f(addr, 2);
            	saved[1][y] = getcolor22f(addr, 1);
                if (data[0][y])
            		setcolor22f(addr, 2, data[0][y]);
                if (data[1][y])
            		setcolor22f(addr, 1, data[1][y]);
	        	for (int x = 2; x < xsize; x += 2) {
	            	addr = nextaddr22(addr, x + xpos, y + ypos);
	            	saved[x][y] = getcolor22f(addr, 2);
	            	saved[x + 1][y] = getcolor22f(addr, 1);
            	    if (data[x][y])
            	    	setcolor22f(addr, 2, data[x][y]);
            	    if (data[x + 1][y])
            	    	setcolor22f(addr, 1, data[x + 1][y]);
            	}
            } else {
                saved[0][y] = getcolor22f(addr, 1);
                if (data[0][y])
            		setcolor22f(addr, 1, data[0][y]);
	        	for (int x = 1;; x += 2) {
	            	addr = nextaddr22(addr, x + xpos, y + ypos);
	            	saved[x][y] = getcolor22f(addr, 2);
            	    if (data[x][y])
            	    	setcolor22f(addr, 2, data[x][y]);
            	    if (x == xsize - 1) break;
	            	saved[x + 1][y] = getcolor22f(addr, 1);
            	    if (data[x + 1][y])
            	    	setcolor22f(addr, 1, data[x + 1][y]);
            	}
            }
        }
        visible = 1;
    }
    void remove() {
        int addr;
        if (!visible) return;
        for (int y = 0; y < ysize; y++) {
            addr = getaddr22(xpos, y + ypos);
            if ((xpos&1) == 0) {
                setcolor22f(addr, 2, saved[xindex%xsize][(y + yindex)%ysize]);
                setcolor22f(addr, 1, saved[(1 + xindex)%xsize][(y + yindex)%ysize]);
                for (int x = 2; x < xsize; x += 2) {
                    addr = nextaddr22(addr, x + xpos, y + ypos);
	                setcolor22f(addr, 2, saved[(x + xindex)%xsize][(y + yindex)%ysize]);
	                setcolor22f(addr, 1, saved[(x + 1 + xindex)%xsize][(y + yindex)%ysize]);
	            }
            } else {
                setcolor22f(addr, 1, saved[xindex%xsize][(y + yindex)%ysize]);
                for (int x = 1;; x += 2) {
                    addr = nextaddr22(addr, x + xpos, y + ypos);
	                setcolor22f(addr, 2, saved[(x + xindex)%xsize][(y + yindex)%ysize]);
	                if (x == xsize - 1) break;
	                setcolor22f(addr, 1, saved[(x + 1 + xindex)%xsize][(y + yindex)%ysize]);
	            }
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
        int addr1, addr2;
        ypos--;
        if (!visible) return;
        if (yindex == 0) yindex = ysize - 1; else yindex--;
        addr1 = getaddr22(xpos, ypos);
        addr2 = getaddr22(xpos, ypos + ysize);
        if ((xpos&1) == 0) {
        	setcolor22f(addr2, 2, saved[xindex%xsize][yindex]);
        	saved[xindex%xsize][yindex] = getcolor22f(addr1, 2);
        	setcolor22f(addr2, 1, saved[(xindex + 1)%xsize][yindex]);
        	saved[(xindex + 1)%xsize][yindex] = getcolor22f(addr1, 1);
            for (int x = 2; x < xsize; x += 2)
		        addr1 = nextaddr22(addr1, x + xpos, ypos),
		        addr2 = nextaddr22(addr2, x + xpos, ypos + ysize),
		        setcolor22f(addr2, 2, saved[(x + xindex)%xsize][yindex]),
		        saved[(x + xindex)%xsize][yindex] = getcolor22f(addr1, 2),
		        setcolor22f(addr2, 1, saved[(x + 1 + xindex)%xsize][yindex]),
		        saved[(x + 1 + xindex)%xsize][yindex] = getcolor22f(addr1, 1);
	    } else {
        	setcolor22f(addr2, 1, saved[xindex%xsize][yindex]);
        	saved[xindex%xsize][yindex] = getcolor22f(addr1, 1);
            for (int x = 1;; x += 2) {
		        addr1 = nextaddr22(addr1, x + xpos, ypos),
		        addr2 = nextaddr22(addr2, x + xpos, ypos + ysize),
		        setcolor22f(addr2, 2, saved[(x + xindex)%xsize][yindex]),
		        saved[(x + xindex)%xsize][yindex] = getcolor22f(addr1, 2);
		        if (x == xsize - 1) break;
		        setcolor22f(addr2, 1, saved[(x + 1 + xindex)%xsize][yindex]),
		        saved[(x + 1 + xindex)%xsize][yindex] = getcolor22f(addr1, 1);
		    }
	    }
    }
    void up() {
        if (ypos == 0) return;
        up0();
        put0();
    }
    void down0() {
        int addr1, addr2;
        if (!visible) {ypos++; return;}
        addr1 = getaddr22(xpos, ypos);
        addr2 = getaddr22(xpos, ypos + ysize);
        if ((xpos&1) == 0) {
        	setcolor22f(addr1, 2, saved[xindex%xsize][yindex]);
        	saved[xindex%xsize][yindex] = getcolor22f(addr2, 2);
        	setcolor22f(addr1, 1, saved[(xindex + 1)%xsize][yindex]);
        	saved[(xindex + 1)%xsize][yindex] = getcolor22f(addr2, 1);
            for (int x = 2; x < xsize; x += 2)
		        addr1 = nextaddr22(addr1, x + xpos, ypos),
		        addr2 = nextaddr22(addr2, x + xpos, ypos + ysize),
		        setcolor22f(addr1, 2, saved[(x + xindex)%xsize][yindex]),
		        saved[(x + xindex)%xsize][yindex] = getcolor22f(addr2, 2),
		        setcolor22f(addr1, 1, saved[(x + 1 + xindex)%xsize][yindex]),
		        saved[(x + 1 + xindex)%xsize][yindex] = getcolor22f(addr2, 1);
	    } else {
        	setcolor22f(addr1, 1, saved[xindex%xsize][yindex]);
        	saved[xindex%xsize][yindex] = getcolor22f(addr2, 1);
            for (int x = 1;; x += 2) {
		        addr1 = nextaddr22(addr1, x + xpos, ypos),
		        addr2 = nextaddr22(addr2, x + xpos, ypos + ysize),
		        setcolor22f(addr1, 2, saved[(x + xindex)%xsize][yindex]),
		        saved[(x + xindex)%xsize][yindex] = getcolor22f(addr2, 2);
		        if (x == xsize - 1) break;
		        setcolor22f(addr1, 1, saved[(x + 1 + xindex)%xsize][yindex]),
		        saved[(x + 1 + xindex)%xsize][yindex] = getcolor22f(addr2, 1);
		    }
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
};

Sprite2 s1(16, 101);


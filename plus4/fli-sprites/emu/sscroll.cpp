#define assign0(a,y) prg[a + 1024 + 40*(y) + x] = prg[a + 1024 + 40*((y) + 1) + x], prg[a + 40*(y) + x] = prg[a + 40*((y) + 1) + x]
#define assign1(a,b,y) prg[a + 1024 + 40*(y) + x] = prg[b + 1024 + 40*((y) + 1) + x], prg[a + 40*(y) + x] = prg[b + 40*((y) + 1) + x]
void sscroll_up4f() {
    unsigned char sco, slu;
    int bau, bal, y;
    for (int x = 0; x < 40; x++)
        bau = 0x2800,
        sco = prg[bau + 0x400 + x], slu = prg[bau + x],
        assign0(bau, 0),
        assign0(bau, 1),
        assign0(bau, 2),
        assign0(bau, 3),
        assign0(bau, 4),
        assign0(bau, 5),
        assign0(bau, 6),
        assign0(bau, 7),
        assign0(bau, 8),
        assign0(bau, 9),
        assign0(bau, 10),
        assign0(bau, 11),
        assign0(bau, 12),
        assign0(bau, 13),
        assign0(bau, 14),
        assign0(bau, 15),
        assign0(bau, 16),
        assign0(bau, 17),
        assign0(bau, 18),
        assign0(bau, 19),
        assign0(bau, 20),
        assign0(bau, 21),
        assign0(bau, 22),
        bal = 0x9800,
        assign1(bau, bal, 23),
        bau = 0x9400,
        x < 24 ?
            assign0(bal, 24),
            assign1(bal, bau, 25)
        :
            (assign1(bal, bau, 24),
            assign0(bau, 25)),
        assign0(bau, 26),
        assign0(bau, 27),
        assign0(bau, 28),
        assign0(bau, 29),
        assign0(bau, 30),
        prg[bau + 1024 + 31*40 + x] = sco, prg[bau + 31*40 + x] = slu;
    for (int x = 0; x < 40; x++) 
        bau = 0x3000,
        sco = prg[bau + 0x400 + x], slu = prg[bau + x],
        assign0(bau, 0),
        assign0(bau, 1),
        assign0(bau, 2),
        assign0(bau, 3),
        assign0(bau, 4),
        assign0(bau, 5),
        assign0(bau, 6),
        assign0(bau, 7),
        assign0(bau, 8),
        assign0(bau, 9),
        assign0(bau, 10),
        assign0(bau, 11),
        assign0(bau, 12),
        assign0(bau, 13),
        assign0(bau, 14),
        assign0(bau, 15),
        assign0(bau, 16),
        assign0(bau, 17),
        assign0(bau, 18),
        assign0(bau, 19),
        assign0(bau, 20),
        assign0(bau, 21),
        assign0(bau, 22),
        bal = 0x7000,
        assign1(bau, bal, 23),
        bau = 0x6c00,
        x < 24 ?
            assign0(bal, 24),
            assign1(bal, bau, 25)
        :
            (assign1(bal, bau, 24),
            assign0(bau, 25)),
        assign0(bau, 26),
        assign0(bau, 27),
        assign0(bau, 28),
        assign0(bau, 29),
        assign0(bau, 30),
        prg[bau + 1024 + 31*40 + x] = sco, prg[bau + 31*40 + x] = slu;
    for (int x = 0; x < 40; x++)
        bau = 0x3800,
        sco = prg[bau + 0x400 + x], slu = prg[bau + x],
        assign0(bau, 0),
        assign0(bau, 1),
        assign0(bau, 2),
        assign0(bau, 3),
        assign0(bau, 4),
        assign0(bau, 5),
        assign0(bau, 6),
        assign0(bau, 7),
        assign0(bau, 8),
        assign0(bau, 9),
        assign0(bau, 10),
        assign0(bau, 11),
        assign0(bau, 12),
        assign0(bau, 13),
        assign0(bau, 14),
        assign0(bau, 15),
        assign0(bau, 16),
        assign0(bau, 17),
        assign0(bau, 18),
        assign0(bau, 19),
        assign0(bau, 20),
        assign0(bau, 21),
        assign0(bau, 22),
        bal = 0x8000,
        assign1(bau, bal, 23),
        bau = 0x7c00,
        x < 24 ?
            assign0(bal, 24),
            assign1(bal, bau, 25)
        :
            (assign1(bal, bau, 24),
            assign0(bau, 25)),
        assign0(bau, 26),
        assign0(bau, 27),
        assign0(bau, 28),
        assign0(bau, 29),
        assign0(bau, 30),
        prg[bau + 1024 + 31*40 + x] = sco, prg[bau + 31*40 + x] = slu;
    for (int x = 0; x < 40; x++)
        bau = 0x9000,
        sco = prg[bau + 0x400 + x], slu = prg[bau + x],
        assign0(bau, 0),
        assign0(bau, 1),
        assign0(bau, 2),
        assign0(bau, 3),
        assign0(bau, 4),
        assign0(bau, 5),
        assign0(bau, 6),
        assign0(bau, 7),
        assign0(bau, 8),
        assign0(bau, 9),
        assign0(bau, 10),
        assign0(bau, 11),
        assign0(bau, 12),
        assign0(bau, 13),
        assign0(bau, 14),
        assign0(bau, 15),
        assign0(bau, 16),
        assign0(bau, 17),
        assign0(bau, 18),
        assign0(bau, 19),
        assign0(bau, 20),
        assign0(bau, 21),
        assign0(bau, 22),
        bal = 0x8800,
        assign1(bau, bal, 23),
        bau = 0x8400,
        x < 24 ?
            assign0(bal, 24),
            assign1(bal, bau, 25)
        :
            (assign1(bal, bau, 24),
            assign0(bau, 25)),
        assign0(bau, 26),
        assign0(bau, 27),
        assign0(bau, 28),
        assign0(bau, 29),
        assign0(bau, 30),
        prg[bau + 1024 + 31*40 + x] = sco, prg[bau + 31*40 + x] = slu;
}
void sscroll_up4() {
    unsigned char sco[4][40], slu[4][40];
    int bau, bal;
    for (int x = 0; x < 40; x++)
       sco[0][x] = prg[0x2c00 + x], slu[0][x] = prg[0x2800 + x],   //y = 0
       sco[1][x] = prg[0x3400 + x], slu[1][x] = prg[0x3000 + x],   //y = 1
       sco[2][x] = prg[0x3c00 + x], slu[2][x] = prg[0x3800 + x],   //y = 2
       sco[3][x] = prg[0x9400 + x], slu[3][x] = prg[0x9000 + x];   //y = 3
    for (int y = 0; y < 92; y += 4) {
       //bau = abase1[0] + (y&0xfc)*10;
       //bal = abase1[0] + ((y + 4)&0xfc)*10;
       bau = 0x2800 + y*10;
       bal = bau + 40;
       for (int x = 0; x < 40; x++)
           prg[bau + 1024 + x] = prg[bal + 1024 + x],
           prg[bau + x] = prg[bal + x];
       bau += 0x800;  //0x3000
       bal = bau + 40;
       for (int x = 0; x < 40; x++)
           prg[bau + 1024 + x] = prg[bal + 1024 + x],
           prg[bau + x] = prg[bal + x];
       bau += 0x800;  //0x3800
       bal = bau + 40;
       for (int x = 0; x < 40; x++)
           prg[bau + 1024 + x] = prg[bal + 1024 + x],
           prg[bau + x] = prg[bal + x];
       bau += 0x5800;  //0x9000
       bal = bau + 40;
       for (int x = 0; x < 40; x++)
           prg[bau + 1024 + x] = prg[bal + 1024 + x],
           prg[bau + x] = prg[bal + x];
    }
    bau = 0x2800 + 920;  //y = 92
    bal = 0x9800 + 960;  //y = 96
    for (int x = 0; x < 40; x++)
       prg[bau + 1024 + x] = prg[bal + 1024 + x],
       prg[bau + x] = prg[bal + x];
    bau = 0x3000 + 920;
    bal = 0x7000 + 960;
    for (int x = 0; x < 40; x++)
       prg[bau + 1024 + x] = prg[bal + 1024 + x],
       prg[bau + x] = prg[bal + x];
    bau = 0x3800 + 920;
    bal = 0x8000 + 960;
    for (int x = 0; x < 40; x++)
       prg[bau + 1024 + x] = prg[bal + 1024 + x],
       prg[bau + x] = prg[bal + x];
    bau = 0x9000 + 920;
    bal = 0x8800 + 960;
    for (int x = 0; x < 40; x++)
       prg[bau + 1024 + x] = prg[bal + 1024 + x],
       prg[bau + x] = prg[bal + x];
    bau = 0x9800 + 960;  //y = 96
    bal = 0x9800 + 1000;  //y = 100
    for (int x = 0; x < 24; x++)
       prg[bau + 1024 + x] = prg[bal + 1024 + x],
       prg[bau + x] = prg[bal + x];
    bau = 0x7000 + 960;
    bal = 0x7000 + 1000;
    for (int x = 0; x < 24; x++)
       prg[bau + 1024 + x] = prg[bal + 1024 + x],
       prg[bau + x] = prg[bal + x];
    bau = 0x8000 + 960;
    bal = 0x8000 + 1000;
    for (int x = 0; x < 24; x++)
       prg[bau + 1024 + x] = prg[bal + 1024 + x],
       prg[bau + x] = prg[bal + x];
    bau = 0x8800 + 960;
    bal = 0x8800 + 1000;
    for (int x = 0; x < 24; x++)
       prg[bau + 1024 + x] = prg[bal + 1024 + x],
       prg[bau + x] = prg[bal + x];
    bau = 0x9800 + 960;  //y = 96
    bal = 0x9400 + 1000;  //y = 100
    for (int x = 24; x < 40; x++)
       prg[bau + 1024 + x] = prg[bal + 1024 + x],
       prg[bau + x] = prg[bal + x];
    bau = 0x7000 + 960;
    bal = 0x6c00 + 1000;
    for (int x = 24; x < 40; x++)
       prg[bau + 1024 + x] = prg[bal + 1024 + x],
       prg[bau + x] = prg[bal + x];
    bau = 0x8000 + 960;
    bal = 0x7c00 + 1000;
    for (int x = 24; x < 40; x++)
       prg[bau + 1024 + x] = prg[bal + 1024 + x],
       prg[bau + x] = prg[bal + x];
    bau = 0x8800 + 960;
    bal = 0x8400 + 1000;
    for (int x = 24; x < 40; x++)
       prg[bau + 1024 + x] = prg[bal + 1024 + x],
       prg[bau + x] = prg[bal + x];

    bau = 0x9800 + 1000;  //y = 100
    bal = 0x9400 + 1040;  //y = 104
    for (int x = 0; x < 24; x++)
       prg[bau + 1024 + x] = prg[bal + 1024 + x],
       prg[bau + x] = prg[bal + x];
    bau = 0x7000 + 1000;
    bal = 0x6c00 + 1040;
    for (int x = 0; x < 24; x++)
       prg[bau + 1024 + x] = prg[bal + 1024 + x],
       prg[bau + x] = prg[bal + x];
    bau = 0x8000 + 1000;
    bal = 0x7c00 + 1040;
    for (int x = 0; x < 24; x++)
       prg[bau + 1024 + x] = prg[bal + 1024 + x],
       prg[bau + x] = prg[bal + x];
    bau = 0x8800 + 1000;
    bal = 0x8400 + 1040;
    for (int x = 0; x < 24; x++)
       prg[bau + 1024 + x] = prg[bal + 1024 + x],
       prg[bau + x] = prg[bal + x];
    bau = 0x9400 + 1000;  //y = 100
    bal = 0x9400 + 1040;  //y = 104
    for (int x = 24; x < 40; x++)
       prg[bau + 1024 + x] = prg[bal + 1024 + x],
       prg[bau + x] = prg[bal + x];
    bau = 0x6c00 + 1000;
    bal = 0x6c00 + 1040;
    for (int x = 24; x < 40; x++)
       prg[bau + 1024 + x] = prg[bal + 1024 + x],
       prg[bau + x] = prg[bal + x];
    bau = 0x7c00 + 1000;
    bal = 0x7c00 + 1040;
    for (int x = 24; x < 40; x++)
       prg[bau + 1024 + x] = prg[bal + 1024 + x],
       prg[bau + x] = prg[bal + x];
    bau = 0x8400 + 1000;
    bal = 0x8400 + 1040;
    for (int x = 24; x < 40; x++)
       prg[bau + 1024 + x] = prg[bal + 1024 + x],
       prg[bau + x] = prg[bal + x];
    for (int y = 104; y < 124; y += 4) {
       //bau = abase2[y&3] + (y&0xfc)*10 - 0x400;
       //bal = abase2[y&3] + ((y + 4)&0xfc)*10 - 0x400;
       bau = 0x9400 + y*10;
       bal = bau + 40;
       for (int x = 0; x < 40; x++)
           prg[bau + 1024 + x] = prg[bal + 1024 + x],
           prg[bau + x] = prg[bal + x];
       bau = 0x6c00 + y*10;
       bal = bau + 40;
       for (int x = 0; x < 40; x++)
           prg[bau + 1024 + x] = prg[bal + 1024 + x],
           prg[bau + x] = prg[bal + x];
       bau = 0x7c00 + y*10;
       bal = bau + 40;
       for (int x = 0; x < 40; x++)
           prg[bau + 1024 + x] = prg[bal + 1024 + x],
           prg[bau + x] = prg[bal + x];
       bau = 0x8400 + y*10;
       bal = bau + 40;
       for (int x = 0; x < 40; x++)
           prg[bau + 1024 + x] = prg[bal + 1024 + x],
           prg[bau + x] = prg[bal + x];
    }
    for (int x = 0; x < 40; x++)
        prg[0x9800 + 1240 + x] = sco[0][x], prg[0x9400 + 1240 + x] = slu[0][x],   //y = 124
        prg[0x7000 + 1240 + x] = sco[1][x], prg[0x6c00 + 1240 + x] = slu[1][x],   //y = 125
        prg[0x8000 + 1240 + x] = sco[2][x], prg[0x7c00 + 1240 + x] = slu[2][x],   //y = 126
        prg[0x8800 + 1240 + x] = sco[3][x], prg[0x8400 + 1240 + x] = slu[3][x];   //y = 127

}
void sscroll_up() {
    unsigned char sco[40], slu[40];
    int bau, bal;
    for (int x = 0; x < 40; x++)
       sco[x] = prg[0x2c00 + x], slu[x] = prg[0x2800 + x];   //y = 0
    for (int y = 1; y < 96; y++) {
       //bau = abase1[(y - 1)&3] + ((y - 1)&0xfc)*10;
       //bal = abase1[y&3] + (y&0xfc)*10;
       bau = ((y - 1)&0xfc)*10;
       bal = abase1[y&3] + bau;
       if ((y&3) == 0) bal += 40;
       bau += abase1[(y - 1)&3];
       for (int x = 0; x < 40; x++)
           prg[bau + 1024 + x] = prg[bal + 1024 + x],
           prg[bau + x] = prg[bal + x];
    }
    bau = 0x9000 + 23*40;   //abase1[3], y - 1 = 95
    bal = 0x9800 + 24*40;  //abase2[0], y = 96
    for (int x = 0; x < 40; x++)
        prg[bau + 1024 + x] = prg[bal + 1024 + x],
        prg[bau + x] = prg[bal + x];
    for (int y = 97; y < 100; y++) {
       //bau = abase2[(y - 1)&3] + ((y - 1)&0xfc)*10;
       //bal = abase2[y&3] + (y&0xfc)*10;
       bau = ((y - 1)&0xfc)*10;
       bal = abase2[y&3] + bau;
       bau += abase2[(y - 1)&3];
       for (int x = 0; x < 40; x++)
           prg[bau + 1024 + x] = prg[bal + 1024 + x],
           prg[bau + x] = prg[bal + x];
    }
    bau = 0x8800 + 24*40;   //abase2[3], y - 1 = 99
    bal = 0x9800 + 25*40;  //abase2[0], y = 100
    for (int x = 0; x < 24; x++)
        prg[bau + 1024 + x] = prg[bal + 1024 + x],
        prg[bau + x] = prg[bal + x];
    //bau = 0x8800 + 24*40;   //abase2[3], y - 1 = 99
    //bal = 0x9400 + 25*40;  //abase2[0] - 0x400, y = 100
    bal -= 0x400;
    for (int x = 24; x < 40; x++)
        prg[bau + 1024 + x] = prg[bal + 1024 + x],
        prg[bau + x] = prg[bal + x];
    for (int y = 101; y < 104; y++) {
       //bau = abase2[(y - 1)&3] + ((y - 1)&0xfc)*10;
       //bal = abase2[y&3] + (y&0xfc)*10;
       bau = ((y - 1)&0xfc)*10;
       bal = abase2[y&3] + bau;
       bau += abase2[(y - 1)&3];
       for (int x = 0; x < 24; x++)
           prg[bau + 1024 + x] = prg[bal + 1024 + x],
           prg[bau + x] = prg[bal + x];
       //bau = abase2[(y - 1)&3] + ((y - 1)&0xfc)*10 - 0x400;
       //bal = abase2[y&3] + (y&0xfc)*10 - 0x400;
       bau -= 0x400;
       bal -= 0x400;
       for (int x = 24; x < 40; x++)
           prg[bau + 1024 + x] = prg[bal + 1024 + x],
           prg[bau + x] = prg[bal + x];
    }
    bau = 0x8800 + 25*40;   //abase2[3], y - 1 = 103
    bal = 0x9400 + 26*40;  //abase2[0] - 0x400, y = 104
    for (int x = 0; x < 24; x++)
        prg[bau + 1024 + x] = prg[bal + 1024 + x],
        prg[bau + x] = prg[bal + x];
    //bau = 0x8400 + 25*40;   //abase2[3] - 0x400, y - 1 = 103
    //bal = 0x9400 + 26*40;  //abase2[0] - 0x400, y = 104
    bau -= 0x400;
    for (int x = 24; x < 40; x++)
        prg[bau + 1024 + x] = prg[bal + 1024 + x],
        prg[bau + x] = prg[bal + x];
    for (int y = 105; y < 128; y++) {
       //bau = abase2[(y - 1)&3] + ((y - 1)&0xfc)*10 - 0x400;
       //bal = abase2[y&3] + (y&0xfc)*10 - 0x400;
       bau = ((y - 1)&0xfc)*10 - 0x400;
       bal = abase2[y&3] + bau;
       if ((y&3) == 0) bal += 40;
       bau += abase2[(y - 1)&3];
       for (int x = 0; x < 40; x++) {
           prg[bau + 1024 + x] = prg[bal + 1024 + x];
           prg[bau + x] = prg[bal + x];
       }
    }
    for (int x = 0; x < 40; x++)
        prg[0x8800 + 31*40 + x] = sco[x], prg[0x8400 + 31*40 + x] = slu[x];  //y = 127
}



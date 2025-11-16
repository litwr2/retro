#define assign0r(a,y) prg[a + 1024 + 40*((y) + 1) + x] = prg[a + 1024 + 40*(y) + x], prg[a + 40*((y) + 1) + x] = prg[a + 40*(y) + x]
#define assign1r(a,b,y) prg[b + 1024 + 40*((y) + 1) + x] = prg[a + 1024 + 40*(y) + x], prg[b + 40*((y) + 1) + x] = prg[a + 40*(y) + x]
void sscroll_down4f() {
    unsigned char sco, slu;
    int bau, bal, y;
    for (int x = 0; x < 40; x++)
        bau = 0x2800,
        bal = 0x9800,
        sco = prg[bal + 31*40 + x], slu = prg[bal - 0x400 + 31*40 + x],
        assign0r(bal - 0x400, 30),
        assign0r(bal - 0x400, 29),
        assign0r(bal - 0x400, 28),
        assign0r(bal - 0x400, 27),
        assign0r(bal - 0x400, 26),
        x < 24 ?
            assign1r(bal, bal - 0x400, 25),
            assign0r(bal, 24)
        :
            (assign0r(bal - 0x400, 25),
            assign1r(bal, bal - 0x400, 24)),
        assign1r(bau, bal, 23),
        assign0r(bau, 22),
        assign0r(bau, 21),
        assign0r(bau, 20),
        assign0r(bau, 19),
        assign0r(bau, 18),
        assign0r(bau, 17),
        assign0r(bau, 16),
        assign0r(bau, 15),
        assign0r(bau, 14),
        assign0r(bau, 13),
        assign0r(bau, 12),
        assign0r(bau, 11),
        assign0r(bau, 10),
        assign0r(bau, 9),
        assign0r(bau, 8),
        assign0r(bau, 7),
        assign0r(bau, 6),
        assign0r(bau, 5),
        assign0r(bau, 4),
        assign0r(bau, 3),
        assign0r(bau, 2),
        assign0r(bau, 1),
        assign0r(bau, 0),
        prg[bau + 0x400 + x] = sco, prg[bau + x] = slu;
    for (int x = 0; x < 40; x++) 
        bau = 0x3000,
        bal = 0x7000,
sco = prg[bal + 31*40 + x], slu = prg[bal - 0x400 + 31*40 + x],
        assign0r(bal - 0x400, 30),
        assign0r(bal - 0x400, 29),
        assign0r(bal - 0x400, 28),
        assign0r(bal - 0x400, 27),
        assign0r(bal - 0x400, 26),
        x < 24 ?
            assign1r(bal, bal - 0x400, 25),
            assign0r(bal, 24)
        :
            (assign0r(bal - 0x400, 25),
            assign1r(bal, bal - 0x400, 24)),
        assign1r(bau, bal, 23),
        assign0r(bau, 22),
        assign0r(bau, 21),
        assign0r(bau, 20),
        assign0r(bau, 19),
        assign0r(bau, 18),
        assign0r(bau, 17),
        assign0r(bau, 16),
        assign0r(bau, 15),
        assign0r(bau, 14),
        assign0r(bau, 13),
        assign0r(bau, 12),
        assign0r(bau, 11),
        assign0r(bau, 10),
        assign0r(bau, 9),
        assign0r(bau, 8),
        assign0r(bau, 7),
        assign0r(bau, 6),
        assign0r(bau, 5),
        assign0r(bau, 4),
        assign0r(bau, 3),
        assign0r(bau, 2),
        assign0r(bau, 1),
        assign0r(bau, 0),
        prg[bau + 0x400 + x] = sco, prg[bau + x] = slu;
    for (int x = 0; x < 40; x++)
        bau = 0x3800,
        bal = 0x8000,
        sco = prg[bal + 31*40 + x], slu = prg[bal - 0x400 + 31*40 + x],
        assign0r(bal - 0x400, 30),
        assign0r(bal - 0x400, 29),
        assign0r(bal - 0x400, 28),
        assign0r(bal - 0x400, 27),
        assign0r(bal - 0x400, 26),
        x < 24 ?
            assign1r(bal, bal - 0x400, 25),
            assign0r(bal, 24)
        :
            (assign0r(bal - 0x400, 25),
            assign1r(bal, bal - 0x400, 24)),
        assign1r(bau, bal, 23),
        assign0r(bau, 22),
        assign0r(bau, 21),
        assign0r(bau, 20),
        assign0r(bau, 19),
        assign0r(bau, 18),
        assign0r(bau, 17),
        assign0r(bau, 16),
        assign0r(bau, 15),
        assign0r(bau, 14),
        assign0r(bau, 13),
        assign0r(bau, 12),
        assign0r(bau, 11),
        assign0r(bau, 10),
        assign0r(bau, 9),
        assign0r(bau, 8),
        assign0r(bau, 7),
        assign0r(bau, 6),
        assign0r(bau, 5),
        assign0r(bau, 4),
        assign0r(bau, 3),
        assign0r(bau, 2),
        assign0r(bau, 1),
        assign0r(bau, 0),
        prg[bau + 0x400 + x] = sco, prg[bau + x] = slu;
    for (int x = 0; x < 40; x++)
        bau = 0x9000,
        bal = 0x8800,
        sco = prg[bal + 31*40 + x], slu = prg[bal - 0x400 + 31*40 + x],
        assign0r(bal - 0x400, 30),
        assign0r(bal - 0x400, 29),
        assign0r(bal - 0x400, 28),
        assign0r(bal - 0x400, 27),
        assign0r(bal - 0x400, 26),
        x < 24 ?
            assign1r(bal, bal - 0x400, 25),
            assign0r(bal, 24)
        :
            (assign0r(bal - 0x400, 25),
            assign1r(bal, bal - 0x400, 24)),
        assign1r(bau, bal, 23),
        assign0r(bau, 22),
        assign0r(bau, 21),
        assign0r(bau, 20),
        assign0r(bau, 19),
        assign0r(bau, 18),
        assign0r(bau, 17),
        assign0r(bau, 16),
        assign0r(bau, 15),
        assign0r(bau, 14),
        assign0r(bau, 13),
        assign0r(bau, 12),
        assign0r(bau, 11),
        assign0r(bau, 10),
        assign0r(bau, 9),
        assign0r(bau, 8),
        assign0r(bau, 7),
        assign0r(bau, 6),
        assign0r(bau, 5),
        assign0r(bau, 4),
        assign0r(bau, 3),
        assign0r(bau, 2),
        assign0r(bau, 1),
        assign0r(bau, 0),
        prg[bau + 0x400 + x] = sco, prg[bau + x] = slu;
}
#define assign0(a,y) prg[a + 1024 + 40*(y) + x] = prg[a + 1024 + 40*((y) + 1) + x], prg[a + 40*(y) + x] = prg[a + 40*((y) + 1) + x]
#define assign1(a,b,y) prg[a + 1024 + 40*(y) + x] = prg[b + 1024 + 40*((y) + 1) + x], prg[a + 40*(y) + x] = prg[b + 40*((y) + 1) + x]
void sscroll_up4f() {
    unsigned char sco, slu;
    int bau, bal, y;
    for (int x = 0; x < 40; x++)
        bau = 0x2800,
        bal = 0x9800,
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
        assign1(bau, bal, 23),
        x < 24 ?
            assign0(bal, 24),
            assign1(bal, bal - 0x400, 25)
        :
            (assign1(bal, bal - 0x400, 24),
            assign0(bal - 0x400, 25)),
        assign0(bal - 0x400, 26),
        assign0(bal - 0x400, 27),
        assign0(bal - 0x400, 28),
        assign0(bal - 0x400, 29),
        assign0(bal - 0x400, 30),
        prg[bal + 31*40 + x] = sco, prg[bal - 0x400 + 31*40 + x] = slu;
    for (int x = 0; x < 40; x++) 
        bau = 0x3000,
        bal = 0x7000,
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
        assign1(bau, bal, 23),
        x < 24 ?
            assign0(bal, 24),
            assign1(bal, bal - 0x400, 25)
        :
            (assign1(bal, bal - 0x400, 24),
            assign0(bal - 0x400, 25)),
        assign0(bal - 0x400, 26),
        assign0(bal - 0x400, 27),
        assign0(bal - 0x400, 28),
        assign0(bal - 0x400, 29),
        assign0(bal - 0x400, 30),
        prg[bal + 31*40 + x] = sco, prg[bal - 0x400 + 31*40 + x] = slu;
    for (int x = 0; x < 40; x++)
        bau = 0x3800,
        bal = 0x8000,
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
        assign1(bau, bal, 23),
        x < 24 ?
            assign0(bal, 24),
            assign1(bal, bal - 0x400, 25)
        :
            (assign1(bal, bal - 0x400, 24),
            assign0(bal - 0x400, 25)),
        assign0(bal - 0x400, 26),
        assign0(bal - 0x400, 27),
        assign0(bal - 0x400, 28),
        assign0(bal - 0x400, 29),
        assign0(bal - 0x400, 30),
        prg[bal + 31*40 + x] = sco, prg[bal - 0x400 + 31*40 + x] = slu;
    for (int x = 0; x < 40; x++)
        bau = 0x9000,
        bal = 0x8800,
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
        assign1(bau, bal, 23),
        x < 24 ?
            assign0(bal, 24),
            assign1(bal, bal - 0x400, 25)
        :
            (assign1(bal, bal - 0x400, 24),
            assign0(bal - 0x400, 25)),
        assign0(bal - 0x400, 26),
        assign0(bal - 0x400, 27),
        assign0(bal - 0x400, 28),
        assign0(bal - 0x400, 29),
        assign0(bal - 0x400, 30),
        prg[bal + 31*40 + x] = sco, prg[bal - 0x400 + 31*40 + x] = slu;
}
#define assign2r(a,y) prg[a + 1024 + 40*((y) + 2) + x] = prg[a + 1024 + 40*(y) + x], prg[a + 40*((y) + 2) + x] = prg[a + 40*(y) + x]
#define assign3r(a,b,y) prg[b + 1024 + 40*((y) + 2) + x] = prg[a + 1024 + 40*(y) + x], prg[b + 40*((y) + 2) + x] = prg[a + 40*(y) + x]
void sscroll_down8f() {
    unsigned char sco0, slu0, sco1, slu1;
    int bau, bal, y;
    for (int x = 0; x < 40; x++)
        bal = 0x9800,
        bau = 0x2800,
        sco1 = prg[bal + 31*40 + x], slu1 = prg[bal - 0x400 + 31*40 + x],
        sco0 = prg[bal + 30*40 + x], slu0 = prg[bal - 0x400 + 30*40 + x],
        assign2r(bal - 0x400, 29),
        assign2r(bal - 0x400, 28),
        assign2r(bal - 0x400, 27),
        assign2r(bal - 0x400, 26),
        x < 24 ?
            assign3r(bal, bal - 0x400, 25),
            assign3r(bau, bal, 23)
        :
            (assign2r(bal - 0x400, 25),
            assign3r(bau, bal - 0x400, 23)),
        assign3r(bal, bal - 0x400, 24),
        assign3r(bau, bal, 22),
        assign2r(bau, 21),
        assign2r(bau, 20),
        assign2r(bau, 19),
        assign2r(bau, 18),
        assign2r(bau, 17),
        assign2r(bau, 16),
        assign2r(bau, 15),
        assign2r(bau, 14),
        assign2r(bau, 13),
        assign2r(bau, 12),
        assign2r(bau, 11),
        assign2r(bau, 10),
        assign2r(bau, 9),
        assign2r(bau, 8),
        assign2r(bau, 7),
        assign2r(bau, 6),
        assign2r(bau, 5),
        assign2r(bau, 4),
        assign2r(bau, 3),
        assign2r(bau, 2),
        assign2r(bau, 1),
        assign2r(bau, 0),
        prg[bau + 0x400 + x] = sco0, prg[bau + x] = slu0,
        prg[bau + 0x428 + x] = sco1, prg[bau + 40 + x] = slu1;
    for (int x = 0; x < 40; x++) 
        bau = 0x3000,
        bal = 0x7000,
        sco0 = prg[bal + 30*40 + x], slu0 = prg[bal - 0x400 + 30*40 + x],
        sco1 = prg[bal + 31*40 + x], slu1 = prg[bal - 0x400 + 31*40 + x],
        assign2r(bal - 0x400, 29),
        assign2r(bal - 0x400, 28),
        assign2r(bal - 0x400, 27),
        assign2r(bal - 0x400, 26),
        x < 24 ?
            assign3r(bal, bal - 0x400, 25),
            assign3r(bau, bal, 23)
        :
            (assign2r(bal - 0x400, 25),
            assign3r(bau, bal - 0x400, 23)),
        assign3r(bal, bal - 0x400, 24),
        assign3r(bau, bal, 22),
        assign2r(bau, 21),
        assign2r(bau, 20),
        assign2r(bau, 19),
        assign2r(bau, 18),
        assign2r(bau, 17),
        assign2r(bau, 16),
        assign2r(bau, 15),
        assign2r(bau, 14),
        assign2r(bau, 13),
        assign2r(bau, 12),
        assign2r(bau, 11),
        assign2r(bau, 10),
        assign2r(bau, 9),
        assign2r(bau, 8),
        assign2r(bau, 7),
        assign2r(bau, 6),
        assign2r(bau, 5),
        assign2r(bau, 4),
        assign2r(bau, 3),
        assign2r(bau, 2),
        assign2r(bau, 1),
        assign2r(bau, 0),
        prg[bau + 0x400 + x] = sco0, prg[bau + x] = slu0,
        prg[bau + 0x428 + x] = sco1, prg[bau + 40 + x] = slu1;
    for (int x = 0; x < 40; x++)
        bau = 0x3800,
        bal = 0x8000,
        sco0 = prg[bal + 30*40 + x], slu0 = prg[bal - 0x400 + 30*40 + x],
        sco1 = prg[bal + 31*40 + x], slu1 = prg[bal - 0x400 + 31*40 + x],
        assign2r(bal - 0x400, 29),
        assign2r(bal - 0x400, 28),
        assign2r(bal - 0x400, 27),
        assign2r(bal - 0x400, 26),
        x < 24 ?
            assign3r(bal, bal - 0x400, 25),
            assign3r(bau, bal, 23)
        :
            (assign2r(bal - 0x400, 25),
            assign3r(bau, bal - 0x400, 23)),
        assign3r(bal, bal - 0x400, 24),
        assign3r(bau, bal, 22),
        assign2r(bau, 21),
        assign2r(bau, 20),
        assign2r(bau, 19),
        assign2r(bau, 18),
        assign2r(bau, 17),
        assign2r(bau, 16),
        assign2r(bau, 15),
        assign2r(bau, 14),
        assign2r(bau, 13),
        assign2r(bau, 12),
        assign2r(bau, 11),
        assign2r(bau, 10),
        assign2r(bau, 9),
        assign2r(bau, 8),
        assign2r(bau, 7),
        assign2r(bau, 6),
        assign2r(bau, 5),
        assign2r(bau, 4),
        assign2r(bau, 3),
        assign2r(bau, 2),
        assign2r(bau, 1),
        assign2r(bau, 0),
        prg[bau + 0x400 + x] = sco0, prg[bau + x] = slu0,
        prg[bau + 0x428 + x] = sco1, prg[bau + 40 + x] = slu1;
    for (int x = 0; x < 40; x++)
        bau = 0x9000,
        bal = 0x8800,
        sco0 = prg[bal + 30*40 + x], slu0 = prg[bal - 0x400 + 30*40 + x],
        sco1 = prg[bal + 31*40 + x], slu1 = prg[bal - 0x400 + 31*40 + x],
        assign2r(bal - 0x400, 29),
        assign2r(bal - 0x400, 28),
        assign2r(bal - 0x400, 27),
        assign2r(bal - 0x400, 26),
        x < 24 ?
            assign3r(bal, bal - 0x400, 25),
            assign3r(bau, bal, 23)
        :
            (assign2r(bal - 0x400, 25),
            assign3r(bau, bal - 0x400, 23)),
        assign3r(bal, bal - 0x400, 24),
        assign3r(bau, bal, 22),
        assign2r(bau, 21),
        assign2r(bau, 20),
        assign2r(bau, 19),
        assign2r(bau, 18),
        assign2r(bau, 17),
        assign2r(bau, 16),
        assign2r(bau, 15),
        assign2r(bau, 14),
        assign2r(bau, 13),
        assign2r(bau, 12),
        assign2r(bau, 11),
        assign2r(bau, 10),
        assign2r(bau, 9),
        assign2r(bau, 8),
        assign2r(bau, 7),
        assign2r(bau, 6),
        assign2r(bau, 5),
        assign2r(bau, 4),
        assign2r(bau, 3),
        assign2r(bau, 2),
        assign2r(bau, 1),
        assign2r(bau, 0),
        prg[bau + 0x400 + x] = sco0, prg[bau + x] = slu0,
        prg[bau + 0x428 + x] = sco1, prg[bau + 40 + x] = slu1;
}
#define assign2(a,y) prg[a + 1024 + 40*(y) + x] = prg[a + 1024 + 40*((y) + 2) + x], prg[a + 40*(y) + x] = prg[a + 40*((y) + 2) + x]
#define assign3(a,b,y) prg[a + 1024 + 40*(y) + x] = prg[b + 1024 + 40*((y) + 2) + x], prg[a + 40*(y) + x] = prg[b + 40*((y) + 2) + x]
void sscroll_up8f() {
    unsigned char sco0, slu0, sco1, slu1;
    int bau, bal, y;
    for (int x = 0; x < 40; x++)
        bau = 0x2800,
        sco0 = prg[bau + 0x400 + x], slu0 = prg[bau + x],
        sco1 = prg[bau + 0x428 + x], slu1 = prg[bau + 40 + x],
        assign2(bau, 0),
        assign2(bau, 1),
        assign2(bau, 2),
        assign2(bau, 3),
        assign2(bau, 4),
        assign2(bau, 5),
        assign2(bau, 6),
        assign2(bau, 7),
        assign2(bau, 8),
        assign2(bau, 9),
        assign2(bau, 10),
        assign2(bau, 11),
        assign2(bau, 12),
        assign2(bau, 13),
        assign2(bau, 14),
        assign2(bau, 15),
        assign2(bau, 16),
        assign2(bau, 17),
        assign2(bau, 18),
        assign2(bau, 19),
        assign2(bau, 20),
        assign2(bau, 21),
        bal = 0x9800,
        assign3(bau, bal, 22),
        assign3(bal, bal - 0x400, 24),
        x < 24 ?
            assign3(bau, bal, 23),
            assign3(bal, bal - 0x400, 25)
        :
            (assign3(bau, bal - 0x400, 23),
            assign2(bal - 0x400, 25)),
        assign2(bal - 0x400, 26),
        assign2(bal - 0x400, 27),
        assign2(bal - 0x400, 28),
        assign2(bal - 0x400, 29),
        prg[bal + 30*40 + x] = sco0, prg[bal - 0x400 + 30*40 + x] = slu0,
        prg[bal + 31*40 + x] = sco1, prg[bal - 0x400 + 31*40 + x] = slu1;
    for (int x = 0; x < 40; x++) 
        bau = 0x3000,
        sco0 = prg[bau + 0x400 + x], slu0 = prg[bau + x],
        sco1 = prg[bau + 0x428 + x], slu1 = prg[bau + 40 + x],
        assign2(bau, 0),
        assign2(bau, 1),
        assign2(bau, 2),
        assign2(bau, 3),
        assign2(bau, 4),
        assign2(bau, 5),
        assign2(bau, 6),
        assign2(bau, 7),
        assign2(bau, 8),
        assign2(bau, 9),
        assign2(bau, 10),
        assign2(bau, 11),
        assign2(bau, 12),
        assign2(bau, 13),
        assign2(bau, 14),
        assign2(bau, 15),
        assign2(bau, 16),
        assign2(bau, 17),
        assign2(bau, 18),
        assign2(bau, 19),
        assign2(bau, 20),
        assign2(bau, 21),
        bal = 0x7000,
        assign3(bau, bal, 22),
        assign3(bal, bal - 0x400, 24),
        x < 24 ?
            assign3(bau, bal, 23),
            assign3(bal, bal - 0x400, 25)
        :
            (assign3(bau, bal - 0x400, 23),
            assign2(bal - 0x400, 25)),
        assign2(bal - 0x400, 26),
        assign2(bal - 0x400, 27),
        assign2(bal - 0x400, 28),
        assign2(bal - 0x400, 29),
        prg[bal + 30*40 + x] = sco0, prg[bal - 0x400 + 30*40 + x] = slu0,
        prg[bal + 31*40 + x] = sco1, prg[bal - 0x400 + 31*40 + x] = slu1;
    for (int x = 0; x < 40; x++)
        bau = 0x3800,
        sco0 = prg[bau + 0x400 + x], slu0 = prg[bau + x],
        sco1 = prg[bau + 0x428 + x], slu1 = prg[bau + 40 + x],
        assign2(bau, 0),
        assign2(bau, 1),
        assign2(bau, 2),
        assign2(bau, 3),
        assign2(bau, 4),
        assign2(bau, 5),
        assign2(bau, 6),
        assign2(bau, 7),
        assign2(bau, 8),
        assign2(bau, 9),
        assign2(bau, 10),
        assign2(bau, 11),
        assign2(bau, 12),
        assign2(bau, 13),
        assign2(bau, 14),
        assign2(bau, 15),
        assign2(bau, 16),
        assign2(bau, 17),
        assign2(bau, 18),
        assign2(bau, 19),
        assign2(bau, 20),
        assign2(bau, 21),
        bal = 0x8000,
        assign3(bau, bal, 22),
        assign3(bal, bal - 0x400, 24),
        x < 24 ?
            assign3(bau, bal, 23),
            assign3(bal, bal - 0x400, 25)
        :
            (assign3(bau, bal - 0x400, 23),
            assign2(bal - 0x400, 25)),
        assign2(bal - 0x400, 26),
        assign2(bal - 0x400, 27),
        assign2(bal - 0x400, 28),
        assign2(bal - 0x400, 29),
        prg[bal + 30*40 + x] = sco0, prg[bal - 0x400 + 30*40 + x] = slu0,
        prg[bal + 31*40 + x] = sco1, prg[bal - 0x400 + 31*40 + x] = slu1;
    for (int x = 0; x < 40; x++)
        bau = 0x9000,
        sco0 = prg[bau + 0x400 + x], slu0 = prg[bau + x],
        sco1 = prg[bau + 0x428 + x], slu1 = prg[bau + 40 + x],
        assign2(bau, 0),
        assign2(bau, 1),
        assign2(bau, 2),
        assign2(bau, 3),
        assign2(bau, 4),
        assign2(bau, 5),
        assign2(bau, 6),
        assign2(bau, 7),
        assign2(bau, 8),
        assign2(bau, 9),
        assign2(bau, 10),
        assign2(bau, 11),
        assign2(bau, 12),
        assign2(bau, 13),
        assign2(bau, 14),
        assign2(bau, 15),
        assign2(bau, 16),
        assign2(bau, 17),
        assign2(bau, 18),
        assign2(bau, 19),
        assign2(bau, 20),
        assign2(bau, 21),
        bal = 0x8800,
        assign3(bau, bal, 22),
        assign3(bal, bal - 0x400, 24),
        x < 24 ?
            assign3(bau, bal, 23),
            assign3(bal, bal - 0x400, 25)
        :
            (assign3(bau, bal - 0x400, 23),
            assign2(bal - 0x400, 25)),
        assign2(bal - 0x400, 26),
        assign2(bal - 0x400, 27),
        assign2(bal - 0x400, 28),
        assign2(bal - 0x400, 29),
        prg[bal + 30*40 + x] = sco0, prg[bal - 0x400 + 30*40 + x] = slu0,
        prg[bal + 31*40 + x] = sco1, prg[bal - 0x400 + 31*40 + x] = slu1;
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



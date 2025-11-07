sscroll_up:  ;$66-69, $d0-d3, $d5
     ldx #39
.l0  lda $2c00,x  ;for (int x = 0; x < 40; x++)
     sta .sco,x
     lda $2800,x
     sta .slu,x
     dex
     bpl .l0  ;sco[x] = prg[0x2c00 + x], slu[x] = prg[0x2800 + x]

     lda #0
.l11 sta $d5  ;for (int y = 1; y < 96; y++) {
     ldx #0
     stx $67
     and #3
     tax
     lda $d5
     and #$fc
     asl
     sta $66
     asl
     rol $67
     asl
     rol $67  ;sets C=0
     adc $66  ;C=0
     sta .m31+1
     sta .m33+1
     sta .l31+1
     sta .m32+1
     lda #0
     adc $67  ;C=0
     tay   ;bau = ((y - 1)&0xfc)*10
     cpx #3
     bne .l21  ;if ((y&3) == 0)

     lda #39
     adc .l31+1  ;C=1
     sta .l31+1
     sta .m32+1
     tya
     adc abase1  ;C=0
     bne *+5  ;always
.l21 adc abase1+1,x  ;C=0
     sta .l31+2  ;bal += 40, ;bal = abase1[y&3] + bau
     adc #4   ;C=0
     sta .m32+2
     tya
     adc abase1,x  ;C=0
     sta .m31+2  ;bau += abase1[(y - 1)&3]
     adc #4   ;C=0
     sta .m33+2

     ldy #39  ;for (int x = 0; x < 40; x++)
.l31 lda $d1d0,y
.m31 sta $6766,y  ;prg[bau + x] = prg[bal + x]
.m32 lda $d3d2,y
.m33 sta $6968,y  ;prg[bau + 1024 + x] = prg[bal + 1024 + x]
     dey
     bpl .l31

     lda $d5
     adc #1   ;C=0
     cmp #95
     bne .l11

     ldy #39  ;for (int x = 0; x < 40; x++)
.l41 lda $9bc0,y
     sta $9398,y  ;prg[bau + x] = prg[bal + x]
     lda $9fc0,y
     sta $9798,y  ;prg[bau + 1024 + x] = prg[bal + 1024 + x]
     dey
     bpl .l41

     lda #96
.l12 sta $d5  ;for (int y = 97; y < 100; y++) {
     ldx #0
     stx $67
     and #3
     tax
     lda $d5
     and #$fc
     asl
     sta $66
     asl
     rol $67
     asl
     rol $67  ;sets C=0
     adc $66  ;C=0
     sta .m21+1
     sta .m23+1
     sta .l32+1
     sta .m22+1
     lda #0
     adc $67
     tay  ;bau = ((y - 1)&0xfc)*10
     adc abase2+1,x  ;C=0
     sta .l32+2  ;bal += 40, ;bal = abase2[y&3] + bau
     adc #4   ;C=0
     sta .m22+2
     tya
     adc abase2,x  ;C=0
     sta .m21+2  ;bau += abase2[(y - 1)&3]
     adc #4   ;C=0
     sta .m23+2

     ldy #39  ;for (int x = 0; x < 40; x++)
.l32 lda $d1d0,y
.m21 sta $6766,y  ;prg[bau + x] = prg[bal + x]
.m22 lda $d3d2,y
.m23 sta $6968,y  ;prg[bau + 1024 + x] = prg[bal + 1024 + x]
     dey
     bpl .l32

     lda $d5
     adc #1   ;C=0
     cmp #99  ;sets C=1 on exit!
     bne .l12

     ldy #39  ;for (int x = 24; x < 40; x++)
.l43 lda $97e8,y
     sta $8bc0,y  ;prg[bau + x] = prg[bal + x]
     lda $9be8,y
     sta $8fc0,y  ;prg[bau + 1024 + x] = prg[bal + 1024 + x]
     dey
     cpy #23
     bne .l43

     ;ldy #23  ;for (int x = 0; x < 24; x++)
.l42 lda $9be8,y
     sta $8bc0,y  ;prg[bau + x] = prg[bal + x]
     lda $9fe8,y
     sta $8fc0,y  ;prg[bau + 1024 + x] = prg[bal + 1024 + x]
     dey
     bpl .l42

     lda #100
.l13 sta $d5  ;for (int y = 101; y < 104; y++) {
     ldx #0
     stx $67
     and #3
     tax
     lda $d5
     and #$fc
     asl
     sta $66
     asl
     rol $67
     asl
     rol $67  ;sets C=0
     adc $66  ;C=0
     sta $66
     sta $68
     sta $d0
     sta $d2
     lda #0
     adc $67
     tay  ;bau = ((y - 1)&0xfc)*10
     adc abase2+1,x  ;C=0
     sta $d1  ;bal += 40, ;bal = abase2[y&3] + bau
     adc #4   ;C=0
     sta $d3
     tya
     adc abase2,x  ;C=0
     sta $67  ;bau += abase2[(y - 1)&3]
     adc #4   ;C=0
     sta $69

     ldy #23  ;for (int x = 0; x < 24; x++)
.l33 lda ($d0),y
     sta ($66),y  ;prg[bau + x] = prg[bal + x]
     lda ($d2),y
     sta ($68),y  ;prg[bau + 1024 + x] = prg[bal + 1024 + x]
     dey
     bpl .l33

     lda $69
     sbc #7   ;C=0
     sta $69
     lda $d3
     sbc #8   ;C=1
     sta $d3  ;bau -= 0x400

     ldy #39  ;for (int x = 24; x < 40; x++)
.l34 lda ($d0),y
     sta ($66),y  ;prg[bau + x] = prg[bal + x]
     lda ($d2),y
     sta ($68),y  ;prg[bau + 1024 + x] = prg[bal + 1024 + x]
     dey
     cpy #23
     bpl .l34

     lda $d5
     adc #1   ;C=0
     cmp #103  ;sets C=1 on exit!
     bne .l13

     ldy #23  ;for (int x = 0; x < 24; x++)
.l46 lda $9810,y
     sta $8be8,y  ;prg[bau + x] = prg[bal + x]
     lda $9c10,y
     sta $8fe8,y  ;prg[bau + 1024 + x] = prg[bal + 1024 + x]
     dey
     bpl .l46

     ldy #39  ;for (int x = 24; x < 40; x++)
.l47 lda $9810,y
     sta $87e8,y  ;prg[bau + x] = prg[bal + x]
     lda $9c10,y
     sta $8be8,y  ;prg[bau + 1024 + x] = prg[bal + 1024 + x]
     dey
     cpy #23
     bne .l47

     lda #104
.l14 sta $d5  ;for (int y = 105; y < 128; y++) {
     ldx #0
     stx $67
     and #3
     tax
     lda $d5
     and #$fc
     asl
     sta $66
     asl
     rol $67
     asl
     rol $67  ;sets C=0
     adc $66  ;C=0
     sta .m51+1
     sta .m53+1
     sta .l35+1
     sta .m52+1
     lda #-4
     adc $67
     tay  ;bau = ((y - 1)&0xfc)*10 - 0x400
     cpx #3
     bne .l22  ;if ((y&3) == 0)

     lda .l35+1
     adc #39  ;C=1
     sta .l35+1
     sta .m52+1
     tya
     adc abase2  ;C=0
     bne *+5  ;always
.l22 adc abase2+1,x  ;C=0
     sta .l35+2  ;bal += 40 ;bal = abase2[y&3] + bau
     adc #4   ;C=0
     sta .m52+2
     tya
     adc abase2,x  ;C=0
     sta .m51+2  ;bau += abase2[(y - 1)&3]
     adc #4   ;C=0
     sta .m53+2

     ldy #39  ;for (int x = 0; x < 40; x++)
.l35 lda $d1d0,y
.m51 sta $6766,y  ;prg[bau + x] = prg[bal + x]
.m52 lda $d3d2,y
.m53 sta $6968,y  ;prg[bau + 1024 + x] = prg[bal + 1024 + x]
     dey
     bpl .l35

     lda $d5
     adc #1   ;C=0
     cmp #127
     bne .l14

     ldy #39
.l36 lda .sco,y
     sta $8cd8,y  ;prg[0x8800 + 31*40 + x] = sco[x]
     lda .slu,y
     sta $88d8,y  ;prg[0x8400 + 31*40 + x] = slu[x]
     dey
     bpl .l36
     rts

.sco ds 40
.slu ds 40    ;unsigned char sco[40], slu[40];


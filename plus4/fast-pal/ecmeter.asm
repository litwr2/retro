;for vasm6502/oldstyle

;23863 + 53 + 59 + 65 + 65 + 49 (+ 33) = 24154 (+ 33) = 24187; +23896 approx. +4.43%
;22882 + 12*109 = 24190 - 3 cycles are lost somehow!

        org $1001
   byte $b,$10,$a,0,$9e
   byte start/1000+48,start%1000/100+48,start%100/10+48,start%10+48
   byte 0,0,0

MAXEL1 = 11
MAXEL2 = 12
NTSCSTD = 17432
PALSTD = 22882
TEXTBASE = $fc4
JPRIMM = $FF4F

PALPOS0 = 250
PALPOS3 = 260
PALPOS4 = 268
PALPOS5 = 270
NTSCPOS0 = 80

    assert >irq1 == >irq0, wrong alignment!
start:
    jmp init

irq1:   ;46+7=53 cycles
     sta .m1+1
;     lda $ff19
;     sta irq2.m2+1
;     lda #0
;     sta $ff19
     ;pha
     lda $ff07
     ora #$40
     sta $ff07
     lda #NTSCPOS0
     sta $ff1d
.me1  lda #NTSCPOS0      ;+EXTRALINES1*5
     sta $ff0b
     ;lda #$a2
     ;sta $ff0a
     lda #<irq2
     sta $fffe
     ;lda #>irqE
     ;sta $ffff
.m1  lda #0
;     pla
     inc $ff09
     rti

irq2:  ;52+7=59 cycles
;     pha
     sta .m1+1
     lda $ff07
     and #$bf
     sta $ff07
     lda #PALPOS0
     sta $ff1d
     ;lda #0
     ;sta $ff1c
.me2 lda #PALPOS0-4
     sta $ff0b
.me3 lda #$a2  ;not required for the upper extras only
     sta $ff0a
.me1 lda #<irq1
     sta $fffe
     ;pla
;.m2  lda #0
;     sta $ff19
.m1  lda #0
     inc $ff09
     rti

irq3:   ;58+7=65 cycles
     sta .m1+1
     lda $ff07
     ora #$40
     sta $ff07
     lda #NTSCPOS0
     sta $ff1d
     lda #0
     sta $ff1c
.me1  lda #NTSCPOS0  ;+EXTRALINES2*5
     sta $ff0b
     lda #$a2
     sta $ff0a
     lda #<irq4
     sta $fffe
     ;lda #>irq4
     ;sta $ffff
.m1  lda #0
     inc $ff09
     rti

irq4:  ;58+7=65 cycles
     sta .m1+1
     lda $ff07
     and #$bf
     sta $ff07
.me1 lda #<PALPOS4
     sta $ff1d
.me2 lda #>PALPOS4
     sta $ff1c
.me3 lda #<PALPOS5
     sta $ff0b
.me4 lda #$a2 + >PALPOS5
     sta $ff0a
.me5 lda #<irq5
     sta $fffe
     ;lda #>irq5
     ;sta $ffff
.m1  lda #0
     inc $ff09
     rti

irq5:   ;42 + 7 = 49 cycles
     sta .m1+1
.me1 lda #<PALPOS5  ;+ EXTRALINES2*4 - 8
     sta $ff1d
     lda #0
     sta $ff0b
     lda #$a2
     sta $ff0a
     lda #<irq0
     sta $fffe
     ;lda #>irq0
     ;sta $ffff
.m1  lda #0
     inc $ff09
     rti

irqtime = 100  ;93 (code) + 7 (irq) cycles on track
irq0:
     sta .m1+1		;4
     jsr counter	;6
.me1 lda #<irq0		;2
     sta $fffe		;4
.me2 lda #0			;2
     sta $ff0b		;4
.me3 lda #$a2		;2
     sta $ff0a		;4
.m1  lda #0			;2
     inc $ff09		;6
     rti			;6

     org $1100
counter:
.off = 1
   stx .m+1		;4
   tsx			;2
   inc .sw+1	;6
.sw lda #0		;2
   and #7		;2
   bne .l1		;3

   lda #<job
   sta $103+.off,x
   lda #>job
   bne .l2

.l1 cmp #3		;2
    bne .l3		;3

   sty .my+1
.sy ldy #0
   lda $103+.off,x
   sta cnt,y
   lda $104+.off,x
   sta cnt+1,y
.my ldy #0
   jmp .l5

.l3 cmp #6		;2
    bne .l5		;3

.sx lda #0
   eor #1
   sta .sx+1
   beq .lx1

   lda #2
   sta .sy+1
   inc .l1+1
   bne .l5 
.lx1
   sta .sy+1
   dec .l1+1
.l5
    lda #<track	;2
    sta $103+.off,x	;5
    lda #>track	;2
.l2 sta $104+.off,x	;5
.m ldx #0		;2
   rts			;6

job:
   lda counter.l1+1
   cmp #3
   beq .l1

   jsr getkmtrix
   ldx #7
.l2 lda kmatrix,x
   sta .rk,x
   dex
   bpl .l2
   bmi *

.l1
   clc
   lda cnt
   adc cnt+2
   tax
   lda cnt+1
   adc cnt+3  ;sets C=0
   tay
   txa
   sbc #<(2*track-irqtime-1)
   tax
   tya
   sbc #>(2*track-irqtime-1)
   stx .vl
   sta .vh

   lda $ff07
   and #$40
   beq .l3

   lda #<NTSCSTD
   sta showstat.fc
   lda #>NTSCSTD
   sta showstat.fc+1
   lda #<(NTSCSTD/2)
   sta showstat.fch
   lda #>(NTSCSTD/2)
   sta showstat.fch+1
   jmp .fin
.l3
   jsr getkmtrix
   lda kmatrix+5
   and .rk+5
   and #8  ;cu
   bne .ncu

   ldx el1
   bne .cu1

   lda el2
   bne .cu2

;el1 = 0 && el2 = 0
   inc el1
   lda #<irq1
   sta irq0.me1+1
   lda #PALPOS0-4
   sta irq0.me2+1
   lda #$a2
   sta irq0.me3+1
   lda #0
   sta irq2.me2+1
   lda #<irq0
   sta irq2.me1+1
   lda #NTSCPOS0+5
   sta irq1.me1+1
   jmp .fin
.cu2
;el1 = 0 && el2 > 0
   inc el1
   lda #<irq1
   sta irq0.me1+1
   lda #PALPOS0-4
   sta irq0.me2+1
   lda #$a2
   sta irq0.me3+1
   lda #<PALPOS3
   sta irq2.me2+1
   lda #$a3
   sta irq2.me3+1
   lda #<irq3
   sta irq2.me1+1
   lda #NTSCPOS0+5
   sta irq1.me1+1
   jmp .fin
.cu1
   cpx #MAXEL1
   bne *+5
   jmp .fin

;el1 > 0 && el2 >= 0
   inx
.cu3
   txa
   stx el1
   asl
   asl
   sta .mc1+1
   lda #PALPOS0
   sec
.mc1 sbc #0
   sta irq0.me2+1
   txa
   clc
   adc .mc1+1  ;sets C=0
   adc #NTSCPOS0
   sta irq1.me1+1
   jmp .fin

.ncu lda kmatrix+5
   and .rk+5
   and #1  ;cd
   bne .ncd

   ldx el1
   bne *+5
   jmp .fin

   lda el2
   bne .cd3

   dex
   bne .cd2

;el1 = 1 && el2 = 0
   stx el1
   lda #<irq0
   sta irq0.me1+1
   lda #0
   sta irq0.me2+1
   jmp .fin
.cd2
;el1 > 1 && el2 = 0
   jmp .cu3
.cd3
;el1 = 1 && el2 > 0
   cpx #1
   bne .cd4

   dec el1
   lda #<irq3
   sta irq0.me1+1
   lda #<PALPOS3
   sta irq0.me2+1
   lda #$a3
   sta irq0.me3+1
   jmp .fin
.cd4
;el1 > 1 && el2 > 0
   dex
   jmp .cu3
.ncd
   lda kmatrix+6
   and .rk+6
   and #8  ;cr
   beq *+5
   jmp .ncr

   ldx el2
   bne .cr1

   lda el1
   beq *+5
   jmp .cr2

;el1 = 0 && el2 = 0
   inc el2
   lda #<irq3
   sta irq0.me1+1
   lda #<PALPOS3
   sta irq0.me2+1
   lda #$a3
   sta irq0.me3+1
   lda #<(PALPOS3+4)
   sta irq4.me1+1
   lda #>(PALPOS3+4)
   sta irq4.me2+1
   lda #0
   sta irq4.me3+1
   lda #$a2
   sta irq4.me4+1
   lda #<irq0
   sta irq4.me5+1
   lda #NTSCPOS0+5
   sta irq3.me1+1
   jmp .fin
.cr1
   cpx #1
   bne .cr3

   lda el1
   beq *+5
   jmp .cr4

;el2 = 1 && el1 = 0
   inc el2
   lda #<(PALPOS3+8)
   sta irq4.me1+1
   lda #>(PALPOS3+8)
   sta irq4.me2+1
   lda #NTSCPOS0+10
   sta irq3.me1+1
   jmp .fin
.cr3
   cpx #MAXEL2
   bne *+5
   jmp .fin

;el2 > 1 && el1 >= 0
   inx
   stx el2
   lda #<PALPOS5
   sta irq4.me3+1
   lda #$a3
   sta irq4.me4+1
   lda #<irq5
   sta irq4.me5+1
   txa
   asl
   asl  ;sets C=0
   sta .mc2+1
   adc #<PALPOS5  ;sets C=0
   sbc #7  ;sets C=1
   sta irq5.me1+1
   txa
.mc2 adc #0  ;sets C=0
   adc #NTSCPOS0-1
   sta irq3.me1+1
   jmp .fin
.cr2
;el1 > 0 && el2 = 0
   inc el2
   lda #<irq3
   sta irq2.me1+1
   lda #<PALPOS3
   sta irq2.me2+1
   lda #$a3
   sta irq2.me3+1
   lda #<(PALPOS3+4)
   sta irq4.me1+1
   lda #>(PALPOS3+4)
   sta irq4.me2+1
   lda #0
   sta irq4.me3+1
   lda #$a2
   sta irq4.me4+1
   lda #<irq0
   sta irq4.me5+1
   lda #NTSCPOS0+5
   sta irq3.me1+1
   jmp .fin
.cr4
;el1 > 0 && el2 = 1
   inc el2
   lda #<(PALPOS3+8)
   sta irq4.me1+1
   ;lda #>(PALPOS3+8)
   ;sta irq4.me2+1
   lda #NTSCPOS0+10
   sta irq3.me1+1
   jmp .fin
.ncr
   lda kmatrix+6
   and .rk+6
   and #1  ;cl
   beq *+5
   jmp .fin

   ldx el2
   bne *+5
   jmp .fin

   lda el1
   bne .cl3

   cpx #3
   bne .cl2

;el1 = 0 && el2 = 3
   dec el2
   lda #<(PALPOS3+8)
   sta irq4.me1+1
   lda #>(PALPOS3+8)
   sta irq4.me2+1
   lda #0
   sta irq4.me3+1
   lda #$a2
   sta irq4.me4+1
   lda #<irq0
   sta irq4.me5+1
   lda #NTSCPOS0+10
   sta irq3.me1+1  
   jmp .fin 
.cl2
   cpx #2
   bne .cl4
;el1 = 0 && el2 = 2
   dec el2
   lda #<(PALPOS3+4)
   sta irq4.me1+1
   lda #>(PALPOS3+4)
   sta irq4.me2+1
   lda #NTSCPOS0+5
   sta irq3.me1+1  
   bne .fin 
.cl4
   cpx #1
   bne .cl5
;el1 = 0 && el2 = 1
   dec el2
   lda #<irq0
   sta irq0.me1+1
   lda #0
   sta irq0.me2+1
   beq .fin
.cl5
;el1 = 0 && el2 > 3
   dex
   stx el2
   txa
   asl
   asl  ;sets C=0
   sta .mc3+1
   adc #<PALPOS5  ;sets C=0
   sbc #7 ;sets C=1
   sta irq5.me1+1
   txa
.mc3 adc #0  ;sets C=0
   adc #NTSCPOS0-1
   sta irq3.me1+1
   jmp .fin
.cl3
   cpx #1
   bne .cl6
;el1 > 0 && el2 = 1
   dec el2
   lda #0
   sta irq2.me2+1
   lda #$a2
   sta irq2.me3+1
   lda #<irq0
   sta irq2.me1+1
   bne .fin
.cl6
   cpx #2
   bne .cl7
;el1 > 0 && el2 = 2
   dec el2
   lda #<(PALPOS3+4)
   sta irq4.me1+1
   lda #NTSCPOS0+5
   sta irq3.me1+1
   bne .fin
.cl7
   cpx #3
   bne .cl5
;el1 > 0 && el2 = 3
   dec el2
   lda #<(PALPOS3+8)
   sta irq4.me1+1
   lda #0
   sta irq4.me3+1
   lda #$a2
   sta irq4.me4+1
   lda #<irq0
   sta irq4.me5+1
   lda #NTSCPOS0+10
   sta irq3.me1+1
   ;bne .fin
.fin
   jsr showel
   jsr showstat
   inc txtcnt
   lda txtcnt
   and #127
   bne *

   ldx #$77
   lda txtcnt
   bpl .t2

   ldx #$7b
.t2 stx .t1+2
   lda #$b
   sta .t1+5
   ldy #4
   ldx #$70
.t1 lda $7b90,x
   sta $b90,x
   inx
   bne .t1

   inc .t1+2
   inc .t1+5
   dey
   bne .t1
   jmp *

.vl byte 0
.vh byte 0
.rk blk 8

cnt byte 0,0,0,0

pr00     sta pr00000.d+2
         sty xpos
         lda #0
         sta pr00000.d+1
         jmp pr00000.e2

pr0000   sta pr00000.d+2
         sty xpos
         jmp pr00000.e3

pr00000 ;prints ac:xr at $d00,y
         sta .d+2
         sty xpos
         lda #<10000
         sta .d
         lda #>10000
         sta .d+1
         jsr .pr0
.e3      lda #<1000
         sta .d
         lda #>1000
         sta .d+1
         jsr .pr0
         lda #100
         sta .d
         lda #0
         sta .d+1
         jsr .pr0
.e2      lda #10
         sta .d
         jsr .pr0
         txa
         tay
.prd     tya
         eor #$30
         jmp outdigi

.pr0     ldy #255
.prn     iny
         lda .d+2
         cmp .d+1
         bcc .prd
         bne .prc

         cpx .d
         bcc .prd

.prc     txa
         sbc .d
         tax
         lda .d+2
         sbc .d+1
         sta .d+2
         bcs .prn
.d byte 0,0,0

outdigi:
        stx .m+1
        ldx xpos
        sta TEXTBASE,x
        inc xpos
.m      ldx #0
        rts

xpos byte 0

kmatrix blk 8
;   0   1   2   3   4   5   6   7  $ff08
;0 del ret ukp hlp f1  f2  f3   @
;1  3   W   A   4   Z   S   E  sht
;2  5   R   D   6   C   F   T   X
;3  7   Y   G   8   B   H   U   V
;4  9   I   J   0   M   K   O   N
;5 cd   P   L  cu   .   :   -   ,
;6 cl   *   ;  cr  esc  =   +   /
;7  1  clr ctr  2  spc cbm  Q  run

getkmtrix:
    ldx #7
    lda #$7f
    sec
.l1 sta $fd30
    sta $ff08
    pha
    lda $ff08
    sta kmatrix,x
    pla
    dex
    ror
    bcs .l1
    rts

el1 byte 0
el2 byte 0

showel:
   lda #0
   ldx el1
   ldy #2
   jsr pr00
   lda #0
   ldx el2
   ldy #5
   jmp pr00

showstat:
   lda job.vh
   ldx job.vl
   ldy #8
   jsr pr00000
   lda job.vl
   sec
   sbc .fc
   tax
   lda job.vh
   sbc .fc+1
   bcc .l3

   ldy #$2b  ;+
   sty TEXTBASE+14
   ldy #$31  ;1
   bcs .l4
.l3
   txa
   eor #$ff
   tax
   inx
   lda #0
   ldy #$2d  ;-
   sty TEXTBASE+14
.l4
   sty TEXTBASE+20
   sta .my+1
   stx .mx+1
   ldy #$2e  ;.
   sty TEXTBASE+23
   ldy #$25  ;%
   sty TEXTBASE+26
   ldy #15
   jsr pr0000
.my ldy #0
.mx ldx #0
   jsr .ac
   ldy #21
   jsr pr00
   ldx div32x16w.remainder
   ldy div32x16w.remainder+1
   jsr .ac
   ldy div32x16w.remainder+1
   cpy .fch+1
   bcc .l1
   bne .l2

   ldy div32x16w.remainder
   cpy .fch
   bcc .l1

.l2 inx
.l1 ldy #24
   jmp pr00

.ac lda #100
   jsr mul16
   sty div32x16w.dividend+1
   stx div32x16w.dividend
   sta div32x16w.dividend+2
   lda #0
   ldx .fc
   stx div32x16w.divisor
   ldx .fc+1
   stx div32x16w.divisor+1
   jsr div32x16w
   lda #0
   ldx div32x16w.quotient
   rts

.fc word PALSTD
.fch word PALSTD/2

div32x16w:        ;dividend+2 < divisor, divisor < $8000
        ;lda .dividend+3
        ldy #16
.l3     asl .dividend
        rol .dividend+1
        rol .dividend+2
    	rol

        cmp .divisor+1
        bcc .l1
        bne .l2

        ldx .dividend+2
        cpx .divisor
        bcc .l1

.l2     tax
        lda .dividend+2
        sbc .divisor
        sta .dividend+2
        txa
        sbc .divisor+1
	    inc .quotient
.l1     dey
        bne .l3
        sta .remainder+1
        lda .dividend+2
        sta .remainder
        lda #0
        sta .dividend+2
	    sta .dividend+3
	    rts

.dividend byte 0,0,0,0
.quotient = .dividend
.divisor byte 0,0
.remainder byte 0,0

mul16:   ;multiply AC by Y:X -> A:Y:X
    sta .r2
    sty .r0+1
    stx .r0
    ldx #0
    stx .rh
    stx .r0+2
    ldy #0
.t3 lsr .r2
    bcc .t4

    clc
    txa
    adc .r0
    tax
    tya
    adc .r0+1
    tay
    lda .rh
    adc .r0+2
    sta .rh
.t4 asl .r0
    rol .r0+1
    rol .r0+2
    lda .r2
    bne .t3

    lda .rh
    rts

.r0 byte 0,0,0
.r2 byte 0
.rh byte 0

showtext:
      stx .m1+1
      sta .m1+2
      lda #$c
      sta .m2+2
      ldx #0
      stx .m2+1
.l0   jsr .m1
      beq .lx

      cmp #9
      beq .l1

      cmp #$60
      bcc *+4
      eor #$60
      jsr .m2
.l3   jsr .ix
      bne .l0  ;always

.l1   lda #32
      jsr .m2
      jsr .ix
      jsr .m1
      pha
      tay
      lda #32
.l4   jsr .m2
      jsr .ix
      dey
      bne .l4

      pla
      sec
      sbc #1
      eor #$ff
      adc #0  ;C=1
      adc .m1+1  ;C=0
      sta .m1+1
      bcs .l0
      dec .m1+2
      bne .l0  ;always
.lx   rts

.m1   lda $7777,x
      rts

.m2   sta $c00,x
      rts

.ix   inx
      bne .lz

      inc .m1+2
      inc .m2+2
.lz   rts

txtcnt byte 0
text1 byte 9,8,"The extra cycle meter",9,9
      byte 9,9,"v1b, by litwr, 2025",9,50
      byte "It is known that the C+4 PAL has 22,882 CPU cycles per standard video mode screen frame. However, it is possible to switch this machine to NTSC turbo mode. This accelerates the CPU clock to an impressive 2.21 MHz! But this distorts the video signal. What if we only used turbo mode during screen blanking? This would theoretically provide more CPU cycles while maintaining the normal video display. Some monitors allow us to get more extra cycles; others allow fewer.",9,52
      byte "Thanks to Sandor for the initial",9,36,"initiative."
      byte "Big thanks to Luca, siz, and SukkoPera",9,26,"for their help."
      byte "Special thanks to Gaia and IstvanV for",9,25,"their emulators.",0
text2 byte "This program lets us find the maximum number of extra cycles that we can get for the CPU on a particular monitor. Use the cursor keys. Press the up and right keys to increase the number of extra lines before and after the v-sync signals, respectively. The down and left keys decrease the number of extra lines before and after the v-sync.",9,61
      byte "The program displays the number of extra lines before and after the vsync, the total number of cycles per frame, the delta, and the percentage ratio. You may use the additional cycles in your applications as an option! This can give you up to 10% acceleration.",9,59
      byte "The accuracy of this meter is 1 cycle. Idon't still know why sometimes it allowsthis tiny inaccuracy.",9,60,0

init:
;     lda #0
;     sta $ff19   ;black borders
   jsr JPRIMM
   byte 147,9,14,0

   stx $3fff
   stx $7fff
   inc $3fff
   inx
   cpx $7fff
   bne .l1

   jsr JPRIMM
   byte "aT LEAST 32 kb ram IS REQUIRED",0
   rts
.l1
   ldx #<text2
   lda #>text2
   jsr showtext
   ldx #0
   ldy #4
.m3 lda $c00,x
   sta $7c00,x
   inx
   bne .m3

   inc .m3+2
   inc .m3+5
   dey
   bne .m3

   ldx #<text1
   lda #>text1
   jsr showtext
   ldx #0
   ldy #4
.m1 lda $c00,x
   sta $7800,x
   inx
   bne .m1

   inc .m1+2
   inc .m1+5
   dey
   bne .m1

   lda #$ea  ;nop
   ldy #$50
   ldx #0
.m sta track,x
   inx
   bne .m

   inc .m+2
   dey
   bne .m

   jsr showel

     sei
     sta $ff3f
     lda #0
     sta $ff0b
     lda #$a2
     sta $ff0a
     lda #<irq0
     sta $fffe
     lda #>irq0
     sta $ffff
     cli

track:


;for vasm6502/oldstyle

        org $1001
   byte $b,$10,$a,0,$9e
   byte start/1000+48,start%1000/100+48,start%100/10+48,start%10+48
   byte 0,0,0

PALPOS1 = 226
EXTRALINES1 = 6
PALPOS2 = 260
EXTRALINES2 = 2
PALPOS3 = 270
EXTRALINES3 = 4
NTSCPOS0 = 110

    assert >irq1 == >irq6, wrong alignment!
start:
;     lda #0
;     sta $ff19
;   lda #147
;   jsr $ffd2  ;clrscr
   lda #$ea  ;nop
   ldy #$50
   ldx #0
.m sta track,x
   inx
   bne .m

   inc .m+2
   dey
   bne .m

     sei
     sta $ff3f
     lda #PALPOS1
     sta $ff0b
     lda #$a2
     sta $ff0a
     lda #<irq1
     sta $fffe
     lda #>irq1
     sta $ffff
     cli
     jmp *

irq1:   ;? cycles
     sta .m1+1
     ;pha
     lda $ff07
     ora #$40
     ;lda #$48
     sta $ff07
     lda #NTSCPOS0
     sta $ff1d
     lda #NTSCPOS0+EXTRALINES1*5
     sta $ff0b
     lda #<irq2
     sta $fffe
     ;lda #>irqE
     ;sta $ffff
.m1  lda #0
     ;pla
     inc $ff09     
     rti

irq2:  ;? cycles
     sta .m1+1
     ;pha
     lda $ff07
     and #$bf
     sta $ff07
     lda #PALPOS1+EXTRALINES1*4
     sta $ff1d
     lda #<PALPOS2
     sta $ff0b
     lda #$a2 +1
     sta $ff0a

  if 0
     LDA  $FF1E
     AND  #$3E
     lsr
     LSR
     STA *+4
     BPL *
     LDA  #$A9
     LDA  #$A9
     LDA  #$A9
     LDA  #$A9
     LDA  #$A9
     LDA  #$A9
     LDA  #$A9
     LDA  $EA
     lda #0
     lda $ff1e
   endif
     lda #<irq3
     sta $fffe
     ;lda #>irq3
     ;sta $ffff
     ;pla
.m1  lda #0
     inc $ff09
     rti

irq3:   ;? cycles
     sta .m1+1
     lda $ff07
     ora #$40
     ;lda #$48
     sta $ff07
     lda #NTSCPOS0
     sta $ff1d
     lda #0
     sta $ff1c
     lda #NTSCPOS0+EXTRALINES2*5
     sta $ff0b
     lda #$a2+0
     sta $ff0a
     lda #<irq4
     sta $fffe
     ;lda #>irq4
     ;sta $ffff
.m1  lda #0
     inc $ff09
     rti

irq4:  ;? cycles on track
     sta .m1+1
     ;pha
     lda $ff07
     and #$bf
;     lda #$8
     sta $ff07
     lda #<(PALPOS2+EXTRALINES2*4)
     sta $ff1d
     lda #>(PALPOS2+EXTRALINES2*4)
     sta $ff1c
     lda #<PALPOS3
     sta $ff0b
     lda #$a2 + >PALPOS3
     sta $ff0a

     lda #<irq5
     sta $fffe
     ;lda #>irq5
     ;sta $ffff
.m1  lda #0
;     pla
     inc $ff09
     rti

irq5:   ;? cycles
     sta .m1+1
     lda $ff07
     ora #$40
     sta $ff07
     lda #NTSCPOS0
     sta $ff1d
     lda #0
     sta $ff1c
     lda #NTSCPOS0+EXTRALINES3*5
     sta $ff0b
     lda #$a2+0
     sta $ff0a
     lda #<irq6
     sta $fffe
     ;lda #>irq6
     ;sta $ffff
.m1  lda #0
     inc $ff09
     rti

irq6:  ;? cycles on track
     ;pha
     sta .m1+1
     lda $ff07
     and #$bf
;     lda #$8
     sta $ff07
     lda #<(PALPOS3+EXTRALINES3*4)
     sta $ff1d
     lda #>(PALPOS3+EXTRALINES3*4)
     sta $ff1c
     lda #PALPOS1
     sta $ff0b
     ;lda #$a2 +0
     ;sta $ff0a

  if 0
     LDA  $FF1E
     AND  #$3E
     lsr
     LSR
     STA *+4
     BPL *
     LDA  #$A9
     LDA  #$A9
     LDA  #$A9
     LDA  #$A9
     LDA  #$A9
     LDA  #$A9
     LDA  #$A9
     LDA  $EA
     lda #0
     lda $ff1e
   endif
     lda #<irq1
     sta $fffe
     ;lda #>irq1
     ;sta $ffff
   if 1
        stx .m+1
   tsx
   inc .sw+1
.sw lda #0
   and #$f
   bne .l1

   lda $ff02
   adc $ff03
   and #$fb
   sta .sw+1
   lda $103-1,x
   sta cnt
   lda $104-1,x
   sta cnt+1
   lda #<printr
   sta $103-1,x
   lda #>printr
   bne .l2

.l1 lda #<track
    sta $103-1,x
    lda #>track
.l2 sta $104-1,x
.m ldx #0
   endif
.m1  lda #0
     ;pla
     inc $ff09
     rti

cnt byte 0,0

pr00000 ;prints ac:xr
         sta .d+2
         lda #0
         sta xpos
         lda #<10000
         sta .d
         lda #>10000
         sta .d+1
         jsr .pr0
         lda #<1000
         sta .d
         lda #>1000
         sta .d+1
         jsr .pr0
         lda #100
         sta .d
         lda #0
         sta .d+1
         jsr .pr0
         lda #10
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
        sta $c00,x
        inc xpos
.m      ldx #0
        rts

xpos byte 0

printr:
   lda cnt
   sec
   sbc #<track
   sta cnt
   lda cnt+1
   sbc #>track
   asl cnt
   rol
   ldx cnt
   ;sta cnt+1
   jsr pr00000

track:


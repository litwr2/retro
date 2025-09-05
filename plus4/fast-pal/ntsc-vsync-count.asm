;for vasm6502/oldstyle

        org $1001
   byte $b,$10,$a,0,$9e
   byte start/1000+48,start%1000/100+48,start%100/10+48,start%10+48
   byte 0,0,0

EXTRALINES = 8

  if EXTRALINES == 9   ;doesn't work!
PALPOS1 = 250
PALPOS2 = 290
NTSCPOS1 = 204
NTSCPOS2 = 254
  endif
  if EXTRALINES == 8   ;22882 + 8*109 - 54 - 94 = 23606, 33 of 94 for the counter logic, so max 23639 (+757) or approx. 3.31% speedup
PALPOS1 = 250
PALPOS2 = 282
NTSCPOS1 = 204
NTSCPOS2 = 244
  endif
  if EXTRALINES == 7   ;22882 + 7*109 - 54 - 94 = 23497, 33 of 94 for the counter logic, so max 23530 (+648) or approx. 2.83% speedup
PALPOS1 = 250
PALPOS2 = 278
NTSCPOS1 = 210
NTSCPOS2 = 245
  endif
  if EXTRALINES == 6   ;22882 + 6*109 - 54 - 94 = 23388, 33 of 94 for the counter logic, so max 23421 (+539) or approx. 2.36% speedup
PALPOS1 = 250
PALPOS2 = 274
NTSCPOS1 = 216
NTSCPOS2 = 246
  endif
  if EXTRALINES == 5   ;22882 + 5*109 - 54 - 94 = 23279, 33 of 94 for the counter logic, so max 23312 (+430) or approx. 1.88% speedup
PALPOS1 = 250
PALPOS2 = 270
NTSCPOS1 = 221
NTSCPOS2 = 246
  endif
  if EXTRALINES == 4  ;22882 + 4*109 - 54 - 94 = 23170, 33 of 94 for the counter logic, so max 23203 (+321) or approx. 1.40% speedup
PALPOS1 = 250
PALPOS2 = 266
NTSCPOS1 = 225
NTSCPOS2 = 245
  endif

    assert >irqS == >irqE, wrong alignment!
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
     lda #<irqS
     sta $fffe
     lda #>irqS
     sta $ffff
     cli
     jmp *

irqS:   ;53 cycles
     sta .m1+1
     lda $ff07
     ora #$40
     sta $ff07
     lda #NTSCPOS1
     sta $ff1d
     lda #NTSCPOS2
     sta $ff0b
     lda #<irqE
     sta $fffe
     ;lda #>irqE
     ;sta $ffff
.m1  lda #0
     inc $ff09
     rti

irqE:  ;92 cycles on track
     ;pha
     sta .m1+1
     lda $ff07
     and #$bf
     sta $ff07
     lda #<PALPOS2
     sta $ff1d
     lda #>PALPOS2
     sta $ff1c
     lda #PALPOS1
     sta $ff0b

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
     lda #<irqS
     sta $fffe
     ;lda #>irqS
     ;sta $ffff
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


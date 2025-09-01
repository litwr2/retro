;for vasm6502/oldstyle

        org $1001
   byte $b,$10,$a,0,$9e
   byte start/1000+48,start%1000/100+48,start%100/10+48,start%10+48
   byte 0,0,0

PALSTART = 250
PALEND = 266

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
     lda #PALSTART
     sta $ff0b
     lda #$a2
     sta $ff0a
     lda #<irqS
     sta $fffe
     lda #>irqS
     sta $ffff
     cli
     jmp *

irqS:   ;54 cycles
     sta .m1+1
     lda $ff07
     ora #$40
     sta $ff07
     lda #225
     sta $ff1d
     lda #245
     sta $ff0b
     lda #<irqE
     sta $fffe
     ;lda #>irqE
     ;sta $ffff
.m1  lda #0
     inc $ff09
     rti

irqE:  ;89 cycles on track
     pha
     lda $ff07
     and #$bf
     sta $ff07
     lda #<PALEND
     sta $ff1d
     lda #>PALEND
     sta $ff1c
     lda #PALSTART
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

   lda $103,x
   sta cnt
   lda $104,x
   sta cnt+1
   lda #<printr
   sta $103,x
   lda #>printr
   bne .l2

.l1 lda #<track
    sta $103,x
    lda #>track
.l2 sta $104,x
.m ldx #0
     pla
     inc $ff09
     rti

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
   jmp *

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

track:


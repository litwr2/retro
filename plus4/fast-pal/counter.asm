;for vasm6502/oldstyle
;it counts cycles per frame

        org $1001
   byte $d,$10,$a,0,$9e
   byte start/1000+48,start%1000/100+48,start%100/10+48,start%10+48,$3a,$a2
   byte 0,0,0

start:
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
   lda #<irq
   sta $fffe
   lda #>irq
   sta $ffff
   lda #250    ;raster irq line
   sta $ff0b
   lda #$a2 + 0
   sta $ff0a
   cli
   jmp track

irqtime = 61  ;54 (code) + 7 (irq) = 61 cycles on track
irq:
   pha
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
   rol   ;sets C=0
   sta cnt+1
   lda #irqtime
   adc cnt
   tax
   lda #0
   adc cnt+1
   jsr pr00000

track:


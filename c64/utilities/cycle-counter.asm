;for vasm6502/oldstyle

        org $801
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
   lda #$35
   sta 1      ;use HIRAM instead of KERNAL ROM
   lda #<irq
   sta $fffe
   lda #>irq
   sta $ffff
   LDA #%01111111       ; switch off interrupt signals from CIA-1
           STA $DC0D

           AND $D011            ; clear most significant bit of VIC's raster register
           STA $D011

           STA $DC0D            ; acknowledge pending interrupts from CIA-1
           STA $DD0D            ; acknowledge pending interrupts from CIA-2

           LDA #210             ; set rasterline where interrupt shall occur
           STA $D012

           LDA #%00000001       ; enable raster interrupt signals from VIC
           STA $D01A
   cli
   jmp *

irq:    ;59 cycles on track
   pha
   stx .m+1
   tsx
   inc .sw+1
.sw lda #0
   and #$f
   bne .l1

   inc .r+1
.r  lda $800
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
   ASL $D019            ; acknowledge the interrupt by clearing the VIC's interrupt flag
   pla
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
        sta $400,x
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


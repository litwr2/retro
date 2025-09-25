;for vasm6502/oldstyle
;it counts cycles per frame

        org $801
   byte $d,$10,$a,0,$9e
   byte start/1000+48,start%1000/100+48,start%100/10+48,start%10+48
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

           LDA #255             ; set rasterline where interrupt shall occur
           STA $D012     ;bad lines are at 51, 59, ...

           LDA #%00000001       ; enable raster interrupt signals from VIC
           STA $D01A
   cli
   jmp track

irqtime = 71  ;64 (code) + 7 (irq) = 71 cycles on track

irq:
   pha			;3
   stx .m+1		;4
   tsx			;2
   inc .sw+1	;6
.sw lda #0		;2
   and #$f		;2
   bne .l1		;3

   lda #<printr
   sta $103,x
   lda #>printr
   bne .l2

.l1 cmp #2		;2
    bne .l3		;3

   lda $103,x
   sta cnt
   lda $104,x
   sta cnt+1
   bne .l5

.l3 cmp #6		;2
    bne .l5		;3

   lda $103,x
   sta cnt+2
   lda $104,x
   sta cnt+3
.l5
    lda #<track	;2
    sta $103,x	;5
    lda #>track	;2
.l2 sta $104,x	;5
.m ldx #0		;2
   pla			;4
   ASL $D019    ;6        ;acknowledge the interrupt by clearing the VIC's interrupt flag
   rti

cnt byte 0,0,0,0

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
.d = cnt

outdigi:
        stx .m+1
        ldx xpos
        sta $400,x
        inc xpos
.m      ldx #0
        rts

xpos = cnt + 3

printr:
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
   jsr pr00000

track:


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
   sta $ffff  ;sets the IRQ vector
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

irq:    ;39(code) + 7 (IRQ) = 46 cycles
   pha
   stx .m+1
   tsx
   lda #<track
   sta $103,x
   lda #>track
   sta $104,x
.m ldx #0
   ASL $D019            ; acknowledge the interrupt by clearing the VIC's interrupt flag
   pla
   rti

track:


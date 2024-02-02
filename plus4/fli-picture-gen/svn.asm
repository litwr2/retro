;for vasm6502/oldstyle
;bitmap+attr
; 0: $4000-413f    $2800-2827  $3000  $3800  $9000
; 1: $4140-427f    $2828-284f
;23: $5cc0-5dff    $2b98-2bbf
;24: $7e00-7f3f    $6bc0-6be7  $7000  $8000  $8800
;25: $7f40-7fff    $6be8-6bff
;    $6000-607f    $6800-680f
;26: $6080-61c0    $6810-6837
;28: $6300-643f    $6860-6887
;31: $66c0-67ff    $68d8-68ff
;line 202 gets -56 = 146
;line 206 gets +30 = 236 interrupt
;line 284 gets +26 = 310 interrupt

VSIZE = 264  ;value less than 225 makes images compatible with both PAL and NTSC
             ;this value must be a multiple of 8 and in the range 208-264

        org $1001
   byte $b,$10,$a,0,$9e
   byte start/1000+48,start%1000/100+48,start%100/10+48,start%10+48
   byte 0,0,0

     macro setmc
     lda #\1     ;3x,$9a - 4x,$ca
     sta $ff15   ;3x,$a2 - 4x,$9a
     lda #\2     ;3x,$ae - 4x,$aa
     sta $ff16   ;3x,$b2 - 4x,$ae
     endm

     macro gap
     setmc $24,$25
     nop   ;3x,$b8
     nop   ;3x,$bc
     nop   ;3x,$c0
     nop   ;4x,$c4
     setmc $26,$27
     endm

     macro zline
     lda #$3d
     sta $ff06   ;$b8, it sets the value at $be
     lda #\1
     sta $ff14

     gap

     lda #$3f
     sta $ff06
     lda #\2
     sta $ff14

     gap

     lda #$39
     sta $ff06
     lda #\3
     sta $ff14

     gap

     lda #$3b
     sta $ff06
     lda #\4
     sta $ff14
     endm

     macro iline
     gap
     zline \1,\2,\3,\4
     endm

start:
     lda #0
     sta $ff19   ;border color
     nop
     nop
     jsr init

     sei
     sta $ff3f
     lda #2
     sta $ff0b
     lda #$a2
     sta $ff0a
     lda #<irq2
     sta $fffe
     lda #>irq2
     sta $ffff
     cli
     jmp *

irq2:
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

   rept 6
     nop
   endr
     lda #$10     ;bitmap at $4000
     sta $ff12

     lda $ea  ;2:$ba
     nop  ;2:$be
     nop  ;2:$c2
     ldx #$24  ;3:$c6
     ldy #$25  ;3:$ca

  rept 23          ;starts at 3:$96
     iline $30,$38,$90,$28
  endr
     iline $30,$38,$90,$98

     stx $ff15
     sty $ff16
     lda #$18   ;$b0, bitmap at $6000
     sta $ff12  ;$b4
     lda #396-VSIZE   ;$bc
     sta $ff1d  ;$c0, it sets the value at $c6
     lda #$26   ;$c8
     sta $ff15  ;$96
     lda #$27   ;$a6
     sta $ff16
     zline $70,$80,$88,$98

  rept VSIZE/8-26
     iline $70,$80,$88,$98
  endr
     iline $70,$80,$88,$28

     lda #205
     sta $ff0b
     lda #<irq205
     sta $fffe
     lda #>irq205
     sta $ffff
     inc $ff09
     rti

irq205:
     pha
  if VSIZE > 224
     lda #VSIZE-21
  else
     lda #VSIZE+1
  endif
     sta $ff1d

  if VSIZE > 224
     lda #$a3
     sta $ff0a
     lda #<284
  else
     lda #245
  endif
     sta $ff0b

     lda #<irq284  ;245
     sta $fffe
     lda #>irq284  ;245
     sta $ffff

     pla
     inc $ff09
     rti

irq284:   ;245
     pha
  if VSIZE > 224
     lda #<310
  else
     lda #249
  endif
     sta $ff1d

     lda #2
     sta $ff0b
     lda #$a2
     sta $ff0a

     lda #<irq2
     sta $fffe
     lda #>irq2
     sta $ffff

     pla
     inc $ff09
     rti

     org $2800    ;attr 0-1: 0-23
     rept $3c0
     byte 0
     endr   ;$2bc0
;$40-9
init:
     lda $ff07
     ora #$10
     sta $ff07   ;multicolor mode
     rts

     org $2c00    ;clrs 0-1: 0-23
     rept $3c0
     byte 0
     endr   ;$2fc0
;$40
     org $3000    ;attr 2-3: 0-23
     rept $3c0
     byte 0
     endr   ;$3cc0
;$40
     org $3400    ;clrs 2-3: 0-23
     rept $3c0
     byte 0
     endr   ;$37c0
;$40
     org $3800    ;attr 3-4: 0-23
     rept $3c0
     byte 0
     endr   ;$3bc0
;$40
     org $3c00    ;clrs 3-4: 0-23
     rept $3c0
     byte 0
     endr   ;$3fc0
;$40
     org $4000    ;bm 0-191
     rept $1e00
     byte $55
     endr   ;$5e00
;$200
     org $6000    ;bm 200-207 (24-39), 208-263
     rept $940
     byte $55
     endr   ;$6940
;$6c0     
     org $7000    ;attr 2-3: 25 (24-39), 26-32
     rept $128
     byte 0
     endr   ;$7128
;$298
     org $73c0    ;attr 2-3: 24, 25 (0-23)
     rept $40
     byte 0
     endr   ;$7400
;0
     org $7400    ;clrs 2-3: 25 (24-39), 26-32
     rept $128
     byte 0
     endr   ;$7528
;$298
     org $77c0    ;clrs 2-3: 24, 25 (0-23)
     rept $40
     byte 0
     endr   ;$7800
;$600
     org $7e00    ;bm 192-199, 200-207 (0-23)
     rept $200
     byte $55
     endr   ;$8000
;0
     org $8000    ;attr 4-5: 25 (24-39), 26-32
     rept $128
     byte 0
     endr   ;$8128
;$298
     org $83c0    ;attr 4-5: 24, 25 (0-23)
     rept $40
     byte 0
     endr   ;$8400
;0
     org $8400    ;clrs 4-5: 25 (24-39), 26-32
     rept $128
     byte 0
     endr   ;$8528
;$298
     org $87c0    ;clrs 4-5: 24, 25 (0-23)
     rept $40
     byte 0
     endr   ;$8800
;0
     org $8800     ;attr 6-7: 25 (24-39), 26-32
     rept $128
     byte 0
     endr   ;$8928
;$298
     org $8bc0    ;attr 6-7: 24, 25 (0-23)
     rept $40
     byte 0
     endr   ;$8c00
;0
     org $8c00   ;clrs 6-7: 25 (24-39), 26-32
     rept $128
     byte 0
     endr   ;$8d28
;$298
     org $8fc0    ;clrs 6-7: 24, 25 (0-23)
     rept $40
     byte 0
     endr   ;$9000
;0
     org $9000    ;attr 6-7, 0-23
     rept $3c0
     byte 0
     endr   ;$93c0
;$40
     org $9400    ;clrs 6-7, 0-23
     rept $3c0
     byte 0
     endr   ;$97c0
;$40
     org $9800    ;attr 0-1: 25 (24-39), 26-32
     rept $128
     byte 0
     endr   ;$9928
;$298
     org $9bc0    ;attr 0-1: 24, 25 (0-23)
     rept $40
     byte 0
     endr   ;$9c00
;0
     org $9c00    ;clrs 0-1: 25 (24-39), 26-32
     rept $128
     byte 0
     endr   ;$9d28
;$298
     org $9fc0    ;clrs 0-1: 24, 25 (0-23)
     rept $40
     byte 0
     endr   ;$9000


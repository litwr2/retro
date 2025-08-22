       .include "macro-old.s"

       * = $1001
       .BYTE $16,$10,0,0,$9E
       .NULL "4120:litwr-2012"
       .BYTE 0,0

       LDA #$0B
       STA $FF06
       JSR $E2EA
       LDA #2
       sta 2
       LDA #$48
       STA $FF07
       SEI
       STA $FF3F
       ldy #242
       sty $ff1d
       LDX #$EE
       LDY #0
       sty $ff1c
l2     LDA $FF1E
       CMP #$40
       BCS l2
sval = $b8 ;+$18/$16(zp/#)=start cycle#
       LDA #(255-sval).3  ;. means OR
       STA $FF1E
       LDA $FF1E
       AND #2  ;#/zp 2/3 cycles
       BNE l3
cval = $56;$56
l3     LDA #(255-cval).3
start  #line2m
       #line3_128
       #line2
       #line3_16
       #line3_8
       #line2
       #line2m
       #line2
       #line3s
       #line3_128
       #line3_8
;start of vertical blanking
       #line3_16
       #line3
       #line2o
       jmp start


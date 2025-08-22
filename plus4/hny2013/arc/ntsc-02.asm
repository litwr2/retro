;for the TMPX assembler
      .include "macro-old.s"

       * = $1001
       .BYTE $16,$10,0,0,$9E
       .byte <start/1000+48,<(start-((start/1000)*1000))/100+48
       .byte <(start-((start/100)*100))/10+48,<start-((start/10)*10)+48
       .NULL ":litwr-2012/25"
       .BYTE 0,0

start  LDA #$0B
       STA $FF06
       JSR $E2EA
       LDA #2
       sta 2
       LDA #$48
       STA $FF07
       SEI
ival = $a
       LDX #(255-ival).3
       LDY #$EE
l2     LDA $FF1E
       CMP #$40
       BCS l2
sval = $d6 ;+$18/$16(zp/#)=start cycle#
       LDA #(255-sval)
       STA $FF1E
       LDA $FF1E
       AND #2  ;#/zp 2/3 cycles
       BNE l3
cval = $3e;$56
l3     LDA #(255-cval).3
       #line2cx


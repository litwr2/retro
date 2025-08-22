	.include "waitcyc.s"
	.include "ntsc-lines.s"

chargen = $9000

       * = $1001
       .BYTE $16,$10,0,0,$9E
       .NULL "4120:LITWR-2012"
       .BYTE 0,0

delay1 = 80
delay2 = 40
       LDY #0
       sty $d1
       dey
       sty $d0
       ldy #delay1
       sty $d4
       lda #50
       sta $d3
       LDA #$0B
       STA $FF06
       JSR $E2EA  ;delay
       SEI
       LDA #$48
       STA $FF07
       STA $FF3F
       ldy #242
       sty $ff1d
       LDX #$FF
       LDY #0
       sty $ff1c
l2     LDA $FF1E
       CMP #$40
       BCS l2
sval = $b8 ;+$18/$16(zp/#)=start cycle#
       LDA #(255-sval)
       STA $FF1E
       LDA $FF1E
       AND #2  ;#/zp 2/3 cycles
       BNE l3
;$5E 135 cycs
;$5A 137
;$56 139
;$52 141
;$4E 143  NTSC - 142.5
cval = $4e
l3     LDA #(255-cval)

start
;7 codes lines  
       #line2b  
       #line2b
       #line2b  
       #line2b
       #line2b  
       #line2b
       #line2b
;150+1+137 video lines
       #line2b_4
       #line2b_2
scr1
       #line2b_2
       #line2b_8
       #line2b_64
       #line2b_64

       #line2b
       #line2b
       #line2b
       #line2b
       #line2b
       #line2b
scr3
       #line3sx
scr2
       #line2b_64
       #line2b_64
       #line2b_8
       #line2b
;start of vertical blanking
;16+1 code lines
       #line2b_8
       #line2b_4
       #line2cb1
       #line2cb2
       #line2cb3
       #line2cb
       #line2o


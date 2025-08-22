;for the TMPX assembler

	.include "../waitcyc.s"

line2o .macro   ;open, needs 7 cycs
       #cyc 10
       sta $ff1e
       #cyc 5
       #wait4
       #wait4
       #wait4
       ldy #0
       ldx #$ee
       jmp start
       .endm

line2  .macro
       #cyc 10
       sta $ff1e
       #cyc 5
       #wait4
       #wait4
       #wait3
       #wait4
       #wait4
       .endm

line2_2 .macro
       #line2
       #line2
       .endm

line2_4 .macro
       #line2_2
       #line2_2
       .endm

line2_8 .macro
       #line2_4
       #line2_4
       .endm

line2_16 .macro
       #line2_8
       #line2_8
       .endm

line2_32 .macro
       #line2_16
       #line2_16
       .endm

line2_64 .macro
       #line2_32
       #line2_32
       .endm

line2_128 .macro
       #line2_64
       #line2_64
       .endm

line3sx .macro
       #wait24
       #wait24
       #wait24
       #wait8
       sta $ff1e
       lda $ff1d
       sec
       sbc #50
       sta $ff1d
       LDA #(255-cval).3
       #wait24
       #wait12
       #wait2
       #wait3
       #wait4
       .endm

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
       LDA #(255-sval)  ;. means OR
       STA $FF1E
       LDA $FF1E
       AND #2  ;#/zp 2/3 cycles
       BNE l3
;$5E 135 cycs
;$5A 137
;$56 139
;$52 141
;$4E 143  NTSC - 142.5
cval = $4E
l3     LDA #(255-cval)

start
;7 codes lines
       #line2 
       #line2
       #line2
       #line2
       #line2
       #line2
       #line2
;150+1+137 video lines
       #line2_16
       #line2_16
       #line2_16
       #line2_16
       #line2_16
       #line2_16
       #line2_16
       #line2_16
       #line2_16
       #line2_4
       #line2_2
       #line3sx
       #line2_128
       #line2_8
       #line2
;start of vertical blanking
;16+1 code lines
       #line2
       #line2
       #line2
       #line2
       #line2
       #line2
       #line2
       #line2
       #line2
       #line2
       #line2
       #line2
       #line2
       #line2
       #line2
       #line2
       #line2o


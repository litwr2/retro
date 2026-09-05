;vasm-oldstyle
;$4A5-$4E6 free

    * = $1001
pbasic
  word .pli20,10
  byte $8f," ** FBI+4 V2 ***",0
.pli20
  word .pli30,20
  byte $8f," ****** - ******",0
.pli30
  word .pli40,30
  byte $8f," ** FASTER *****",0
.pli40
  word .pli50,40
  byte $8f," **** BASIC ****",0
.pli50
  word .pli60,50
  byte $8f," * INTERPRETER *",0
.pli60
  word .pli70,60
  byte $8f," ** BY LITWR ***",0
.pli70
  word .pli80,70
  byte $8f," ** 2020, 26 ***",0
.pli80
  word .eob-2,80
  byte $9e,start/1000+"0",start%1000/100+"0",start%100/10+"0",start%10+"0",0  ;sys
  byte 0,0,0
.eob

start
  LDX  #0
loop1
  LDA $8000, X
  STA $8000, X
  INX
  BNE loop1

  INC loop1+2
  INC loop1+5
  LDA loop1+2
  CMP #$FD
  BNE loop1

  LDX #$40
loop4
  LDA $FF00,X
  STA $FF00,X
  INX
  BNE loop4

  stx $8fc5  ;ds bug
  LDA #$B1  ;lda (zp),y
  STA $A324
  STA $AD8E
  INX
loop0
  STA $878D,X
  STA $87D6,X
  STA $8A11,X
  STA $8BEC,X
  STA $8BFA,X
  STA $8C00,X
  STA $8C06,X
  STA $8DD1,X
  STA $8DF9,X
  STA $924A,X
  STA $9250,X
  STA $9256,X
  STA $9497,X
  STA $A437,X
  STA $AC2C,X
  STA $B459,X
  STA $B45F,X
  STA $B465,X
  STA $B46F,X
  STA $B475,X
  STA $B5E3,X
  STA $B5E9,X
  STA $B5EF,X

  STA $8776,X
  STA $8823,X
  STA $8829,X
  STA $8831,X
  STA $89F8,X
  STA $8EF4,X
  STA $8F9E,X
  STA $8FA5,X
  STA $8FAA,X
  STA $8FB7,X
  STA $9095,X
  STA $97C6,X
  STA $97CB,X
  STA $97D0,X
  STA $97D8,X
  STA $97E6,X
  STA $9802,X
  STA $980A,X
  STA $9813,X
  STA $9C35,X
  STA $9C96,X
  STA $9C9B,X
  STA $9CA0,X
  STA $9D77,X
  STA $9E2C,X
  STA $A10D,X
  STA $A113,X
  STA $A119,X
  STA $A11F,X
  STA $A12F,X
  STA $A9A7,X
  STA $A9D8,X
  STA $ADA5,X
  STA $AF6C,X
  STA $B54D,X
  STA $B823,X
  STA $B98D,X
  STA $BA1E,X
  STA $BA5C,X
  STA $C845,X
  STA $C898,X
  STA $CAC2,X
  STA $CBC0,X
  STA $CC74,X

  STA $9DB4,X
  STA $ADBD,X
  STA $BD5F,X
  STA $BD85,X
  STA $C779,X
  STA $C81C,X
  STA $C84F,X
  STA $C8A9,X

  STA $9B85,X
  STA $9BEE,X
  STA $9C1D,X
  STA $9C22,X
  STA $9C27,X

  STA $873D,X
  STA $874B,X
  STA $8A47,X
  STA $8A4E,X
  STA $8A5F,X
  STA $8A6D,X
  STA $8A72,X
  STA $8B04,X
  STA $8B0A,X
  STA $8B17,X
  STA $8B1C,X
  STA $8B2E,X
  STA $8B33,X
  STA $8B66,X
  STA $8B7D,X
  STA $9715,X
  STA $9721,X
  STA $98F6,X
  STA $98FE,X
  STA $990A,X
  STA $9912,X
  STA $992C,X
  STA $99C3,X
  STA $99D3,X
  STA $99E2,X
  STA $9A31,X
  STA $9A37,X
  STA $AE74,X
  STA $AE7B,X
  STA $AE80,X
  STA $AEA1,X

  STA $8F0D,X
  STA $8F2B,X
  STA $8F34,X
  STA $8F42,X
  STA $9507,X
  STA $950C,X
  STA $9BF3,X
  STA $AF0D,X
  STA $AF16,X
  STA $B692,X
  LDA #$EA  ;nop
  DEX
  BMI *+5
  JMP loop0

  LDA #$3B
  STA $AD8F

  STA $878D+2
  STA $87D6+2
  STA $8A11+2
  STA $8BEC+2
  STA $8BFA+2
  STA $8C00+2
  STA $8C06+2
  STA $8DD1+2
  STA $8DF9+2
  STA $924A+2
  STA $9250+2
  STA $9256+2
  STA $9497+2
  STA $A437+2
  STA $AC2C+2
  STA $B459+2
  STA $B45F+2
  STA $B465+2
  STA $B46F+2
  STA $B475+2
  STA $B5E3+2
  STA $B5E9+2
  STA $B5EF+2
  LDA #$22
  STA $8776+2
  STA $8823+2
  STA $8829+2
  STA $8831+2
  STA $89F8+2
  STA $8EF4+2
  STA $8F9E+2
  STA $8FA5+2
  STA $8FAA+2
  STA $8FB7+2
  STA $9095+2
  STA $97C6+2
  STA $97CB+2
  STA $97D0+2
  STA $97D8+2
  STA $97E6+2
  STA $9802+2
  STA $980A+2
  STA $9813+2
  STA $9C35+2
  STA $9C96+2
  STA $9C9B+2
  STA $9CA0+2
  STA $9D77+2
  STA $9E2C+2
  STA $A10D+2
  STA $A113+2
  STA $A119+2
  STA $A11F+2
  STA $A12F+2
  STA $A9A7+2
  STA $A9D8+2
  STA $ADA5+2
  STA $AF6C+2
  STA $B54D+2
  STA $B823+2
  STA $B98D+2
  STA $BA1E+2
  STA $BA5C+2
  STA $C845+2
  STA $C898+2
  STA $CAC2+2
  STA $CBC0+2
  STA $CC74+2
  LDA #$24
  STA $9DB4+2
  STA $ADBD+2
  STA $BD5F+2
  STA $BD85+2
  STA $C779+2
  STA $C81C+2
  STA $C84F+2
  STA $C8A9+2
  LDA #$6F
  STA $9B85+2
  STA $9BEE+2
  STA $9C1D+2
  STA $9C22+2
  STA $9C27+2
  LDA #$5F
  STA $873D+2
  STA $874B+2
  STA $8A47+2
  STA $8A4E+2
  STA $8A5F+2
  STA $8A6D+2
  STA $8A72+2
  STA $8B04+2
  STA $8B0A+2
  STA $8B17+2
  STA $8B1C+2
  STA $8B2E+2
  STA $8B33+2
  STA $8B66+2
  STA $8B7D+2
  STA $9715+2
  STA $9721+2
  STA $98F6+2
  STA $98FE+2
  STA $990A+2
  STA $9912+2
  STA $992C+2
  STA $99C3+2
  STA $99D3+2
  STA $99E2+2
  STA $9A31+2
  STA $9A37+2
  STA $AE74+2
  STA $AE7B+2
  STA $AE80+2
  STA $AEA1+2
  LDA #$64
  STA $8F0D+2
  STA $8F2B+2
  STA $8F34+2
  STA $8F42+2
  STA $9507+2
  STA $950C+2
  STA $9BF3+2
  STA $AF0D+2
  STA $AF16+2
  STA $B692+2

  LDA #$7D
  STA $8EF8
  LDA #$60   ;RTS
  STA $A326
  STA $AD90
  LDA #$22
  STA $A325

  lda #$80  ;memtop
  sta $f392

  LDX #0
loop2
  LDA L0473,X
  STA $8123,X
  INX
  CMP #$60
  BNE loop2

  LDX #L0494.E-L0494-1
loop3
  LDA L0494,X
  STA $8144,X
  DEX
  BPL loop3

  ldx #5
loop8
  lda SYMSG,x
  sta $80e3,x
  dex
  bpl loop8

  LDX #0
loop5
  LDA L07D9,X
  STA $cfb3,X
  INX
  CMP #$60
  BNE loop5

  LDA #$3F
  sta $fff7  ;reset

  ldx #2   ;RS-232 routine fix, from Your Commodore 8/1987 pages 78-84
loop6
  lda LEB1B,x
  sta $eb1b,x
  dex
  bpl loop6

  ldx #6
loop7
  lda PCH,x
  sta $cec5,x
  dex
  bpl loop7

  ldx #4   ;RS-232C routine fix from seff, https://plus4world.powweb.com/forum/45313#post21
loop10
  lda LEAA7,x
  sta $eaa7,x
  dex
  bpl loop10

  lda #$d0  ;ff28 bug fix from seff, https://plus4world.powweb.com/forum/45313#post27
  sta $f580
  lda #$fc
  sta $f581

  ldx #6
loop11
  lda LFCD1,x
  sta $fcd1,x
  dex
  bpl loop11

  lda #$ae  ;https://www.c64-wiki.com/wiki/Multiply_bug
  sta $a090  ;the C64 $ba28 corresponds the C+4 $a078
  sta $a09f  ;this fix slightly slows down arithmetical ops

  lda #$c9  ;ds bug: https://plus4world.powweb.com/plus4encyclopedia/500292
  sta $8fc4

  STA $FF3F
  JMP $FFF6

L0473  ;at $8123
   INC  $3B
   BNE  *+4
   INC  $3C
   ;SEI
   ;STA  $FF3F
   LDY  #$00
   LDA  ($3B), Y
   ;STA  $FF3E
   ;CLI
   CMP  #$3A
   BCS  .L2
   CMP  #$20
   BEQ  L0473
   SEC
   SBC  #$30
   SEC
   SBC  #$D0
.L2 RTS

L0494  ;at $8144
   rorg $494
.S
   STA  .M1
   ;SEI
   ;STA  $FF3F
.M1 = * + 1
   LDA  ($3B),Y
   ;STA  $FF3E
   ;CLI
   RTS
.PMSG
   LDA $37
   SEC
   SBC $2b
   JMP $80ea
   rend
.E

L07D9  ;at $cfb3
   rorg $7d9
   PHP
   JMP .L1
   SEI
   ;STA  $FF3F
.L1 LDA  ($00), Y
   ;STA  $FF3E
   PLP
   RTS
   rend

LEB1B JMP $CEC5

PCH STA $7CF
    PLA
    JMP $EB1E

LEAA7 BYTE $8d,$d5,7,$f0,$16

LFCD1 lda #0
      sta $79
      jmp $8003

SYMSG BYTE "F ",0
    jmp L0494.PMSG-L0494.S+$8144


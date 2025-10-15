;for vasm6502/oldstyle
;more extra lines can affect disk operations!

        org $1001
   include "fpal-basic.s"
;   byte $d,$10,$a,0,$9e
   byte start/1000+48,start%1000/100+48,start%100/10+48,start%10+48
   byte 0,0,0

;VR = 0   ;0 is a bit faster but skips several minor system activities
         ;1 requires el1>4 !!!
BLACKB = 0  ;1 blackens NTSC borders and consumes upto 40 cycles more per frame

PALPOS0 = 250
PALPOS3 = 260
PALPOS4 = 268
PALPOS5 = 270
NTSCPOS0 = 4

INT2STR = $a45f  ;prints ac:xr
JPRIMM = $ff4f

	org $1300
irq1:
     lda #NTSCPOS0
     sta $ff1d
     lda $ff07
     ora #$40
     sta $ff07
  if BLACKB
     lda $ff19
.r1  sta irq4.m2+1
     lda #0
     sta $ff19
  endif
.r6  lda #<irq2
     sta $314
   if VR
     tsx
     lda $105,x
.r2  sta .m2+1
     lda $106,x
.r3  sta .m2+2
.r4  lda #>.p1
     sta $106,x
.r5  lda #<.p1
     sta $105,x
.m1  jmp 0
.p1  php
     pha
.me1 lda #0  ;NTSCPOS0+EL1*5
     sta $ff0b
     pla
     plp
.m2  jmp 0
   else
.me1 lda #0  ;NTSCPOS0+EL1*5
     sta $ff0b
     ;jsr $e3e4  ;tape
     inc $ff09
     jsr $cfbf  ;timer + ...
     jsr $cecd
     ;save $fb, cli
     jsr $db11
     ;restore $fb
     jmp $fcbe
   endif

irq2:
     lda $ff07
     and #$bf
     sta $ff07
     lda #PALPOS0
     sta $ff1d
     lda #<PALPOS3
     sta $ff0b
     lda #$a3
     sta $ff0a
.r1  lda #<irq3
     sta $314
     inc $ff09
     jmp $fcbe

irq3:
     lda #$40
     sta $ff1c
     ;lda #NTSCPOS0
     ;sta $ff1d
     ora $ff07
     sta $ff07
.me1 lda #0  ;NTSCPOS0+5*EL2
     sta $ff0b
     lda #$a2
     sta $ff0a
.r1  lda #<irq4
     sta $314
     inc $ff09
     jmp $fcbe

irq4:
     lda $ff07
     and #$bf
     sta $ff07
     lda #<PALPOS4
     sta $ff1d
     lda #>PALPOS4
     sta $ff1c
     lda #<PALPOS5
     sta $ff0b
     lda #$a2 + >PALPOS5
     sta $ff0a
.r1  lda #<irq5
     sta $314
  if BLACKB
.m2  lda #0
     sta $ff19
  endif
     inc $ff09
     jmp $fcbe

irq5:
.me1 lda #0  ;<PALPOS5+4*EL2-8
     sta $ff1d
.me2 lda #0  ;PALPOS0-4*EL1
     sta $ff0b
     lda #$a2
     sta $ff0a
.r1  lda #<irq1
     sta $314
     inc $ff09
     jmp $fcbe

acoff:
     sei
     lda #$e
     ldx #$ce
     bne acon.le

acon:
     sei
.m1  lda #0
.m2  ldx #0
.le  sta $314
     stx $315
     cli
     rts

     byte 0
SOB
     byte 0,0

start:
     ldx #$10
     lda $2002
     bne .l4

     ldx #3
     clc
     lda #$32
     sta .m1+1
     sta .m3+1
     sta acon.m1+1
     adc irq1.r6+1
     sta irq1.r6+1
     lda #$32
     adc irq2.r1+1
     sta irq2.r1+1
     lda #$32
     adc irq3.r1+1
     sta irq3.r1+1
     lda #$32
     adc irq4.r1+1
     sta irq4.r1+1
     lda #$32
     adc irq5.r1+1
     sta irq5.r1+1
  if BLACKB
     lda #$32
     adc irq1.r1+1
     sta irq1.r1+1
  endif  
  if VR
     lda #$32
     adc irq1.r2+1
     sta irq1.r2+1
     lda #$32
     sta irq1.r5+1
     adc irq1.r3+1
     sta irq1.r3+1
  endif
.l4  stx .m1+2
     stx .m2+1
     stx acon.m2+1
  if BLACKB
     sta irq1.r1+2
  endif
  if VR
     sta irq1.r2+2
     sta irq1.r3+2
     sta irq1.r4+1
     lda $314
     sta irq1.m1+1
     lda $315
     sta irq1.m1+2
  endif
     lda $2000  ;el1
     asl
     asl  ;sets C=0
     sta $2003
     eor #$ff
     adc #PALPOS0+1  ;PALPOS0-4*el1
     sta irq5.me2+1

     lda $2000
     adc $2003  ;C=1, sets C=0
     adc #NTSCPOS0-1  ;NTSCPOS0+5*el1
     sta irq1.me1+1

     lda $2001  ;el2
     asl
     asl   ;sets C=0
     sta $2003
     adc #<PALPOS5-8  ;sets C=0
     sta irq5.me1+1  ;PALPOS5+4*el2-8
     lda $2003
     adc $2001  ;sets C=0
     adc #NTSCPOS0
     sta irq3.me1+1  ;NTSCPOS0+5*el2

     jsr JPRIMM
     byte "SYS",0

     clc
     lda .m1+1
     adc #<acoff
     tax
     lda .m1+2
     jsr INT2STR
     jsr JPRIMM
     byte " - THROTTLE OFF",13,0     

     jsr JPRIMM
     byte "SYS",0

     clc
     lda .m1+1
     adc #<acon
     tax
     lda .m1+2
     jsr INT2STR
     jsr JPRIMM
     byte " - THROTTLE ON",13,0
     ldx #0
.l1  lda $1300,x
.m1  sta $1000,x
     inx
     cpx #<start
     bne .l1

     ldx $2002
     beq .l2

     dex
     beq .l5

     lda #0
     sta $4001
     sta $4002
     sta $4000
     lda #$40
     bne .l6

.l5  lda #<SOB
     sta $2b
     lda #>SOB-3
     sta $2c
     lda #>start-3
     sta $2e
     sta $30
     sta $32
     lda #<start
     bne .l3

.l2  lda #0
     sta $1001
     sta $1002
     lda #$10
.l6  sta $2c
     sta $2e
     sta $30
     sta $32
     lda #1
     sta $2b
     lda #3
.l3  sta $2d
     sta $2f
     sta $31

     sei
     lda irq5.me2+1
     sta $ff0b
     ;lda #$a2
     ;sta $ff0a
.m3  lda #<irq1
     sta $314
.m2  lda #0
     sta $315
     cli
     sec
     lda $33
     sbc $2b
     tax
     lda $34
     sbc $2c
     jsr INT2STR
     jsr JPRIMM
     byte " BYTES FREE",0
     rts


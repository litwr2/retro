;for vasm6502/oldstyle

        org $1001
   byte $d,$10,$a,0,$9e
   byte start/1000+48,start%1000/100+48,start%100/10+48,start%10+48,$3a,$a2
   byte 0,0,0

VR = 1   ;0 is a bit faster but skips several minor system activities
EL1 = 11  ;it must be between 1 and 11, more means faster but more distortions
EL2 = 12  ;it must be between 3 and 12
BLACKB = 0  ;1 means blacken NTSC borders and consuming upto 40 cycles per frame

PALPOS0 = 250
PALPOS3 = 260
PALPOS4 = 268
PALPOS5 = 270
NTSCPOS0 = 80

irq1:
     lda $ff07
     ora #$40
     sta $ff07
  if BLACKB
     lda $ff19
     sta irq4.m2+1
     lda #0
     sta $ff19
  endif
     lda #NTSCPOS0
     sta $ff1d
     ;lda #NTSCPOS0+EL1*5
     ;sta $ff0b
     ;lda #$a2
     ;sta $ff0a
     lda #<irq2
     sta $314
     ;lda #>irqE
     ;sta $315

   if VR
     tsx
     lda $105,x
     sta .m2+1
     lda $106,x
     sta .m2+2
     lda #>.p1
     sta $106,x
     lda #<.p1
     sta $105,x
.m1  jmp 0
.p1  php
     pha
     lda #NTSCPOS0+EL1*5
     sta $ff0b
     ;lda #$a2
     ;sta $ff0a
     pla
     plp
.m2  jmp 0
   else
     lda #NTSCPOS0+EL1*5
     sta $ff0b
     ;lda #$a2
     ;sta $ff0a
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
     ;lda #0
     ;sta $ff1c
.me2 lda #<PALPOS3
     sta $ff0b
.me3 lda #$a3
     sta $ff0a
.me1 lda #<irq3
     sta $314
     inc $ff09
     jmp $fcbe

irq3:
     lda $ff07
     ora #$40
     sta $ff07
     lda #NTSCPOS0
     sta $ff1d
     lda #0
     sta $ff1c
.me1 lda #NTSCPOS0+5*EL2
     sta $ff0b
     lda #$a2
     sta $ff0a
     lda #<irq4
     sta $314
     ;lda #>irq4
     ;sta $315
     inc $ff09
     jmp $fcbe

irq4:
     lda $ff07
     and #$bf
     sta $ff07
.me1 lda #<PALPOS4
     sta $ff1d
.me2 lda #>PALPOS4
     sta $ff1c
.me3 lda #<PALPOS5
     sta $ff0b
.me4 lda #$a2 + >PALPOS5
     sta $ff0a
.me5 lda #<irq5
     sta $314
     ;lda #>irq5
     ;sta $315
  if BLACKB
.m2  lda #0
     sta $ff19
  endif
     inc $ff09
     jmp $fcbe

irq5:
.me1 lda #<PALPOS5+4*EL2-8
     sta $ff1d
     lda #<PALPOS0-4*EL1
     sta $ff0b
     lda #$a2
     sta $ff0a
     lda #<irq1
     sta $314
     ;lda #>irq1
     ;sta $315
     inc $ff09
     jmp $fcbe

     byte 0
SOB
     byte 0,0
SOT
     byte 0

start:
     sei
     lda #<SOB
     sta $2b
     lda #>SOB
     sta $2c
     lda #<SOT
     sta $2d
     sta $2f
     sta $31
     lda #>SOT
     sta $2e
     sta $30
     sta $32

     lda #PALPOS0-4*EL1
     sta $ff0b
     ;lda #$a2
     ;sta $ff0a
   if VR
     lda $314
     sta irq1.m1+1
     lda $315
     sta irq1.m1+2
   endif
     lda #<irq1
     sta $314
     lda #>irq1
     sta $315
     cli
     rts


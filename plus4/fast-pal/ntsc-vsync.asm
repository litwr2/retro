;for vasm6502/oldstyle

        org $1001
   byte $b,$10,$a,0,$9e
   byte start/1000+48,start%1000/100+48,start%100/10+48,start%10+48
   byte 0,0,0

PALSTART = 250

    assert >irqS == >irqE, wrong alignment!
start:
;     lda #0
;     sta $ff19
     sei
     sta $ff3f
     lda #PALSTART   ;start
     sta $ff0b
     lda #$a2
     sta $ff0a
     lda #<irqS
     sta $fffe
     lda #>irqS
     sta $ffff
     cli
     ;jmp *
     jmp $3000

irqS:
     sta .m1+1
     lda $ff07
     ora #$40
     sta $ff07
     lda #225
     sta $ff1d
     lda #245
     sta $ff0b
     lda #<irqE
     sta $fffe
     ;lda #>irqE
     ;sta $ffff
.m1  lda #0
     inc $ff09
     rti

irqE:
     pha
     lda $ff07
     and #$bf
     sta $ff07
     lda #<266
     sta $ff1d
     lda #>266
     sta $ff1c
     lda #PALSTART
     sta $ff0b

  if 0
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
     lda #0
     lda $ff1e
   endif
     lda #<irqS
     sta $fffe
     ;lda #>irqS
     ;sta $ffff
     pla
     inc $ff09
     rti

     include "count.s"


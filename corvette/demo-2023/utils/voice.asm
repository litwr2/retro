;for assembler PASMO
;plays a sound sample in the INC-format
;on the Corvette (PC-8010/8020)

FREQ EQU 8000

BDOS equ 5

IOBASE EQU      0FB00H  ;ODOSA
SOUNDM  EQU     3     ;timer control register
SOUNDD  EQU     0     ;timer counter
PIC2    EQU     32H   ;timer output enable/disable, port C

    org 100h
l0  di
    ld a,$30
    ld (IOBASE+SOUNDM),a
    xor a
    ld (IOBASE+SOUNDD),a
    ld (IOBASE+SOUNDD),a
    call delay
    ld hl,data
l2  ld b,8
    ld c,(hl)
l1  ld a,c
    ld d,8
    rrca
    jp nc,$+5
    ld d,0
    ld c,a
    ld a,d
    ld (IOBASE+PIC2),a
    call delay
    dec b
    jp nz,l1   ;approx +68 ticks per the loop

    inc hl
    ld a,low(dataend)
    cp l
    jp nz,l2

    ld a,high(dataend)
    cp h
    jp nz,l2

    ei

    ld hl,10000
l7  push hl
    call delay
    pop hl
    dec hl
    ld a,l
    or h
    jp nz,l7

    ld c,6   ;direct console i/o
    ld e,0ffh
    call BDOS
    or a
    jp z,l0
    rst 0

if 0
DELAY equ 20325   ;2500000/20325 approx= 123
delay proc
      local l1,l2
      xor a
      ld (IOBASE+SOUNDM),a
      ld a,(IOBASE+SOUNDM)
      ld e,a
      ld a,(IOBASE+SOUNDM)
      ld d,a
l1    xor a
      ld (IOBASE+SOUNDM),a
      ld a,(IOBASE+SOUNDM)   ;13
      sub e                  ;4
      cpl                    ;4
      ld e,a                 ;5
      ld a,(IOBASE+SOUNDM)   ;13
      sbc a,d                ;4
      cpl
      inc e
      jp nz,$+4
      inc a
      cp high(DELAY)         ;7
      jp c,l1                ;10
      jp nz,l2               ;10

      ld a,e                 ;5
      cp high(DELAY)  ;2500000/8000 approx= 313 ticks, 313-190=123 ticks, up to 446 ticks, too inaccurate
      jp c,l1

l2    ret         ;+126 ticks
      endp
endif

if FREQ=8000
delay proc
      local l3
      ld e,6   ;6*36 + 29 + 68 = 313, 2500000/313 approx= 7987 Hz
l3    push hl  ;11
      pop hl   ;10
      dec e    ;5
      jp nz,l3 ;10

      or a     ;4
      or a
      or a
      ret      ;10
      endp
else
delay proc
      local l3
      ld e,2   ;2*36 + 17 + 68 = 157, 2500000/157 approx= 15924 Hz
l3    push hl  ;11
      pop hl   ;10
      dec e    ;5
      jp nz,l3 ;10
      ret      ;10
      endp
endif

data
      include vbpm.inc
dataend

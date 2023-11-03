BDOS equ 5

GRBASE  EQU     04000H  ;DOSG1
TXBASE  EQU     0FC00H  ;ODOSA
RGBASE2 EQU     0FA00H  ;ODOSA
IOBASE EQU      0FB00H  ;ODOSA
RGBASE3 EQU     0FF00H  ;DOSG1

SYSREG  EQU     7FH
DOSG1   EQU     3CH
ODOSA   EQU     1CH

NCREG   EQU     0BFH  ;color reg
LUT     EQU     0FBH  ;palette reg
VIREG   EQU     3AH   ;image control register
SOUNDM  EQU     3     ;timer control register
SOUNDD  EQU     0     ;timer counter
PIC2    EQU     32H   ;timer output enable/disable, port C

AUTOFILL equ 0
ENGLISH equ 0

SBX equ 0
SBY equ 1
XB  equ 2
GDE equ 3
PSP equ 5
SPHX equ 7
SPH equ 11
SPHL equ 12
SPHD equ 13
SPRDC equ 14
SPRDP equ 15
SPRD equ 17

TEXTDELAY equ 6
FLSHDELAY equ 5

getc macro   ;b - x-bit, de - xy, hl - ncreg, c - 0
    local l1,l2,l3
    ld hl,RGBASE3+NCREG
    ld (hl),$10
    ld a,(de)
    and b
    jp z,l1

    ld c,2
l1  ld (hl),$20
    ld a,(de)
    and b
    jp z,l2

    ld a,4
    or c
    ld c,a
l2  ld (hl),$40
    ld a,(de)
    and b
    jp z,l3

    ld a,8
    or c
    ld c,a
l3  ld a,$80
    or c
    endm

    org 100h
    call init
    jp m,exit0

    ld hl,sprites
l7  ld e,(hl)
    inc l
    ld d,(hl)
    ld a,e
    or d
    jp z,l28

    inc l
    ex de,hl
    ld (cursprite),hl
    push de
    call putsprite
    pop hl
    jp l7

l28 call checkk
    cp $1b   ;ESC
    jp z,exit1

    ld hl,sprites
l27 push hl
    call scroll1
    call chgcolrs
    pop hl
    ld e,(hl)
    inc l
    ld d,(hl)
    ld a,e
    or d
    jp z,l28

    ex de,hl
    ld (cursprite),hl
    inc de    ;(de) -> XB
    push de
    ld de,SPRDP
    add hl,de
    push hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld a,(de)
    push de
    ld hl,l30
    push hl
    dec a
    jp z,spritel

    dec a
    jp z,spriteu

    dec a
    jp z,spriter

    dec a
    jp z,sprited
    ;pop hl
    jp spritep
l30 pop de
    pop hl
    dec hl
    dec (hl)
    jp nz,l34

    inc de
    ld a,(de)
    or a
    jp z,l35

    ld (hl),a
    inc hl
l36 inc de
    ld (hl),e
    inc hl
    ld (hl),d
l34 pop hl
    jp l27

l35 ld e,l
    ld d,h
    inc de
    inc de
    inc de
    ld a,(de)
    ld (hl),a
    inc hl
    jp l36
exit1
    call extra
exit0
    call final
    rst 0

fillall proc
if AUTOFILL
    local l0,l1,l2,l3,l4,colors
else
    local l4
endif
    ld a,DOSG1
    di
    ld (RGBASE2+SYSREG),a
    ld de,GRBASE
    ld bc,$4000
    ld a,$80
    ld (RGBASE3+NCREG),a
    ld a,$ff
l4  ld (de),a
    inc de
    dec c
    jp nz,l4

    dec b
    jp nz,l4
if AUTOFILL
    ld de,colors
    ld hl,GRBASE
l0  ld b,$40
    ld a,(de)
    ld c,a
l1  ld a,c
    xor $c
    ld c,a
    ld (RGBASE3+NCREG),a
    ld a,$f0  ;$aa
    ld (hl),a
    inc hl
    dec b
    jp nz,l1

    ld b,$40
l2  ld a,c
    ;xor $c
    ld c,a
    ld (RGBASE3+NCREG),a
    ld a,$f   ;55
    ld (hl),a
    inc hl
    dec b
    jp nz,l2

    inc de
    ld a,e
    cp low(colors+7)
    jp nz,l3

    ld de,colors
l3  ld a,h
    cp $80
    jp nz,l0
endif
    ld a,ODOSA
    ld (RGBASE3+SYSREG),a
    ei
    ret
if AUTOFILL
colors db $82,$86,$8a,$8e,$84,$88,$8c
endif
    endp

loadpic proc
    local exit,l1,l3,l4,l8
    ld c,$f    ;open
    ld de,fcb_drive
    call BDOS
    or a
    jp m,exit

    ld a,1
    ld (gcnt),a
l1  ld hl,GRBASE
    ld a,(gcnt)
    ld b,a
    ld a,1
l3  rlca
    dec b
    jp nz,l3

    xor $e
    or $71
    ld (RGBASE2+NCREG),a
    ld a,128
l8  push af
    push hl
    ld c,$14  ;read 128 bytes
    ld de,fcb_drive
    call BDOS
    ld de,$80  ;default DMA
    pop hl
    ld a,DOSG1
    di
    ld (RGBASE2+SYSREG),a
l4  ld a,(de)
    ld (hl),a
    inc hl
    inc e
    jp nz,l4

    ld a,ODOSA
    ld (RGBASE3+SYSREG),a
    ei
    pop af
    dec a
    jp nz,l8

    ld hl,gcnt
    ld a,(hl)
    inc a
    ld (hl),a
    inc hl
    cp (hl)
    jp nz,l1

    ld c,$10   ;close
    ld de,fcb_drive
    call BDOS
    xor a
exit
    ret
    endp

putsprite proc
    local l1,l2,l3
    ld hl,(cursprite)
    inc l
    inc l
    ld b,(hl)
    inc l
    ld e,(hl)
    inc l
    ld d,(hl)   ;de - top left corner
    inc l
    ld a,(hl)
    inc l
    ld h,(hl)
    ld l,a
    ld a,DOSG1
    di
    ld (RGBASE2+SYSREG),a
l1  push hl
    ld c,0
    getc
    pop hl
    ld (hl),a
    inc h
    ld a,(hl)
    cp $80
    jp z,l3

    ld (RGBASE3+NCREG),a
    ld a,b
    ld (de),a
l3  ld a,b
    dec h
    inc l
    rrca
    ld b,a
    jp nc,l2

    inc de
l2  ld a,l
    and 15
    ld a,b
    jp nz,l1

    ld a,62
    add a,e
    ld e,a
    ld a,d
    adc a,0
    ld d,a
    ld a,l
    or a
    ld a,b
    jp nz,l1
    jp el1
    ret
    endp

spritel proc
    local l0,l2,l5,l6,l7,m1,m2,m3,m4,m5
    ld hl,(cursprite)
    ld a,(hl)
    ld (m3+1),a
    ld (m4+1),a
    inc l
    ld a,(hl)
    ld (m3+2),a
    ld (m4+2),a
    inc l
    ld a,(hl)
    rlca     ;left
    ld (hl),a
    inc l
    ld e,(hl)
    inc l
    ld d,(hl)   ;get pointer to top-left corner of the sprite in vram
    ld b,a
    jp nc,$+4
    dec de
    ld (hl),d
    dec l
    ld (hl),e
    inc l
    inc l
    ld a,(hl)
    inc l
    push de
    push hl
    ld h,(hl)
    ld l,a
    ld a,h
    ld (m1+1),a
    ld (m2+1),a
    inc h

    pop de
    inc e
    ld a,(de)  ;SPHX+L
    add a,h
    ld h,a
    inc e
    inc e
    inc e
    inc e
    ld a,(de)   ;SPH
    ld c,a
    add a,h
    ld h,a
    inc e
    ld a,(de)   ;SPHL
    inc c
    cp c
    jp nz,l7

    inc e
    ld a,(de)  ;SPHD
    dec e
    sub c
    cpl
    inc a
    ld c,a
l7  ld a,c
    dec e
    ld (de),a
    pop de
    ld a,DOSG1
    di
    ld (RGBASE2+SYSREG),a
l0  ld c,0  ;save the upcoming new edge
    push hl
    getc
    ld (m5+1),a
    pop hl
l2  ld a,(hl)
    cp $80
    jp nz,l5

    ld a,l
    and $f
    jp z,l6

    push hl
    ld c,l
m3  ld hl,0
    dec a
    add a,l
    and $f
    ld l,a
    ld a,c
    and $f0
    add a,h
    add a,l
m1  ld h,high(sbg1)
    ld l,a
    ld a,(hl)
    pop hl
l5  ld (RGBASE3+NCREG),a
    ld a,b
    ld (de),a
l6  ld a,b
    inc l
    rrca
    ld b,a
    jp nc,$+4
    inc de
    ld a,l
    and 15
    jp nz,l2

    push hl
    ld c,l
m4  ld hl,0
    ld a,l
    dec a
    and 15
    add a,h
    sub $10
    add a,c
m2  ld h,high(sbg1)
    ld l,a
    ld a,(hl)
    ld (RGBASE3+NCREG),a
    ld a,b
    ld (de),a
m5  ld a,0
    ld (hl),a
    ld hl,62
    add hl,de
    ex de,hl
    pop hl
    ld a,l
    or a
    jp nz,l0

    ld hl,(cursprite)
    ld a,(hl)
    dec a
el2 and $f
    ld (hl),a
el1 ld a,ODOSA
    ld (RGBASE3+SYSREG),a
    ei
    ret
    endp

spriter proc
    local l0,l2,l5,l6,l7,m1,m2,m3,m4,m5
    ld hl,(cursprite)
    ld a,(hl)
    ld (m3+1),a
    ld (m4+1),a
    inc l
    ld a,(hl)
    ld (m3+2),a
    ld (m4+2),a
    inc l
    ld a,(hl)
    ld b,a
    rrca     ;right
    ld (hl),a
    inc l
    ld e,(hl)     ;get pointer to top-left corner of the sprite in vram
    inc l
    ld d,(hl)
    push de
    jp nc,$+4
    inc de
    ld (hl),d
    dec l
    ld (hl),e
    pop de
    inc de
    inc de    ;get pointer to top-right corner of the sprite in vram
    inc l
    inc l
    ld a,(hl)
    add a,16
    inc l
    push de
    push hl
    ld h,(hl)
    ld l,a
    ld a,h
    ld (m1+1),a
    ld (m2+1),a
    inc h
    pop de
    inc e
    inc e
    inc e
    ld a,(de)   ;SPHX+R
    add a,h
    ld h,a
    inc e
    inc e
    ld a,(de)   ;SPH
    ld c,a
    add a,h
    ld h,a
    inc e
    ld a,(de)   ;SPHL
    inc c
    cp c
    jp nz,l7

    inc e
    ld a,(de)  ;SPHD
    dec e
    sub c
    cpl
    inc a
    ld c,a
l7  ld a,c
    dec e
    ld (de),a
    pop de
    ld a,DOSG1
    di
    ld (RGBASE2+SYSREG),a
l0  ld c,0  ;save the upcoming new edge
    push hl
    getc
    ld (m5+1),a
    pop hl
l2  dec hl
    ld a,(hl)
    cp $80
    jp nz,l5

    ld a,l
    inc a
    and $f
    jp z,l6

    push hl
    ld c,l
m3  ld hl,0
    add a,l
    and $f
    ld l,a
    ld a,c
    and $f0
    add a,h
    add a,l
m1  ld h,high(sbg1)
    ld l,a
    ld a,(hl)
    pop hl
l5  ld (RGBASE3+NCREG),a
    ld a,b
    ld (de),a
l6  ld a,b
    rlca
    ld b,a
    jp nc,$+4
    dec de
    ld a,l
    and 15
    jp nz,l2

    push hl
    ld a,l
m4 ld hl,0
    add a,h
    add a,l
m2  ld h,high(sbg1)
    ld l,a
    ld a,(hl)
    ld (RGBASE3+NCREG),a
    ld a,b
    ld (de),a
m5  ld a,0
    ld (hl),a
    ld hl,66
    add hl,de
    ex de,hl
    pop hl
    ld a,32
    add a,l
    ld l,a
    ld a,h
    adc a,0
    ld h,a
    ld a,l
    cp $10
    jp nz,l0

    ld hl,(cursprite)
    ld a,(hl)
    inc a
    jp el2
    endp

sprited proc
    local l0,l2,l5,l6,l7,m1,m2,m3,m4,m5
    ld hl,(cursprite)
    ld a,(hl)
    ld (m3+1),a
    ld (m4+1),a
    inc l
    ld a,(hl)
    ld (m3+2),a
    ld (m4+2),a
    inc l
    ld a,(hl)
    inc l
    ld e,(hl)
    inc l
    ld d,(hl)     ;get pointer to top-left corner of the sprite in vram
    push de
    ex de,hl
    ld bc,64
    add hl,bc
    ex de,hl
    ld (hl),d
    dec l
    ld (hl),e
    pop de
    ld b,a
    ld a,4    ;high(64*16)
    add a,d
    ld d,a    ;get pointer to bottom-left corner of the sprite in vram
    inc l
    inc l
    ld a,(hl)
    add a,16*15
    inc l
    push de
    push hl
    ld h,(hl)
    ld l,a
    ld a,h
    ld (m1+1),a
    ld (m2+1),a
    inc h
    pop de
    inc e
    inc e
    inc e
    inc e
    ld a,(de)     ;SPHX+D
    add a,h
    ld h,a
    inc e
    ld a,(de)   ;SPH
    ld c,a
    add a,h
    ld h,a
    inc e
    ld a,(de)   ;SPHL
    inc c
    cp c
    jp nz,l7

    inc e
    ld a,(de)  ;SPHD
    dec e
    sub c
    cpl
    inc a
    ld c,a
l7  ld a,c
    dec e
    ld (de),a
    pop de
    ld a,DOSG1
    di
    ld (RGBASE2+SYSREG),a
l0  ld c,0  ;save the upcoming new edge
    push hl
    getc
    ld (m5+1),a
    pop hl
l2  ld a,(hl)
    cp $80
    jp nz,l5

    ld a,l
    add a,$10
    jp c,l6

    push hl
    ld c,l
m3  ld hl,0
    add a,h
    and $f0
    ld h,a
    ld a,c
    add a,l
    and $f
    add a,h
m1  ld h,high(sbg1)
    ld l,a
    ld a,(hl)
    pop hl
l5  ld (RGBASE3+NCREG),a
    ld a,b
    ld (de),a
l6  ld a,e
    sub 64
    ld e,a
    ld a,d
    sbc a,0
    ld d,a
    ld a,$f0
    add a,l
    ld l,a
    add a,$10
    jp nc,l2

    push hl
m4  ld hl,0
    add a,l
    and 15
    add a,h
m2  ld h,high(sbg1)
    ld l,a
    ld a,(hl)
    ld (RGBASE3+NCREG),a
    ld a,b
    ld (de),a
m5  ld a,0
    ld (hl),a
    pop hl
    ld a,4
    add a,d
    ld d,a
    ld a,b
    rrca
    ld b,a
    jp nc,$+4
    inc de
    inc l
    jp nz,l0

    ld hl,(cursprite)
    inc l
    ld a,(hl)
    add a,$10
el3 ld (hl),a
    jp el1
    endp

spriteu proc
    local l0,l2,l5,l6,l7,m1,m2,m3,m4,m5
    ld hl,(cursprite)
    ld a,(hl)
    ld (m3+1),a
    ld (m4+1),a
    inc l
    ld a,(hl)
    ld (m3+2),a
    ld (m4+2),a
    inc l
    ld a,(hl)
    inc l
    ld e,(hl)
    inc l
    ld d,(hl)     ;get pointer to top-left corner of the sprite in vram
    ex de,hl
    ld bc,-64
    add hl,bc
    ex de,hl
    ld (hl),d ;get pointer to upper-left corner of the sprite in vram
    dec l
    ld (hl),e
    ld b,a
    inc l
    inc l
    ld a,(hl)
    inc l
    push de
    push hl
    ld h,(hl)
    ld l,a
    ld a,h
    ld (m1+1),a
    ld (m2+1),a
    inc h
    pop de
    inc e
    inc e
    ld a,(de)  ;SPHX+U
    add a,h
    ld h,a
    inc e
    inc e
    inc e
    ld a,(de)   ;SPH
    ld c,a
    add a,h
    ld h,a
    inc e
    ld a,(de)   ;SPHL
    inc c
    cp c
    jp nz,l7

    inc e
    ld a,(de)  ;SPHD
    dec e
    sub c
    cpl
    inc a
    ld c,a
l7  ld a,c
    dec e
    ld (de),a
    pop de
    ld a,DOSG1
    di
    ld (RGBASE2+SYSREG),a
l0  ld c,0  ;save the upcoming new edge
    push hl
    getc
    ld (m5+1),a
    pop hl
l2  ld a,(hl)
    cp $80
    jp nz,l5

    ld a,l
    and $f0
    jp z,l6

    push hl
    ld c,l
m3  ld hl,0
    add a,h
    add a,$f0
    ld h,a
    ld a,l
    add a,c
    and $f
    add a,h
m1  ld h,high(sbg1)
    ld l,a
    ld a,(hl)
    pop hl
l5  ld (RGBASE3+NCREG),a
    ld a,b
    ld (de),a
l6  ld a,e
    add a,64
    ld e,a
    ld a,d
    adc a,0
    ld d,a
    ld a,$10
    add a,l
    ld l,a
    jp nc,l2

    push hl
m4  ld hl,0
    add a,l
    and 15
    add a,h
    add a,$f0
m2  ld h,high(sbg1)
    ld l,a
    ld a,(hl)
    ld (RGBASE3+NCREG),a
    ld a,b
    ld (de),a
m5  ld a,0
    ld (hl),a
    pop hl
    ld a,d
    sub 4
    ld d,a
    ld a,b
    rrca
    ld b,a
    jp nc,$+4
    inc de
    inc l
    ld a,l
    and 15
    jp nz,l0

    ld hl,(cursprite)
    inc l
    ld a,(hl)
    sub $10
    jp el3
    endp

spritep proc
    local l0,l2,l7
    ld hl,(cursprite)
    inc l
    inc l
    ld b,(hl)
    inc l
    ld e,(hl)
    inc l
    ld d,(hl)     ;get pointer to top-left corner of the sprite in vram
    inc l
    ld a,(hl)
    inc l
    push de
    ld d,h
    ld e,l
    ld h,(hl)
    ld l,a
    inc h
    inc e
    inc e
    inc e
    inc e
    ld a,(de)     ;SPHX+D
    add a,h
    ld h,a
    inc e
    ld a,(de)   ;SPH
    ld c,a
    add a,h
    ld h,a
    inc e
    ld a,(de)   ;SPHL
    inc c
    cp c
    jp nz,l7

    inc e
    ld a,(de)  ;SPHD
    dec e
    sub c
    cpl
    inc a
    ld c,a
l7  ld a,c
    dec e
    ld (de),a
    pop de
    ex de,hl

    ld a,DOSG1
    di
    ld (RGBASE2+SYSREG),a
l0  ld a,(de)
    cp $80
    jp z,l2

    ld (RGBASE3+NCREG),a
    ld (hl),b
l2  ld a,b
    rrca
    ld b,a
    jp nc,$+4
    inc hl
    inc e
    ld a,e
    or a
    jp z,el1

    and $f
    jp nz,l0

    ld a,62
    add a,l
    ld l,a
    ld a,h
    adc a,0
    ld h,a
    jp l0
    endp

        include sprites.s
scb8    db 0     ;+SBX   ;arrow-sprite
        db 0     ;+SBY, must be after SBX
        db 8   ;XB   X = (GX-1)*8+7-log2(XB)
        dw 39+22*64+GRBASE   ;X+Y*64+GRBASE   ;+GDE
        dw sbg8  ;+PSP
        db 0,6,12,18  ;+SPHX, lurd
        db 0     ;+SPH
        db 6     ;+SPHL
        db 6     ;+SPHD
        db 40    ;+SPRDC, sprdp must be the next
        dw scb8+SPRD+1  ;+SPRDP, sprd must be the next
        db 40,1,40,3,88,1
        db 18,4,@DU4,18,4,@DU4,18,4,@DU4,18,4,@DU4,18,4,@DU4,18,4,@DU4,18,4,@DU4
        db 61,4
        db 18,3,@RL4,18,3,@URDL3,18,3,@RL4,18,3,@URDL3,18,3,@RL4,18,3,@RL4,18,3,@RL4
        db 88,3
        db 18,2,@UD4,18,2,@UD4,18,2,@UD4,18,2,@UD4,18,2,@UD4,18,2,@UD4,18,2,@UD4
        db 61,2
        db 18,1,@LR4,18,1,@LR4,18,1,@LR4,18,1,@LR4,18,1,@LR4,18,1,@LR4,18,1,@LR4
        db 0 ;+SPRD, 0 - end, 1 -left, 2 -up, 3 -right, 4 -down

scb3    db 0     ;+SBX  ;K-sprite
        db 0     ;+SBY, must be after SBX
        db 2   ;XB
        dw 41+22*64+GRBASE   ;X+Y*64+GRBASE   ;+GDE
        dw sbg3  ;+PSP
        db 0,0,0,0  ;+SPHX, lurd
        db 0     ;+SPH
        db 1     ;+SPHL
        db 1     ;+SPHD
        db 20    ;+SPRDC, sprdp must be the next
        dw scb3+SPRD+1  ;+SPRDP, sprd must be the next
        db 20,4,40,2,20,4,88,1
        db @UD2,18,1,18,4,@LR2,18,4,@LR2,18,4
        db @LR2,18,4,@LR2,18,4,@LR2,18,4,@LR2
        db 61,4
        db 13,5,18,4,18,3,13,5,18,3,13,5,18,3,13,5,18,3,13,5,18,3,13,5,18,3,13,5
        db 88,3
        db 13,5,18,3,18,2,13,5,18,2,13,5,18,2,13,5,18,2,13,5,18,2,13,5,18,2,13,5
        db 61,2
        db 13,5,18,2,18,1,13,5,18,1,13,5,18,1,13,5,18,1,13,5,18,1,13,5,18,1,13,5
        db 0 ;+SPRD, 0 - end, 1 -left, 2 -up, 3 -right, 4 -down

scb2    db 0     ;+SBX   ;O-sprite
        db 0     ;+SBY, must be after SBX
        db $80   ;XB
        dw 44+22*64+GRBASE   ;X+Y*64+GRBASE   ;+GDE
        dw sbg2  ;+PSP
        db 0,0,0,0  ;+SPHX, lurd
        db 0     ;+SPH
        db 1     ;+SPHL
        db 1     ;+SPHD
        db 20    ;+SPRDC, sprdp must be the next
        dw scb2+SPRD+1  ;+SPRDP, sprd must be the next
        db 20,2,40,4,20,2,88,1
        db @DU2,18,1,@DU2,18,1,18,4,@RL2,18,4
        db @RL2,18,4,@RL2,18,4,@RL2,18,4,@RL2
        db 61,4
        db 13,5,18,4,13,5,18,4,18,3,13,5,18,3,13,5,18,3,13,5,18,3,13,5,18,3,13,5
        db 88,3
        db 13,5,18,3,13,5,18,3,18,2,13,5,18,2,13,5,18,2,13,5,18,2,13,5,18,2,13,5
        db 61,2
        db 13,5,18,2,13,5,18,2,18,1,13,5,18,1,13,5,18,1,13,5,18,1,13,5,18,1,13,5
        db 0 ;+SPRD, 0 - end, 1 -left, 2 -up, 3 -right, 4 -down

scb4    db 0     ;+SBX  ;P-sprite
        db 0     ;+SBY, must be after SBX
        db $20   ;XB
        dw 46+22*64+GRBASE   ;X+Y*64+GRBASE   ;+GDE
        dw sbg4  ;+PSP
        db 0,0,0,0  ;+SPHX, lurd
        db 0     ;+SPH
        db 1     ;+SPHL
        db 1     ;+SPHD
        db 20    ;+SPRDC, sprdp must be the next
        dw scb4+SPRD+1  ;+SPRDP, sprd must be the next
        db 20,4,40,2,20,4,88,1
        db @UD2,18,1,@UD2,18,1,@UD2,18,1,18,4
        db @LR2,18,4,@LR2,18,4,@LR2,18,4,@LR2
        db 61,4
        db 13,5,18,4,13,5,18,4,13,5,18,4,18,3,13,5,18,3,13,5,18,3,13,5,18,3,13,5
        db 88,3
        db 13,5,18,3,13,5,18,3,13,5,18,3,18,2,13,5,18,2,13,5,18,2,13,5,18,2,13,5
        db 61,2
        db 13,5,18,2,13,5,18,2,13,5,18,2,18,1,13,5,18,1,13,5,18,1,13,5,18,1,13,5
        db 0 ;+SPRD, 0 - end, 1 -left, 2 -up, 3 -right, 4 -down

scb5    db 0     ;+SBX  ;B-sprite
        db 0     ;+SBY, must be after SBX
        db 8   ;XB
        dw 48+22*64+GRBASE   ;X+Y*64+GRBASE   ;+GDE
        dw sbg5  ;+PSP
        db 0,0,0,0  ;+SPHX, lurd
        db 0     ;+SPH
        db 1     ;+SPHL
        db 1     ;+SPHD
        db 20    ;+SPRDC, sprdp must be the next
        dw scb5+SPRD+1  ;+SPRDP, sprd must be the next
        db 20,2,40,4,20,2,88,1
        db @DU2,18,1,@DU2,18,1,@DU2,18,1,@DU2,18,1
        db 18,4,@RL2,18,4,@RL2,18,4,@RL2
        db 61,4
        db 13,5,18,4,13,5,18,4,13,5,18,4,13,5,18,4,18,3,13,5,18,3,13,5,18,3,13,5
        db 88,3
        db 13,5,18,3,13,5,18,3,13,5,18,3,13,5,18,3,18,2,13,5,18,2,13,5,18,2,13,5
        db 61,2
        db 13,5,18,2,13,5,18,2,13,5,18,2,13,5,18,2,18,1,13,5,18,1,13,5,18,1,13,5
        db 0 ;+SPRD, 0 - end, 1 -left, 2 -up, 3 -right, 4 -down

scb6    db 0     ;+SBX  ;E-Sprite
        db 0     ;+SBY, must be after SBX
        db 2   ;XB
        dw 50+22*64+GRBASE   ;X+Y*64+GRBASE   ;+GDE
        dw sbg6  ;+PSP
        db 0,0,0,0  ;+SPHX, lurd
        db 0     ;+SPH
        db 1     ;+SPHL
        db 1     ;+SPHD
        db 20    ;+SPRDC, sprdp must be the next
        dw scb6+SPRD+1  ;+SPRDP, sprd must be the next
        db 20,4,40,2,20,4,88,1
        db @UD2,18,1,@UD2,18,1,@UD2,18,1,@UD2
        db 18,1,@UD2,18,1,18,4,@LR2,18,4,@LR2
        db 61,4
        db 13,5,18,4,13,5,18,4,13,5,18,4,13,5,18,4,13,5,18,4,18,3,13,5,18,3,13,5
        db 88,3
        db 13,5,18,3,13,5,18,3,13,5,18,3,13,5,18,3,13,5,18,3,18,2,13,5,18,2,13,5
        db 61,2
        db 13,5,18,2,13,5,18,2,13,5,18,2,13,5,18,2,13,5,18,2,18,1,13,5,18,1,13,5
        db 0 ;+SPRD, 0 - end, 1 -left, 2 -up, 3 -right, 4 -down

scb7    db 0     ;+SBX  ;T-sprite
        db 0     ;+SBY, must be after SBX
        db $80   ;XB
        dw 53+22*64+GRBASE   ;X+Y*64+GRBASE   ;+GDE
        dw sbg7  ;+PSP
        db 0,0,0,0  ;+SPHX, lurd
        db 0     ;+SPH
        db 1     ;+SPHL
        db 1     ;+SPHD
        db 20    ;+SPRDC, sprdp must be the next
        dw scb7+SPRD+1  ;+SPRDP, sprd must be the next
        db 20,2,40,4,20,2,88,1
        db @DU2,18,1,@DU2,18,1,@DU2,18,1
        db @DU2,18,1,@DU2,18,1,@DU2,18,1,18,4,@RL2
        db 61,4
        db 13,5,18,4,13,5,18,4,13,5,18,4,13,5,18,4,13,5,18,4,13,5,18,4,18,3,13,5
        db 88,3
        db 13,5,18,3,13,5,18,3,13,5,18,3,13,5,18,3,13,5,18,3,13,5,18,3,18,2,13,5
        db 61,2
        db 13,5,18,2,13,5,18,2,13,5,18,2,13,5,18,2,13,5,18,2,13,5,18,2,18,1,13,5
        db 0 ;+SPRD, 0 - end, 1 -left, 2 -up, 3 -right, 4 -down

scb1    db 0     ;+SBX   ;man-sprite
        db 0     ;+SBY, must be after SBX
        db $20   ;XB
        dw 55+22*64+GRBASE   ;X+Y*64+GRBASE   ;+GDE
        dw sbg1  ;+PSP
        db 0,3,6,9  ;+SPHX, lurd
        db 0     ;+SPH
        db 3     ;+SPHL
        db 3     ;+SPHD
        db 40    ;+SPRDC, sprdp must be the next
        dw scb1+SPRD+1  ;+SPRDP, sprd must be the next
        db 40,3,40,1,88,1
        db @UD2,18,1,@UD4,18,1,@UD2,18,1,@URDL3
        db 18,1,@UD2,18,1,@UD2,18,1,@UD2,18,1
        db 61,4
        db @LR2,18,4,@RL4,18,4,@LR4,18,4,@RL2
        db 18,4,@LR2,18,4,@LR4,18,4,@RL4,18,4
        db 88,3
        db @UD4,18,3,@LR4,18,3,@UD4,18,3,@LR4,18,3,@UD4,18,3,@UD4,18,3,@LR4,18,3
        db 61,2
        db @LR4,18,2,@RL4,18,2,@DU4,18,2,@RL4,18,2,@DU4,18,2,@RL4,18,2,@DU2,18,2
        db 0 ;+SPRD, 0 - end, 1 -left, 2 -up, 3 -right, 4 -down 

cursprite dw scb1
sprites dw scb8,scb3,scb2,scb4,scb5,scb6,scb7,scb1,0
sprclst dw sprite7lr,sprite6,sprite8,sprite9,sprite2,sprite3,0
sprclstp dw sprclst
sprclstc db FLSHDELAY
gcnt db 0
gcnp db 4  ;must be after gcnt
;pal1 db 0,$11,$82,$43,$74,$F5,$a8,$a9,$aa,$ab,$ac,$ad
pal1 db 0,$11,$82,$43,$74,$f5,$e8,$e9,$ea,$eb,$ec,$6d
;pal2 db 0,$81,$72,$f3,$c8,$c9,$ca,$cb
pal2 db 0,$81,$72,$f3,$c8,$c9,$ca,$4b
pal3 db 0,$a1,$12,$23,$f4,$55,$66,$b7,$78,$c9,$da,$9b,$3c,$8d,$ee,$4f
pal4 db 0,$21,$f3,$77,$45,$e6,$12,$64

if (sprites and $ff00) != ((sprclst-2) and $ff00) or (sprclst and $ff00) != ((sprclstp-2) and $ff00)
    .error alignment
endif
if scb1 + SPRD + 2 > $4000
    .error memory limit
endif

waiti proc
    local l1
    ld hl,vbtr
    xor a
    ld (hl),a
l1  or (hl)
    jp z,l1
    ret
    endp

chgcolrs proc
    local l1,l2,l8,l9,l10
    ld hl,sprclstc
    dec (hl)
    jp nz,l1

    ld (hl),FLSHDELAY
    ld hl,(sprclstp)
l2  ld e,(hl)
    inc l
    ld d,(hl)
    ex de,hl
    ld a,l
    or h
    jp nz,l8

    ld hl,sprclst
    ld (sprclstp),hl
    jp l2

l8  ld a,(hl)
    and $e
    jp z,l10

l9  add a,2
    and $e
    jp z,l9
    
    or $80
    ld (hl),a
l10 inc l
    jp nz,l8

    inc e
    ex de,hl
    ld (sprclstp),hl
l1  ret
    endp

interp proc
       local l1,l2,l3,l4,l5,l6,l7
       push hl
       push af
       ld hl,vbtr
       ld (hl),1
       ld a,(cscnt)
       or a
       jp nz,l1

l3     ld hl,(pdata)
       ld a,(hl)
       or a
       jp nz,l2

       ld hl,(pldata)
l7     ld a,(hl)
       inc hl
       push hl
       ld h,(hl)
       ld l,a
       or h
       jp nz,l6

       pop hl
       ;ld hl,ldata  ;rewind
       dec hl        ;to the previous
       dec hl
       dec hl
       ld (pldata),hl
       jp l7

l6     ld (pdata),hl
       pop hl
       inc hl
       ld (pldata),hl
       jp l3

l2     push af
       inc hl
       inc hl
       ld a,(hl)
       or a
       jp p,l4

    xor a
    ld (IOBASE+PIC2),a
    inc hl
    jp l5
    
l4     dec hl
    ld a,8
    ld (IOBASE+PIC2),a
       ld a,$36
       ld (IOBASE+SOUNDM),a
       ld a,(hl)
       ld (IOBASE+SOUNDD),a
       inc hl
       ld a,(hl)
       inc hl
       ld (IOBASE+SOUNDD),a
l5     ld (pdata),hl
       pop af
l1     dec a
       ld (cscnt),a
       pop af
       pop hl
       endp
interx jp intera
intera jp 0
vbtr   db 0

iflash1 push af
       push hl
       ld hl,i3cnt
       ld a,(hl)
       inc a
       ld (hl),a
       and 15
       jp nz,i3l1

       push bc
i1m1   ld b,6
i1m2   ld hl,pal1+6
i1l2   ld a,(hl)
       ld (RGBASE2+LUT),a
       xor $80
       ;xor $10
       ld (hl),a
       inc hl
       dec b
       jp nz,i1l2

       pop bc
i1l1   pop hl
       pop af
       jp intera

iflash3 push af
       push hl
       ld hl,i3cnt
       ld a,(hl)
       inc a
       ld (hl),a
i3m1   and 31
       jp nz,i3l1

       inc hl
       ld a,(hl)
       ld (RGBASE2+LUT),a
       xor $80
       ld (hl),a
i3l1   pop hl
       pop af
       jp intera
i3cnt  db 0
       db $66  ;must be after i3cnt

scroll1 proc
    local l1,l3,l4,l6
    ld hl,text1w
    dec (hl)
    ret nz

    ld (hl),TEXTDELAY
    ld de,TXBASE+64*15-1
    ld c,15
l1  ld a,(de)
    ld hl,64
    add hl,de
    ld (hl),a
    ld hl,-64
    add hl,de
    ex de,hl
    dec c
    jp nz,l1

    ld a,(TXBASE)
    ld (TXBASE+63),a

    ld de,TXBASE+64
    ld c,15
l3  ld a,(de)
    ld hl,-64
    add hl,de
    ld (hl),a
    ld hl,64
    add hl,de
    ex de,hl
    dec c
    jp nz,l3

    ld de,TXBASE+64*15+1
    ld c,62
l4  ld a,(de)
    dec de
    ld (de),a
    inc de
    inc de
    dec c
    jp p,l4

    ld hl,(text1p)
    ld a,(hl)
    or a
    jp nz,l6

    ld hl,text1
    ld (text1p),hl
    ld a,(hl)
l6  ld (TXBASE+64*16-2),a
    inc hl
    ld (text1p),hl
    ret
    endp

scroll2 proc
    local l1,l3,l4
    call sdelay
    ld hl,512
    push hl
s2m1 ld hl,msg11
l4  ld a,(hl)
    or a
    jp z,l1
 
    inc hl
l2  ld (TXBASE+1022),a
    call sdelay
    ld de,TXBASE+2
    ld bc,TXBASE
l3  ld a,(de)
    ld (bc),a
    inc e
    inc de
    inc c
    inc bc
    ld a,d
    cp high(TXBASE+1024)
    jp nz,l3
    jp l4

l1  pop de
    dec de
    ld a,d
    or a
    ret m

    push de
    xor a
    jp l2
    endp

sdelay proc
    local l5
    ld a,6
    push hl
l5  push af
    call waiti
    pop af
    dec a
    jp nz,l5

    pop hl
    ret
    endp

getk call checkk
        or a
        jp z,getk
    ret

checkk ld c,6   ;direct console i/o
       ld e,0ffh
       jp BDOS

txtpal proc
    local l41,l42
    ld hl,intera
    ld (interx+1),hl
    call waiti
    ld hl,RGBASE2+LUT
    ld a,$10
    ld c,8
l41 ld (hl),a
    inc a
    dec c
    jp nz,l41

m1tp ld a,$68
    ld c,8
l42 ld (hl),a
    inc a
    dec c
    jp nz,l42
    ret
    endp

;main encoding
;174  **   175  ..   251  *.   252 .*   253 **
;     **        **        *.       .*       ..
cloud
    ld e,31     ;cls
    ld c,2
    call BDOS
    ld hl,TXBASE+2*64+5
    ld (hl),138   ;.*
                  ;.*
                  ;..
    inc l
    ld a,191      ;**
                  ;**
                  ;**
    ld (hl),a
    inc l
    ld (hl),a
    inc l
    ld (hl),a
    inc l
    ld (hl),a
    inc l
    ld (hl),148  ;..
                 ;*.
                 ;*.
    ld a,61
    add a,l
    ld l,a
    ld a,#83 ;131;**
                 ;..
                 ;..
    ld (hl),a
    inc l
    ld (hl),a
    inc l
    ld (hl),a
    ld a,-131
    add a,l
    ld l,a
    ld (hl),136  ;..
                 ;.*
                 ;..
    inc l
    ld (hl),188  ;..
                 ;**
                 ;**
    inc l
    ld (hl),176  ;..
                 ;..
                 ;**
    ret

setpal proc  ;de - table, c - #entries
    local l43
    call waiti
    ld hl,RGBASE2+LUT
l43 ld a,(de)
    ld (hl),a
    inc de
    dec c
    jp nz,l43
    ret
    endp

init proc
    local exit0
    ld hl,($f7d0)
    ld (intera+1),hl
    ld hl,interp
    ld ($f7d0),hl
  ;jp l77
    call fillall
    call txtpal
    ld de,msg1
    ld c,9
    call BDOS
    call loadpic
    jp m,exit0

    ld de,pal1
    ld c,6
    call setpal
    ld a,6
    ld (i1m1+1),a
    ld hl,pal1+6
    ld (i1m2+1),hl
    ld hl,iflash1
    ld (interx+1),hl
    call scroll2
    call voice2p
;l77
    call fillall
    ld a,$c8
    ld (m1tp+1),a
    call txtpal
    ld de,msg2
    ld c,9
    call BDOS
    xor a
    ld hl,fcb_drive+6
    inc (hl)
    ld hl,fcb_drive+12
    ld (hl),a
    ld hl,fcb_drive+15
    ld (hl),a
    ld hl,fcb_drive+32
    ld (hl),a
    ld hl,gcnp
    dec (hl)
    call loadpic
    jp m,exit0

    ld de,pal2
    ld c,4
    call setpal
    ld a,4
    ld (i1m1+1),a
    ld hl,pal2+4
    ld (i1m2+1),hl
    ld hl,iflash1
    ld (interx+1),hl
    ld hl,msg21
    ld (s2m1+1),hl
    call scroll2
;l77
    call fillall
    ld a,$68
    ld (m1tp+1),a
    call txtpal
    ld de,msg3
    ld c,9
    call BDOS
    xor a
    ld hl,fcb_drive+6
    inc (hl)
    ld hl,fcb_drive+12
    ld (hl),a
    ld hl,fcb_drive+15
    ld (hl),a
    ld hl,fcb_drive+32
    ld (hl),a
    ld hl,gcnp
    inc (hl)
    call loadpic
    jp m,exit0

    ld de,pal3
    ld c,16
    call setpal
    call cloud
    ld hl,iflash3
    ld (interx+1),hl
    xor a
exit0
    ret
    endp

voice2p proc
    local l2,l3,l5
    ld a,$20
;    ld a,$36
    di
    ld (IOBASE+SOUNDM),a
    ld a,1
    ;ld a,25
    ld (IOBASE+SOUNDD),a
    ;xor a
    ;ld (IOBASE+SOUNDD),a
    call vdelayl

    ld hl,voice2
l2  ld b,8
    ld c,(hl)
l3  ld a,c
    ld d,8
    rrca
    jp nc,$+5
    ld d,0
    ld c,a
    ld a,d
    ld (IOBASE+PIC2),a
    call vdelay
    dec b
    jp nz,l5

    inc hl
    ld a,low(endvoice2)
    cp l
    jp nz,l2

    ld a,high(endvoice2)
    cp h
    jp nz,l2

    call vdelayl
    ei
    ret

l5  ld a,(0)
    jp l3
    endp

extra proc
    local l2,l3,l5,exit0
    call fillall
    call txtpal
    ld de,msg4
    ld c,9
    call BDOS
    xor a
    ld hl,fcb_drive+6
    inc (hl)
    ld hl,fcb_drive+12
    ld (hl),a
    ld hl,fcb_drive+15
    ld (hl),a
    ld hl,fcb_drive+32
    ld (hl),a
    ld hl,pause5
    ld (pdata),hl
    call loadpic
    jp m,exit0

    ld e,31     ;cls
    ld c,2
    call BDOS
    ld de,pal4
    ld c,8
    call setpal
    ld a,$45
    ld (vm1+1),a
    ld a,$20
;    ld a,$36
  di
    ld (IOBASE+SOUNDM),a
    ld a,1
    ;ld a,25
    ld (IOBASE+SOUNDD),a
    ;xor a
    ;ld (IOBASE+SOUNDD),a
    call vdelayl

    ld hl,voice1
l2  ld b,8    ;7
    ld c,(hl) ;7
l3  ld a,c  ;5    
    ld d,8  ;7
    rrca    ;4
    jp nc,$+5 ;10
    ld d,0    ;7
    ld c,a    ;5
    ld a,d    ;5
    ld (IOBASE+PIC2),a ;13   ;average 269 ticks, approx 9300 Hz
    call vdelay    ;17
    dec b          ;5
    jp nz,l5       ;10

    inc hl              ;5
    ld a,low(endvoice1) ;13
    cp l                ;4
    jp nz,l2            ;10

    ld a,high(endvoice1) ;13
    cp h                 ;4
    jp nz,l2             ;10
exit0
    call vdelayl
    call vdelayl
    call vdelayl
    ei
    ret

l5  ld a,(0)      ;13
    jp l3         ;10
    endp

vdelay proc   ;160 ticks, 15625 Hz
      local l1,l2,l3,dd
      ld e,2    ;7
l3    push af   ;11
      pop af    ;10
      dec e     ;5
      jp nz,l3  ;10

      ld a,(dd) ;13
      inc a     ;5
      ld (dd),a ;13
      jp nz,l1  ;10

vm1    ld a,$43     ;$45   ;7
       ld (RGBASE2+LUT),a  ;13
       xor $80             ;4
       ld (vm1+1),a        ;13
l2    ret                  ;10
l1    call l2              ;17
      jp l2                ;10
dd db 0
      endp

vdelayl proc   ;(53*256 + 40)*10 + 17 = 136097 ticks, .0544388 sec
    local l1,l2
    ld a,10     ;7
l2  push af     ;11
    xor a       ;4
l1  push af     ;11
    call vdelay ;17
    pop af      ;10
    dec a       ;5
    jp nz,l1    ;10
    
    pop af      ;10
    dec a       ;5
    jp nz,l2    ;10
    ret         ;10
    endp

final proc
    ld hl,(intera+1)
    ld ($f7d0),hl
    ld a,$20
    ld (IOBASE+SOUNDM),a
    ld a,1
    ld (IOBASE+SOUNDD),a
    ld e,31     ;cls
    ld c,2
    jp BDOS
    endp

fcb_drive db 0
fcb_fn    db "CORVD1  PIC"
fcb_ex    db 0
fcb_s1    db 0
fcb_s2    db 0
fcb_rc    db 0
fcb_al    db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
fcb_cr    db 0
fcb_rn    db 0,0,0

if ENGLISH
text1 db "News! News! News! The Corvette didn't sink! He's afloat! Perhaps this is the last demo for the Corvette. But while our Corvette is still sailing. Unfortunately, the physicists-constructors abandoned their project by 1989, which quickly faded into the shadows without their support. This demo shows some of the Corvette's graphic capabilities: 512x256 pixels and 16 colors on the screen, 8-color sprites, changing palettes, fast multi-color text. Such graphics cannot be mastered by almost any other computer of the 80s. At that time, only Amiga, Archimedes and EGA graphics could do this. Hello everyone from 2023!      ",0
else
text1 db "Hoвocть! Hoвocть! Hoвocть! Kopвeт нe yтoнyл! Oн нa плaвy! Boзмoжнo, этo и пocлeдняя дeмкa для Kopвeтa. Ho пoкa нaш Kopвeт eщё плывёт. K coжaлeнию, физики-кoнстpyктopы зaбpocили cвoй пpoeкт к 1989, кoтopый бeз иx пoддepжки быcтpo yшёл в тeнь. Этa дeмкa пoкaзывaeт нeкoтopыe гpaфичecкиe вoзмoжнocти Kopвeтa: 512x256 пикceлoв и 16 цвeтoв нa экpaнe, 8-цвeтныe cпpaйты, cмeнy пaлитp, быcтpый мнoгoцвeтный тeкcт. Пoдoбнyю графикy нeвoзмoжнo осилить пpaктичecки никaкoмy дpyгoмy кoмпьютepy 80-x. Тaкoe тoгдa былo пoд cилy тoлькo Aмигe, Аpxимeдy и EGA-гpaфикe. Bceм пpивeт из 2023!      ",0
endif
text1p dw text1
text1w db TEXTDELAY

msg0 db 10,13,"$"
msg1 db 31            ;cls
     db $1b,"0"       ;the main charset
     db $1b,";"       ;curoff
     db $1b,"3"
if ENGLISH
     db "The Corvette computer has a unique architecture. It was created by young physicists from Moscow State University by 1985. They tried to combine the features of the TRS-80 and MSX computers, but in the end they created an absolutely unlike anything else computer. 512x256 graphics with 16 colors and hardware acceleration elements were close to the level of expensive professional equipment. The characteristics were somewhat spoiled only by an outdated processor, which, however, corresponded in performance to $"
msg11 db "the processors of the popular computers: the Tandy TRS-80 models I and III, Apple II, Commmodore 64/128. At first everything went very well. The Corvette was planned to be produced at many factories and in large quantities since 1987.",0
else
     db "Koмпьютep Kopвeт имeeт yникaльнyю apxитeктypy. Егo coздaли мoлoдыe физики из MГУ к 1985. Oни пытaлиcь coвмecтить ocoбeннocти кoмпьютepoв TRS-80 и MSX, нo в итoгe coздaли aбcoлютнo ни нa чтo нe пoxoжий кoмпьютep. Гpaфикa 512x256 c 16 цвeтaми и элeмeнтaми aппapaтнoгo ycкopeния былa близкa ypoвню дopoгoй пpoфeccиoнaльнoй тexники. Xapaктepиcтики нecкoлькo пopтил тoлькo cлaбoвaтый пpoцeccop, кoтopый, oднaкo, cooтвeтcтвoвaл пo пpoизвoдитeльнocти пpoцeccopaм пoпyляpныx кoмпьютepoв Tandy TRS-80 мoдeлeй I и III, Ap$"
msg11 db "ple II, Commmodore 64/128. Пoнaчaлy вcё шло oчeнь xopoшo. Kopвeт намeчaлось пpoизвoдить нa мнoгиx зaвoдах и в бoльшиx кoличecтвax c 1987.",0
endif

msg2 db 31
if ENGLISH
     db "Since 1988, disturbing publications began to appear about the fate of the computer. Something was going wrong - the Corvette was really sinking. There were several reasons for this. The main problem was the electronics industry's unpreparedness for mass production. This problem was seriously aggravated by the aggressive forceful pushing of a much more expensive UKNC computer into the place of the main school computer, despite the fact that the UKNC had serious architectural flaws and was extremely unreliab$"
msg21 db "le. The conflict in the Caucasus also added to the problems, which made it impossible to produce Corvettes at a large factory in Baku. And then there was a temporary departure of the chief designers of the Corvette to the United States and their loss of interest in their invention...",0
else
     db "C 1988 нaчaли пoявлятьcя тpeвoжныe пyбликaции пo пoвoдy cyдьбы кoмпьютepa. Чтo-тo шлo нe тaк - Kopвeт peaльнo тoнyл. У этoгo былo нecкoлькo пpичин. Глaвнaя пpoблeмa былa в нeгoтoвнocти элeктpoннoй пpoмышлeннocти к мaccoвoмy пpoизвoдcтвy. Этa пpoблeмa cepьёзнo ycyгyблялacь aгpeccивным cилoвым пpoдaвливaниeм нa мecтo глaвнoгo шкoльнoгo кoмпьютepa cyщecтвeннo бoлee дopoгoгo кoмпьютepa УKHЦ, нecмoтpя нa тo, чтo УKHЦ имeл cepьёзныe apxитeктypныe изъяны и был кpaйнe нeнaдёжeн. K пpoблeмaм eщё пpибaвилcя кoнфликт$"
msg21 db  " нa Kaвкaзe, кoтopый cдeлaл нeвoзмoжным пpoизвoдcтвo Kopвeтoв нa кpyпнoм зaвoдe в Бaкy. A зaтeм cлyчилиcь вpeмeнный oтъeзд глaвныx кoнcтpyктopoв Kopвeтa в CШA и yтpaтa ими интepeca к cвoeмy изoбpeтению...",0
endif

msg3 db 31
     db $1b,"2"
if ENGLISH
     db 1,38,58  ;gotoxy
     db "This is demo"
else
     db 1,38,59  ;gotoxy
     db "Этo дeмкa"
endif
     db $1b,"6"       ;rvs on
if ENGLISH
     db 1,39,44
     db " * And the Corvette hasn't sunk yet! * "
else
     db 1,39,49
     db " * А Кopвет eщё нe yтoнyл! * "
endif
     db $1b,"7"       ;rvs off
     db 1,40,56
     db "(C) 2023 Litwr"
if ENGLISH
     db 1,42,48
     db "Waiting for the picture to load$"
else
     db 1,42,52
     db "Ждём зaгрyзки кapтинки$"
endif

msg4 db 31
     db 1,39,55
if ENGLISH
     db "Encore picture$"
else
     db "Pиcyнoк нa биc$"
endif

pldata dw ldata+2
ldata dw pause5,data1,pause5,data1,pause5,pause1,pause1,pause1,pause1,data1,pause5,pause1,data2,pause1,pause5,pause1,pause1,data2,pause5,pause5,pause5,pause5,pause5,data3,0
pdata dw pause5
cscnt db 0
data1
     include music/icicle-music1.inc
     db 0
data2
     include music/icicle-music2.inc
     db 0
data3
     include music/exorcist-music.inc
     db 0

pause1 db 50
       dw -1
       db 0
pause5 db 250
       dw -1
       db 0

voice1
    include voice/rg1.inc
endvoice1

voice2
    include voice/vbpm.inc
endvoice2


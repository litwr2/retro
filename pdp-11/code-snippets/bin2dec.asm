PR00000:    ;prints r2, used: r0,r2,r3
        mov #10000.,r3
    CALL @#PRZ
PR0000:
        mov #1000.,r3
    CALL @#PRZ
PR000:
        mov #100.,r3
    CALL @#PRZ
PR00:
        mov #10.,r3
    CALL @#PRZ
PR0:
    mov r2,r0
PR:	add #48.,r0
    .ttyout
        return

PRZ:	mov #65535.,r0
4$:	inc r0
    cmp r2,r3
    bcs PR

    sub r3,r2
    br 4$

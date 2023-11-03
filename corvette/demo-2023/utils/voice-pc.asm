;for assembler FASM
;plays a sound sample in the INC-format
;for IBM PC DOS, DOSBOX is also good for this

    org 100h
.l0:  cli
    in al,61h
    and al,0feh
    out 61h,al
    mov dl,al
    mov al,$30
    out 43h,al
    xor al,al
    out 42h,al
    out 42h,al
    call delay
    mov si,data1
.l2:  mov ch,8
    mov cl,[si]
.l1:  and dl,0fdh
    shr cl,1
    jnc $+5
    or dl,2
    mov al,dl
    out 61h,al
    call delay
    dec ch
    jnz .l1

    inc si
    cmp si,dataend
    jnz .l2
    sti

    mov ax,4000
.l7:  push ax
    call delay
    pop ax
    dec ax
    jne .l7

    mov ah,1
    int 16h
    jz .l0
    int 20h

delay:  mov al,0
      out 43h,al
      in al,40h
      mov ah,al
      in al,40h
      xchg al,ah
      mov bx,ax
.l1:  mov al,0
      out 43h,al
      in al,40h
      mov ah,al
      in al,40h
      xchg al,ah
      mov di,bx
      sub di,ax
      cmp di,149  ;1193182/149 approx= 8008 Hz
;      cmp di,75   ;1193182/75 approx= 15909 Hz
      jc .l1
      retn

data1:
      include 'vbpm.inc'
dataend:


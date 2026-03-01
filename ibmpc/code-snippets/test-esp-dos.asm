;for fasm assembler
        use16
        org 100h

macro outchar {  ;prints AL
        mov dl,al
        mov ah,2
        int 21h
}
macro outeax {
         push eax
         rol eax,16
         call hexax
         pop eax
         call hexax
         mov al,10  ;nl
         outchar
}
start:   mov eax,esp
         outeax
         mov ebx,esp  ;saves esp
         pushad
         mov eax,esp
         outeax
         mov dword [esp+12],0x77777777  ;saved esp is changed
         db 67h
         popad
         mov eax,esp
         mov esp,ebx  ;restore esp
         add edi,9
         outeax

	 int    0x20   ;finish

hexax:   ;prints ax, uses cl,dl,ax
        push ax
        mov al,ah
        call hexal
        pop ax
hexal:   ;prints al, uses cl,dl,ax
        push ax
        mov cl,4
        shr al,cl
        call hex
        pop ax
        and al,0fh
hex:    add al,'0'
        cmp al,'9'
        jbe .l1

        add al,'A'-'0'-10
.l1:    outchar
        retn

    align 4
wb  rb 37


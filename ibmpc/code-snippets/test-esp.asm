;for fasm assembler
format ELF executable 3
segment readable executable

macro outesp {
         mov eax,esp
         push eax
         rol eax,16
         call hexax
         pop eax
         call hexax
         mov al,10
         stosb
}
entry $
         mov edi,wb  ;the text buffer
         outesp
         pushad
         outesp
         db 67h
         popad
         add edi,9
         outesp
	     mov	edx,3*9     ;length
         mov	ecx,wb
         mov	ebx,1		;STDOUT
         mov	eax,4		;sys_write
	 int     0x80

     xor	ebx,ebx 	;exit code 0
	 mov	eax,1		;sys_exit
	 int    0x80

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
.l1:    stosb
        retn

segment readable writeable
    align 4
wb  rb 28


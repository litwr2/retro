;for fasm assembler
        ORG	0x7c00
        USE16

macro outchar {  ;prints AL
        stos byte [edi]
        inc di
}
macro outeax {
         push eax
         rol eax,16
         call hexax
         pop eax
         call hexax
         add edi,144  ;nl
}
start:
         cld
         cli				;disable interrupts
         in al, 0x92         ;enable A20-line
         or al, 2
         out 0x92, al

        lgdt    [cs:FlatRM_GDTR]
        mov eax, cr0               ;switch to the protected mode
        or al, 1
        mov cr0, eax
        jmp $+2                    ;fix the old CPU

        mov bx, 8                  ;the 1st selector in GTR
        mov ds, bx
        mov es, bx
        mov ss, bx
        ;mov fs, bx
        ;mov gs, bx
        and al, 0xfe               ;return back to the real mode
        mov cr0, eax
        jmp 0:to_unreal            ;fix the CPU

to_unreal:
         mov esp,0x8000
         mov edi,0xb8000    ;the screen base
         mov eax,esp
         outeax
         mov ebx,esp  ;saves esp
         pushad
         mov dword [0x8000-0x20],77777777h
         mov eax,esp
         outeax

         mov [esp],edi  ;fixes edi
         mov dword [esp+12],0x77777777  ;saved esp is changed
         popad
         mov eax,esp
         mov esp,ebx  ;restore esp
         outeax
       jmp $

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

FlatRM_GDTR: 
         dw GDT_len - 1
         dd FlatRM_GDTR
         dw 0

;Data Selector Descriptor 
         dw 0xFFFF      ;limit 0..15
         dw 0           ;base 0..15
         db 0           ;base 16..23
         db 10010010b   ;PRESENCE=1,PL=00,SYS=1,EXEC=0,0,RW=1,ACCESS=0
         db 0x80 or 0xf ;G=1, D=0 (USE16), limit 16..19
         db 0           ;base 24..31
GDT_len = $ - FlatRM_GDTR 


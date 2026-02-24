macro outchar {  ;prints AL
        mov dl,al
        mov ah,2
        int 21h
}

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

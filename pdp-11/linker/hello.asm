         .radix 10
         .dsabl gbl

         .asect
         .=512

start:   mov #6,r1
         mov #16,r2
         emt ^O24
         mov #msg,r1
         mov #30,r2
         emt ^O20
         emt 6
         halt

msg:     .byte 155,146
         .ascii "HELLO THE PDP-11/BK WORLD!"
         .byte 10,0
         .end


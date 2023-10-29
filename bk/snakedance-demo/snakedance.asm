            .radix 10
            .dsabl gbl
            .asect
            .=512

kbddtport  = ^O177662            ;kbd data, palette, timer, $ffb2

         .macro push arg
         mov arg,-(sp)
         .endm

         .macro pop arg
         mov (sp)+,arg
         .endm

START:  ;R5 is free
     CALL @#INIT
     MOV #8192,R0
     MOV R0,R1
     ASL R1
     CLR R2
2$:  MOV R2,(R1)+
     SOB R0,2$
    MOV @#HEADX,R1
    MOV @#HEADY,R2
    CALL @#POINT
    ;MOV @#HEADP,R3
    ;MOV @#TAILP,R4
    MOV #PATH,R3
    MOV R3,R4
        .REPT 6
    CALL @#GROW
        .ENDR
1$: CALL @#GROW
    CALL @#SHRINK
    ADD #64,@#CNT
    BNE 1$

    CALL @#GROW
    INC @#LEN
    MOV @#LEN,R0
    CALL @#hexout
    CALL @#msgout
    CMPB @#^O177717,#^O200
    BEQ 8$  ;BK0010

    CALL @#kbdproc
    CALL @#palchg
8$: CMP #1024,@#LEN
    BNE 1$

3$: CALL @#GROW
    CALL @#SHRINK
    ADD #64,@#CNT
    BNE 3$

    CALL @#SHRINK
    DEC @#LEN
    MOV @#LEN,R0
    CALL @#hexout
    CALL @#msgout
    CMPB @#^O177717,#^O200
    BEQ 7$   ;BK0010

    CALL @#kbdproc
    CALL @#palchg
7$: CMP #7,@#LEN
    BNE 3$
    BR 1$
    RETURN

SHRINK:
    MOV @#TAILX,R1
    MOV @#TAILY,R2
    CALL @#CLEAR
    MOVB (R4)+,R1
    ADD ATBX(R1),@#TAILX
    ADD ATBY(R1),@#TAILY
    CMP #PATHE,R4
    BNE 3$

    MOV #PATH,R4
3$: RETURN

GROW:
    MOVB (R3)+,R1
    ADD ATBX(R1),@#HEADX
    ADD ATBY(R1),@#HEADY
    CMP #PATHE,R3
    BNE 3$

    MOV #PATH,R3
3$: MOV @#HEADX,R1
    MOV @#HEADY,R2  
    ;a call to POINT

POINT:	;R1,R2 - X,Y; R0 - temp;  Y*64+X/4
    MOV R1,R0
    ASR R1
    ASR R1
    ASL R2
    ADD TAB2(R2),R1
	BISB TAB1(R0),(R1)
    RETURN

CLEAR:	;R1,R2 - X,Y; R0 - temp;  Y*64+X/4
    MOV R1,R0
    ASR R1
    ASR R1
    ASL R2
    ADD TAB2(R2),R1
	BICB TAB1(R0),(R1)
    RETURN

INIT:
    clr r1
    mov #154,r0
    emt ^O16   ;cursor off

    mov #155,r0
    emt ^O16   ;32 cols

    mov #146,r0
    emt ^O16   ;green

    mov #158,r0
    emt ^O16

    mov #keyirq,@#^O60
    RETURN

MSGOUT:
    ADD #4096,@#CNT2
    BNE 1$

    MOV @#PMSG,R2
    CLR R1
2$: MOVB (R2)+,R0
    EMT ^O22
    INC R1
    CMP #32,R1
    BNE 2$

    CMP #MSGE,R2
    BNE 3$

    MOV #MSGS,R2
3$: MOV R2,@#PMSG
1$: RETURN

kbdproc:
    MOV @#kbdbuf,R0
    BEQ 1$

    CLR @#kbdbuf
    CMPB R0,#'0
    BCS 1$

    CMPB R0,#'9+1
    BCC 2$

    SUB #'0,R0
4$: CLR @#AUTOPAL
    swab r0
    asl r0
    bis #16384,r0
    mov r0,@#kbddtport
    RETURN

2$: CMPB r0,#'A
    BCS 1$

    CMPB r0,#'F+1
    BCC 3$

    SUB #'A-10,R0
    BR 4$

3$: CMPB r0,#'a
    BCS 1$

    CMPB r0,#'f+1
    BCC 5$

    SUB #'a-10,R0
    BR 4$

5$: CMPB r0,#'Z
    BNE 6$

7$: MOV #1,R0
    XOR R0,@#AUTOPAL
    RETURN

6$: CMPB r0,#'z
    BEQ 7$
1$: RETURN

palchg:
    TST @#AUTOPAL
    BEQ 1$

    inc @#palette
    bic #240,@#palette
    mov @#palette,r0
    swab r0
    asl r0
    bis #16384,r0
    mov r0,@#kbddtport
1$: RETURN

keyirq:    mov @#kbddtport,@#kbdbuf
           rti

;HEADP: .WORD PATH
;TAILP: .WORD PATH
HEADX: .WORD 47
HEADY: .WORD 127
TAILX: .WORD 47
TAILY: .WORD 127
AUTOPAL: .WORD 0
palette: .WORD 0
kbdbuf: .WORD 0

CNT:  .WORD 0
CNT2: .WORD 0
PMSG: .WORD MSGS
LEN:  .WORD 7
ATBX: .WORD 0,0,-1,1
ATBY: .WORD -1,1,0,0

digifont:   ;8th columns are free
      .word   672,2056,2568, 2184,2088,2056,  672, 0  ;0
      .word   128, 160, 128,  128, 128, 128,  672, 0  ;1
      .word   672,2056, 512,  128,  32,   8, 2720, 0
      .word  2720,2048, 512,  672,2048,2056,  672, 0  ;3
      .word   512, 640, 544,  520,2720, 512,  512, 0
      .word  2720,   8, 680, 2048,2048,2056,  672, 0
      .word   640,  32,   8,  680,2056,2056,  672, 0  ;6
      .word  2720,2048, 512,  128,  32,  32,   32, 0  ;7
      .word   672,2056,2056,  672,2056,2056,  672, 0
      .word   672,2056,2056, 2720,2048, 512,  160, 0  ;9
      .word   640,2080,8200,10920,8200,8200, 8200, 0  ;A
      .word  2728,8200,8200, 2728,8200,8200, 2728, 0  ;B
      .word  2720,8200,   8,    8,   8,8200, 2720, 0  ;C
      .word   680,2056,8200, 8200,8200,2056,  680, 0  ;D
      .word 10920,   8,   8,  680,   8,   8,10920, 0  ;E
      .word 10920,   8,   8,  680,   8,   8,    8, 0  ;F

hexout:   ;prints R0
        xor r1,r1
        push r0
        swab r0
        call @#hex0
        pop r0
hexlow:
        push r0
        bic #65295,r0  ;$ff0f
        call @#digiout
        pop r0
hex0:
        bic #65520,r0    ;$fff0
        asl r0
        asl r0
        asl r0
        asl r0
        ;jmp @#digiout

digiout:
         add #32768-454,r1
         add #digifont,r0
         mov (r0)+,@r1
         mov (r0)+,64(r1)
         mov (r0)+,128(r1)
         mov (r0)+,192(r1)
         mov (r0)+,256(r1)
         mov (r0)+,320(r1)
         mov @r0,384(r1)
         sub #32768-456,r1
         return

TAB1:
    ;.REPT 64
    ;.BYTE 3,12,48,192
    ;.ENDR
    ;.INCLUDE tab1r.s
    .INCLUDE tab1n.s
TAB2: 
    .WORD 16384,16448,16512,16576,16640,16704,16768,16832
	.WORD 16896,16960,17024,17088,17152,17216,17280,17344
	.WORD 17408,17472,17536,17600,17664,17728,17792,17856
	.WORD 17920,17984,18048,18112,18176,18240,18304,18368
	.WORD 18432,18496,18560,18624,18688,18752,18816,18880
	.WORD 18944,19008,19072,19136,19200,19264,19328,19392
	.WORD 19456,19520,19584,19648,19712,19776,19840,19904
	.WORD 19968,20032,20096,20160,20224,20288,20352,20416
	.WORD 20480,20544,20608,20672,20736,20800,20864,20928
	.WORD 20992,21056,21120,21184,21248,21312,21376,21440
	.WORD 21504,21568,21632,21696,21760,21824,21888,21952
	.WORD 22016,22080,22144,22208,22272,22336,22400,22464
	.WORD 22528,22592,22656,22720,22784,22848,22912,22976
	.WORD 23040,23104,23168,23232,23296,23360,23424,23488
	.WORD 23552,23616,23680,23744,23808,23872,23936,24000
	.WORD 24064,24128,24192,24256,24320,24384,24448,24512
	.WORD 24576,24640,24704,24768,24832,24896,24960,25024
	.WORD 25088,25152,25216,25280,25344,25408,25472,25536
	.WORD 25600,25664,25728,25792,25856,25920,25984,26048
	.WORD 26112,26176,26240,26304,26368,26432,26496,26560
	.WORD 26624,26688,26752,26816,26880,26944,27008,27072
	.WORD 27136,27200,27264,27328,27392,27456,27520,27584
	.WORD 27648,27712,27776,27840,27904,27968,28032,28096
	.WORD 28160,28224,28288,28352,28416,28480,28544,28608
	.WORD 28672,28736,28800,28864,28928,28992,29056,29120
	.WORD 29184,29248,29312,29376,29440,29504,29568,29632
	.WORD 29696,29760,29824,29888,29952,30016,30080,30144
	.WORD 30208,30272,30336,30400,30464,30528,30592,30656
	.WORD 30720,30784,30848,30912,30976,31040,31104,31168
	.WORD 31232,31296,31360,31424,31488,31552,31616,31680
	.WORD 31744,31808,31872,31936,32000,32064,32128,32192
	.WORD 32256,32320,32384,32448,32512,32576,32640,32704
PATH:
;    .BYTE 2,2,2,2,1,1,1,1,3,3,3,3,0,0,0,0
     .INCLUDE img.s
     .BYTE 4  ;a correction
PATHE:
MSGS:
    .INCLUDE snake-msg.s
MSGE:


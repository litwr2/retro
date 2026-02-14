MACRO   ALIGN VALUE     ;required by FASM for use ALIGN directive
{
        RB (VALUE-1)-($+VALUE-1) MOD VALUE
}

PSP_ENVIRN_SEG  EQU     2CH
PSP_PARENT_SEG  EQU     16H     ;UNDOCUMENTED?!

                ORG     100H
START:          JMP     MAIN

                RB      8       ;267(TSR LENGTH)-256(PSP)-3(JMP INSR LENGTH)

                ALIGN   16

MCB2            RB      16
PSP2            RB      256

TSR_CODE:       ;TSR BODY, let its size to be 267 bytes
                RB      267     ;FILL TO TSR'S SIZE, 256(PSP)+11=267

MAIN:           MOV     ES,[DS:PSP_ENVIRN_SEG] ;free environment memory for prg
                MOV     AH,49H          ;DOS Services  ah=function 49h
                INT     21H             ; reLEAse memory block, ES=seg
                JC      FINISH

                MOV     AH,4AH          ;SHRINK MEMORY ALLOCATED FOR THE PRG
                MOV     BX,CS           ;this creates MCB at MCB2
                MOV     ES,BX
                MOV     BX,MCB2/16      ;17 PARAGRAPHS = 17*16 = 272 bytes
                INT     21H     ;MCB1 size set to 267(TSR code)+5(16 bit align)
                JC      FINISH  ;(MCB2 label is end of TSR)

                MOV     AH,26H          ;creates new PSP at PSP2
                MOV     DX,CS
                MOV     BX,PSP2
                MOV     CL,4
                SHR     BX,CL
                ADD     DX,BX
                INT     21H

                MOV     BX,DX           ;set new PSP as current
                MOV     AH,50H
                INT     21H

                MOV     WORD [DS:MCB2+1],DX  ;adjust MCB2's owner field

;                MOV     AX,[DS:PSP_PARENT_SEG]  ;adjust PSP's parent field
;                MOV     WORD [PSP2+PSP_PARENT_SEG],AX ;this isn't required
                                                ;by MS-DOS
                CALL    MOVE2PSP

FINISH:         MOV     AX,4C00H        ;TERMINATE PRG
                INT     21H

MOVE2PSP:       MOV     AX,DS
                MOV     ES,AX
                MOV     SI,TSR_CODE
                XOR     DI,DI
                MOV     CX,MAIN
                SUB     CX,SI
                REP     MOVSB           ; Rep when cx >0 mov [si] to es:[di]
		RETN
                

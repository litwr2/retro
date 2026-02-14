                ORG     100H
START:          PUSH    DS              ;SET RETURN TO DOS ADDRESS
                SUB     AX,AX
                PUSH    AX

                MOV     AH,9            ;msg about Esc key for exit
                MOV     DX,INF
                INT     21H

                CALL    SET_INTR9
                CALL    SET_INTR8

                MOV     AX,0B800H       ;VIDEO SEGMENT
                MOV     ES,AX

                XOR     EBX,EBX
.L1:            MOV     AL,[MSG+BX]
                MOV     [ES:EBX*2],AL
                INC     BX
                CMP     BX,15H
                JNZ     .L1

MLOOP:          CALL    SHOW_REGS
                CMP     [CS:ENDFLAG],0
                JE      MLOOP

                CALL    RESTORE_INTR8
                CALL    RESTORE_INTR9
                RETF

                INCLUDE 'IRQ1X.ASM'
                INCLUDE '..\IRQ0.ASM'

ENDFLAG         DB      0
MSG             DB      'IMR=00 ISR=00 IRR=00 '
INF             DB      'PRESS ESC TO EXIT',0DH,0AH,'$'

SHOW_AL:        MOV     AH,AL
                AND     AX,0FF0H
                SHR     AL,4
                XOR     AX,3030H
                CMP     AL,39H
                JBE     .L1
                ADD     AL,7
.L1:            CMP     AH,39H
                JBE     .L2
                ADD     AH,7
.L2:            MOV     [ES:BX+2],AH
                MOV     [ES:BX],AL
                RETN

SHOW_REGS:      PUSH    ES
                PUSH    BX

                MOV     AX,0B800H
                MOV     ES,AX

                IN      AL,21H          ;READ IMR
                MOV     BX,8
                CALL    SHOW_AL

                MOV     AL,0BH          ;READ ISR
                OUT     20H,AL
                IN      AL,20H
                MOV     BL,22
                CALL    SHOW_AL

                MOV     AL,0AH          ;READ IRR
                OUT     20H,AL
                IN      AL,20H
                MOV     BL,36
                CALL    SHOW_AL

                POP     BX
                POP     ES
                RETN


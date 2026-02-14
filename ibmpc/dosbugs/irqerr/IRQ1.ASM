RESTORE_INTR9:  MOV     DX,[CS:SAVE9LO] ;RESTORE INTR9 VECTOR
                PUSH    DS
                MOV     DS,[CS:SAVE9HI]
                JMP     SET_INTR9.L1

SET_INTR9:      MOV     AX,3509H        ;SAVE/SET INTR9 VECTOR
                INT     21H
                PUSH    DS
                PUSH    CS
                POP     DS
                MOV     [CS:SAVE9LO],BX
                MOV     [CS:SAVE9HI],ES
                MOV     DX,INTR9
.L1:            MOV     AX,2509H
                INT     21H
                POP     DS
                RETN

INTR9:          PUSH    AX
                PUSH    DS
                IN      AL,60H

                PUSH    0B800H  ;SHOWS PRESSED KEY SCANCODE THE IN UPPER
                POP     DS      ;LEFT CORNER
                MOV     [DS:0],AL

                CMP     AL,81H  ;ESC KEY RELEASED?
                JNZ     .L1

                INC     [CS:ENDFLAG]

.L1:            POP     DS
                POP     AX
                DB      0EAH    ;CALL FAR
SAVE9LO         DW      ?
SAVE9HI         DW      ?



TIMERV          EQU     20H             ;1193180Hz/TIMERV=FREQ OF INTR8=37.3kHz

SET_INTR8:      MOV     AX,3508H        ;SAVE/SET INTR8 VECTOR
                INT     21H
                PUSH    DS
                PUSH    CS
                POP     DS
                MOV     [SA8LO],BX
                MOV     [SA8HI],ES
                MOV     DX,INTR8
                MOV     AX,2508H
                INT     21H
                POP     DS

                CLI
                MOV     AL,36H          ;SET TIMER HARDWARE
                OUT     43H,AL
                MOV     AL,TIMERV
                OUT     40H,AL
                XOR     AL,AL
                OUT     40H,AL
                STI
                RETN

RESTORE_INTR8:  MOV     DX,[CS:SA8LO]   ;RESTORE INTR8 VECTOR
                PUSH    DS
                MOV     DS,[CS:SA8HI]
                MOV     AX,2508H
                INT     21H
                POP     DS

                CLI
                MOV     AL,36H          ;RESTORE TIMER HARDWARE
                OUT     43H,AL
                XOR     AL,AL
                OUT     40H,AL
                OUT     40H,AL
                STI
                RETN

INTR8:          PUSH    AX

                INC     [CS:INTR8COUNT]
                CMP     [CS:INTR8COUNT],65536/TIMERV
                JA      .L1

                MOV     AL,20H
                OUT     20H,AL

                POP     AX
                IRET

.L1:            XOR     AX,AX   ;STANDARD TIMER INTERRUPT FOR SYSTEM?
                MOV     [CS:INTR8COUNT],AX
                POP     AX
                DB      0EAH    ;FAR CALL
SA8LO           DW      0
SA8HI           DW      0


INTR8COUNT      DW      0


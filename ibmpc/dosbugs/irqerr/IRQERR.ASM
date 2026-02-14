                ORG     100H
START:          PUSH    DS              ;SET RETURN TO DOS ADDRESS
                SUB     AX,AX
                PUSH    AX

                CALL    SET_INTR9
                CALL    SET_INTR8

MLOOP:          CMP     [CS:ENDFLAG],0
                JE      MLOOP

                
                CALL    RESTORE_INTR8
                CALL    RESTORE_INTR9
                RETF

                INCLUDE 'IRQ1.ASM'
                INCLUDE 'IRQ0.ASM'

ENDFLAG         DB      0


                PAGE    255,132

                INCLUDE CONST.MAC

                .486
SEG_DATA        SEGMENT PARA PUBLIC USE16
                ASSUME  DS:SEG_DATA
                INCLUDE DOS.DAT
                INCLUDE MDAC.DAT
                INCLUDE ROMFN.DAT
                INCLUDE 8501.DAT
                INCLUDE CDS.DAT
                INCLUDE DEBUGGER.DAT
                INCLUDE KBD.DAT
                INCLUDE JOY.DAT
                INCLUDE IO.DAT
                INCLUDE TED.DAT
                INCLUDE MENUS0.DAT
                INCLUDE MENUS1.DAT
                INCLUDE MENUS2.DAT
                INCLUDE MENUS3.DAT
                INCLUDE SOUND.DAT
SEG_DATA        ENDS

                INCLUDE HARDWARE.MAC
                INCLUDE 8501.MAC

SEG_CODE        SEGMENT PARA PUBLIC USE16
                ASSUME  CS:SEG_CODE
                ORG     0
START:          PUSH    DS              ;SET RETURN TO DOS ADDRESS
                SUB     AX,AX
                PUSH    AX
                MOV     AX,SEG SEG_DATA ;INIT DS
                MOV     DS,AX
                MOV     RESET_SP,SP

                CALL    INITIBM

RESET:          MOV     SP,RESET_SP
                CALL    XRESET
MAIN_ENTRY:     MOV     MAINJUMP,OFFSET MAINLOOP

MAINLOOP:       CALL    TED
                CALL    CPU8501
                JMP     [MAINJUMP]

END_EMU:        MOV     SP,RESET_SP
                CALL    FINISHIBM
                RETF

                INCLUDE TIMER.COD
                INCLUDE KBD.COD
                INCLUDE JOY.COD
                INCLUDE TED.COD
                INCLUDE 8501.COD
                INCLUDE CPU_IO.COD
                INCLUDE CDS.COD
                INCLUDE CSB.COD
;                INCLUDE ACIA.INC
;                INCLUDE C1551.INC
;                INCLUDE CSB_FDD.INC
;                INCLUDE CSB_PRT.INC
                INCLUDE HARDWARE.COD
                INCLUDE DEBUGGER.COD
                INCLUDE MENUS0.COD
                INCLUDE MENUS1.COD
                INCLUDE MENUS2.COD
                INCLUDE MENUS3.COD
                INCLUDE ADLIB.COD
SEG_CODE        ENDS

SEG_S           SEGMENT PARA STACK USE16
                DW      2*2048 DUP (7)
SEG_S           ENDS

SEG_RAM         SEGMENT PARA PUBLIC USE16
                DW      32*1024 DUP(0)
SEG_RAM         ENDS

SEG_ROM         SEGMENT PARA PUBLIC USE16
                INCLUDE ..\BASIC.INC
                INCLUDE ..\KERNEL.INC
                INCLUDE ..\3P1.INC
SEG_ROM         ENDS

SEG_CART        SEGMENT PARA PUBLIC USE16
                DB      16*1024 DUP('F')        ;C1-LOW
                DB      16*1024 DUP('G')        ;C1-HIGH
                DB      16*1024 DUP('H')        ;C2-LOW
                DB      16*1024 DUP('I')        ;C2-HIGH
SEG_CART        ENDS

SEG_VRAM1       SEGMENT PARA PUBLIC USE16
                DW      32*1024 DUP('1V')
SEG_VRAM1       ENDS

SEG_VRAM2       SEGMENT PARA PUBLIC USE16
                DW      4*1024 DUP('2V')
SEG_VRAM2       ENDS

SEG_AUX         SEGMENT PARA PUBLIC USE16
                DB      8000 DUP(0)             ;DEBUGGER
                DB      8000 DUP(0)             ;DATASETTE
SEG_AUX         ENDS
                END     START


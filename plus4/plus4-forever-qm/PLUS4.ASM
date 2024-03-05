format MZ

                INCLUDE 'FASM.MAC'
                INCLUDE '8501.MAC'
                INCLUDE 'ADLIB.MAC'
                INCLUDE 'CONST.MAC'

ENTRY SEG_CODE:START                    ;program entry point
STACK 2000H                             ;stack size
HEAP 0

SEGMENT         SEG_DATA USE16
                INCLUDE 'DOS.DAT'
                INCLUDE 'MDAC.DAT'
                INCLUDE 'ROMFN.DAT'
                INCLUDE '8501.DAT'
                INCLUDE 'CDS.DAT'
                INCLUDE 'DEBUGGER.DAT'
                INCLUDE 'KBD.DAT'
                INCLUDE 'JOY.DAT'
                INCLUDE 'IO.DAT'
                INCLUDE 'TED.DAT'
                INCLUDE 'MENUS0.DAT'
                INCLUDE 'MENUS1.DAT'
                INCLUDE 'MENUS2.DAT'
                INCLUDE 'MENUS3.DAT'
                INCLUDE 'SOUND.DAT'
                INCLUDE 'ADLIB.DAT'
                INCLUDE 'TIMER.DAT'

SEGMENT         SEG_CODE USE16          ;main program segment
START:          PUSH    DS              ;SET RETURN TO DOS ADDRESS
                SUB     AX,AX
                PUSH    AX
                MOV     AX,SEG SEG_DATA ;INIT DS
                MOV     DS,AX
                MOV     [RESET_SP],SP

                CALL    INITIBM

RESET:          MOV     SP,[RESET_SP]
                CALL    XRESET
MAIN_ENTRY:     MOV     [MAINJUMP],MAINLOOP

MAINLOOP:       CALL    TED
                CALL    CPU8501
                JMP     [MAINJUMP]

END_EMU:        MOV     SP,[RESET_SP]
                CALL    FINISHIBM
                RETF

                INCLUDE 'KBD.COD'
                INCLUDE 'JOY.COD'
                INCLUDE 'TED.COD'
                INCLUDE '8501.COD'
                INCLUDE 'CPU_IO.COD'
                INCLUDE 'CDS.COD'
                INCLUDE 'CSB.COD'
;                INCLUDE 'ACIA.INC'
;                INCLUDE 'C1551.INC'
;                INCLUDE 'CSB_FDD.INC'
;                INCLUDE 'CSB_PRT.INC'
                INCLUDE 'HARDWARE.COD'
                INCLUDE 'DEBUGGER.COD'
                INCLUDE 'MENUS0.COD'
                INCLUDE 'MENUS1.COD'
                INCLUDE 'MENUS2.COD'
                INCLUDE 'MENUS3.COD'
                INCLUDE 'SOUND.COD'
                INCLUDE 'ADLIB.COD'
                INCLUDE 'TIMER.COD'

SEGMENT         SEG_RAM USE16
TIMES   32*1024 DW      0

SEGMENT         SEG_ROM USE16
                FILE    '../BASIC.ROM'
                FILE    '../KERNAL.ROM'
                FILE    '../3P1.ROM'

SEGMENT         SEG_CART USE16
TIMES   16*1024 DB      'F'             ;C1-LOW
TIMES   16*1024 DB      'G'             ;C1-HIGH
TIMES   16*1024 DB      'H'             ;C2-LOW
TIMES   16*1024 DB      'I'             ;C2-HIGH

SEGMENT         SEG_VRAM1 USE16
TIMES   32*1024 DW      'V1'

SEGMENT         SEG_VRAM2 USE16
TIMES   4*1024  DW      'V2'

SEGMENT         SEG_AUX USE16
TIMES   8000    DB      4               ;DEBUGGER
TIMES   8000    DB      5               ;DATASETTE


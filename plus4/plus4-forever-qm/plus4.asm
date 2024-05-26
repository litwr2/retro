format MZ

                INCLUDE 'fasm.mac'
                INCLUDE '8501.mac'
                INCLUDE 'adlib.mac'
                INCLUDE 'const.mac'

ENTRY SEG_CODE:START                    ;program entry point
STACK 2000H                             ;stack size
HEAP 0

SEGMENT         SEG_DATA USE16
                INCLUDE 'dos.dat'
                INCLUDE 'mdac.dat'
                INCLUDE 'romfn.dat'
                INCLUDE '8501.dat'
                INCLUDE 'cds.dat'
                INCLUDE 'debugger.dat'
                INCLUDE 'kbd.dat'
                INCLUDE 'joy.dat'
                INCLUDE 'io.dat'
                INCLUDE 'ted.dat'
                INCLUDE 'menus0.dat'
                INCLUDE 'menus1.dat'
                INCLUDE 'menus2.dat'
                INCLUDE 'menus3.dat'
                INCLUDE 'sound.dat'
                INCLUDE 'adlib.dat'
                INCLUDE 'timer.dat'

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

                INCLUDE 'kbd.cod'
                INCLUDE 'joy.cod'
                INCLUDE 'ted.cod'
                INCLUDE '8501.cod'
                INCLUDE 'cpu_io.cod'
                INCLUDE 'cds.cod'
                INCLUDE 'csb.cod'
;                INCLUDE 'acia.inc'
;                INCLUDE 'c1551.inc'
;                INCLUDE 'csb_fdd.inc'
;                INCLUDE 'csb_prt.inc'
                INCLUDE 'hardware.cod'
                INCLUDE 'debugger.cod'
                INCLUDE 'menus0.cod'
                INCLUDE 'menus1.cod'
                INCLUDE 'menus2.cod'
                INCLUDE 'menus3.cod'
                INCLUDE 'sound.cod'
                INCLUDE 'adlib.cod'
                INCLUDE 'timer.cod'

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


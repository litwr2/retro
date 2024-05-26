format MZ

                INCLUDE 'fasm.mac'
                INCLUDE 'const.mac'
                INCLUDE '8501.mac'
                INCLUDE 'adlib.mac'
                INCLUDE 'iec.mac'
                INCLUDE 'hardware.mac'

ENTRY SEG_CODE:START                    ;program entry point
STACK 2000H                             ;stack size
HEAP 0

SEGMENT         SEG_DATA USE16
        db 'xxxx'
                INCLUDE 'dos.dat'
                INCLUDE 'hardware.dat'
                INCLUDE 'mdac.dat'
                INCLUDE 'romfn.dat'
                INCLUDE '8501.dat'
                INCLUDE 'cds.dat'
                INCLUDE 'iec.dat'
                INCLUDE 'debugger.dat'
                INCLUDE 'kbd.dat'
                INCLUDE 'joy.dat'
                INCLUDE 'io.dat'
                INCLUDE 'ted.dat'
                INCLUDE 'video.dat'
                INCLUDE 'menus0.dat'
                INCLUDE 'menus1.dat'
                INCLUDE 'menus2.dat'
                INCLUDE 'menus3.dat'
                INCLUDE 'sound.dat'
                INCLUDE 'adlib.dat'
                INCLUDE 'timer.dat'
                INCLUDE 'sb.dat'
                ;INCLUDE 'log.dat'

SEGMENT         SEG_CODE USE16          ;main program segment
        db 'xxxx'
START:          PUSH    DS              ;SET RETURN TO DOS ADDRESS
                PUSH    WORD 0
                MOV     AX,SEG_DATA     ;INIT DS
                MOV     DS,AX
                MOV     [RESET_SP],SP
                CALL    SEG_CODEX:INITIBM_F
RESET:          MOV     SP,[RESET_SP]
                CALL    SEG_CODEX:XRESET_F
MAIN_ENTRY:     MOV     [MAINJUMP],MAINLOOP
                ;MOV     [MAINJUMP],DEBUG_ENTRY

MAINLOOP:       CALL    TED
                CALL    CPU8501
                JMP     [MAINJUMP]

END_EMU:        MOV     SP,[RESET_SP]
                JMP     SEG_CODEX:FINISHIBM_F

                INCLUDE 'kbd.cod'
                INCLUDE 'joy.cod'
                INCLUDE 'ted.cod'
                INCLUDE 'memory.cod'
                INCLUDE '8501.cod'
                INCLUDE 'cpu_io.cod'
                INCLUDE 'cds.cod'
                INCLUDE 'csb.cod'
                INCLUDE 'video.cod'
                INCLUDE 'sound.cod'
                INCLUDE 'adlib.cod'
                INCLUDE 'timer.cod'
                INCLUDE 'sb.cod'
                INCLUDE 'c2x.cod'

SEGMENT         SEG_CODEX USE16          ;extra program segment
        db 'xxxx'
                INCLUDE 'conv.cdx'
                INCLUDE 'intr8.cdx'
                INCLUDE 'intr9.cdx'
                INCLUDE 'x2c.cdx'
                INCLUDE 'iec.cdx'
                INCLUDE 'debugger.cdx'
                INCLUDE 'menus0.cdx'
                INCLUDE 'menus1.cdx'
                INCLUDE 'menus2.cdx'
                INCLUDE 'menus3.cdx'
                INCLUDE 'hardware.cdx'
                ;INCLUDE 'log.cdx'
        db 'xxxx'

SEGMENT         SEG_RAM USE16
TIMES   32*1024 DW      0FFH

SEGMENT         SEG_ROM USE16
                FILE    '../BASIC.ROM'
                FILE    '../KERNAL.ROM'
                FILE    '../3P1.ROM'

SEGMENT         SEG_CART USE16
TIMES   16*1024 DB      'F'             ;C1-LOW
TIMES   16*1024 DB      'G'             ;C1-HIGH
TIMES   16*1024 DB      'H'             ;C2-LOW
TIMES   16*1024 DB      'I'             ;C2-HIGH

SEGMENT         SEG_1551 USE16
                FILE    '../1551.ROM'

SEGMENT         SEG_VRAM1 USE16
TIMES   16*1024 DD      'VBE2'

SEGMENT         SEG_VRAM2 USE16 ;4K used for fonts transform 8->16
TIMES   79*512  DB      '2'

SEGMENT         SEG_DBG USE16
TIMES   4000    DB      4               ;DEBUGGER

SEGMENT         SEG_DS  USE16
TIMES   8000    DB      5               ;DATASETTE


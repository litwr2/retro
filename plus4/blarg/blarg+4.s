;
; GRABAS (for VASM OLDSTYLE assembler)
;
; A graphics extension for C+4 BASIC
; Litwr 2026
; v1.0
; based on
;
; GRABAS
;
; A graphics extension for C-64 BASIC
;
; SLJ 12/29/96 (Completed 2/10/97)
; v1.0
;
         include "registers.mac"
         ORG $1001

; Constants

TXTPTR   = $3b            ;BASIC text pointer  $7a
;IERROR   = $300
ICRUNCH  = $304          ;Crunch ASCII into token
IQPLOP   = $306          ;List
IGONE    = $308          ;Execute next BASIC token

CHRGET   = $473
CHRGOT   = $479
CHROUT   = $FFD2

BITTAB = $C289  ;or $DF7A

GETBYT   = $9D84  ;BASIC routine formula to FAC
GETPAR   = $9dd2   ;Get a 16,8 pair of numbers
CHKCOM   = $9491

LINNUM   = $14            ;Number returned by GETPAR, r6l, 2 bytes
;--
TEMP     = r5h
TEMP2    = r4l  ;2 bytes
POINT    = r0l  ;2 bytes
Y1       = rbl
X1       = LINNUM    ;2 bytes
X2       = r8l  ;2 bytes
Y2       = r3l
DY       = r3h
DX       = r1l  ;2 bytes
CX       = r2l  ;2 bytes
CY       = r5l
BUF      = $200          ;Input buffer

CHUNK1   = r7l            ;Circle routine stuff
OLDCH1   = r7h
CHUNK2   = rcl
OLDCH2   = rch
XC       = ral
YC       = rah
RADIUS   = rbh
LCOL     = r9l            ;Left column
RCOL     = r9h
TROW     = rdl            ;Top row
BROW     = rdh            ;Bottom row

 byte <(eob-2),>(eob-2),$a,0
 byte $9e  ;sys
 byte init/1000+48, init/100%10+48, init/10%10+48, init%10+48, ":"
 byte $de  ;graphic
 text "1,1:"
 byte $9e  ;sys
 byte start/1000+48, start/100%10+48, start/10%10+48, start%10+48, ":"
 byte $de  ;graphic
 byte "0:"
 byte $a2  ;new
 byte 0,0,0
eob

ORGX = eob - 2
ORGY = eob - 1

start
         lda #<pesc
         sta $310
         lda #>pesc
         sta $311
         ;JMP INIT

;
; Init routine -- modify vectors
; and set up values.
;
INIT     LDX #5           ;Copy vectors
.LOOP    LDA .TABLE,X
         STA ICRUNCH,X
         DEX
         BPL .LOOP
         rts

.TABLE   DFW CRUNCH
         DFW LIST
         DFW EXECUTE
JMPCRUN  DFB $4C          ;JMP
OLDCRNCH DS 2             ;Old CRUNCH vector
OLDLIST  DS 2
OLDEXEC  DS 2

;
; Keyword list
; Keywords are stored as normal text,
; followed by the token number.
; All tokens are >128,
; so they easily mark the end of the keyword
;
KEYWORDS
         BYTE 'PLOT', $e0
         BYTE 'LINE',  $e1
         BYTE 'FCIRC', $e2
         BYTE 'MODE', $e3
         DFB $B0          ;OR
         BYTE 'IGIN', $e4
         BYTE 'CLEAR', $e5   ;Clear bitmap
         BYTE 'BUFFER',$e6  ;Set draw buffer
         BYTE 'SWAP', $e7    ;Swap foreground and background
         BYTE 'FCOL',$e8  ;Set color
         DFB 0           ;End of list

;
; Table of token locations-1
; Subtract $10 first
; Then check to make sure number isn't greater than NUMWORDS
;
TOKENLOC
.T0      DFW PLOT-1        ;+
.T1      DFW LINE-1        ;+
.T2      DFW CIRCLE-1      ;+
.T3      DFW MODE-1        ;+
.T4      DFW ORIGIN-1      ;+
.T5      DFW CLEAR-1       ;+
.T6      DFW BUFFER-1      ;
.T7      DFW SWAP-1        ;+
.T8      DFW COLOR-1       ;+
HITOKEN  EQU $E9

;
; CRUNCH -- If this is one of our keywords, then tokenize it
;
CRUNCH
         JSR JMPCRUN      ;First crunch line normally
         LDY #0
.LOOP    STY TEMP
         JSR ISWORD       ;Are we at a keyword?
         BCS .GOTCHA
.NEXT
         JSR NEXTCHAR
         BNE .LOOP        ;Null byte marks end

         dey
         dey
         RTS              ;Buh-bye
; Insert token and crunch line
.GOTCHA
         LDX TEMP         ;If so, A contains opcode
         STA BUF+1,X
         lda #$fe
         sta BUF,x
         inx
.MOVE    INX
         iny
         LDA BUF-1,Y
         STA BUF,X      ;Move text backwards
         Bne .MOVE
         BEQ .NEXT
;
; ISWORD -- Checks to see if word is
; in table.  If a word is found, then
; C is set, Y is one past the last char
; and A contains opcode.  Otherwise,
; carry is clear.
;
; On entry, TEMP must contain current
; character position.
;
ISWORD
         LDX #0
.LOOP    LDY TEMP
.LOOP2   LDA KEYWORDS,X
         BEQ .NOTMINE

         CMP #$E0
         BCS .RTS         ;Tokens are >=$E0

         CMP BUF,Y
         BNE .NEXT

         INY              ;Success!  Go to next char
         INX
         BNE .LOOP2
.NEXT
         INX
         LDA KEYWORDS,X   ;Find next keyword
         CMP #$E0
         BCC .NEXT

         INX
         BNE .LOOP        ;And check again

.NOTMINE CLC
.RTS     RTS

;
; NEXTCHAR finds the next char
; in the buffer, skipping
; spaces and quotes.  On
; entry, TEMP contains the
; position of the last spot
; read.  On exit, Y contains
; the index to the next char,
; A contains that char, and Z is set if at end of line.
;
NEXTCHAR
         LDY TEMP
.LOOP    INY
         LDA BUF,Y
         BEQ .DONE

         CMP #$8F         ;REM
         BNE .CONT

         LDA #0
.SKIP    STA TEMP2        ;Find matching character
.LOOP2   INY
         LDA BUF,Y
         BEQ .DONE

         CMP TEMP2
         BNE .LOOP2       ;Skip to end of line
         BEQ .LOOP
.CONT
         CMP #$20         ;Space
         BEQ .LOOP

         CMP #$22         ;Quote
         BEQ .SKIP
.DONE    RTS

;
; LIST -- patches the LIST routine
; to list my tokens correctly.
;
LIST     CMP #$fE
         Bne .NOTMINE     ;Not my token

         iny
         jsr $4d1
         dey

         CMP #HITOKEN
         BCS .NOTMINE

         BIT $0F          ;Check for quote mode
         BMI .NOTMINE

         iny
         SEC
         SBC #$DF         ;Find the corresponding text
         TAX
         STY $49
         LDY #0
.LOOP    DEX
         BEQ .DONE

.LOOP2   INY
         LDA KEYWORDS,Y
         CMP #$E0
         BCC .LOOP2

         INY
         BNE .LOOP

.DONE    LDA KEYWORDS,Y
         BMI .OUT

         JSR CHROUT
         INY
         BNE .DONE

.OUT     CMP #$B0         ;OR
         BEQ .OR

         CMP #$E0         ;It might be BASIC token
         BCS .CONT        ;e.g. GRON

         LDY $49
.NOTMINE AND #$FF
         JMP (OLDLIST)    ;QPLOP

.CONT    LDY $49
         JMP $8B5C   ;$A700        ;Normal exit

.OR      LDA #'O'         ;For ORIGIN
         JSR CHROUT
         LDA #'R'
         JSR CHROUT
         INY
         BNE .DONE

pesc lda $3b
     bne *+4
     dec $3c
     dec $3b
     lda #$fe
     jmp EXECUTE.e1
;
; EXECUTE -- if this is one of my
; tokens, then execute it.
;
EXECUTE  JSR CHRGET
.e1      PHP
         CMP #$fE
         Bne .NOTMINE

         ldy #1
         jsr $4a5
         ;CMP #$E0
         ;BCC .NOTMINE

         CMP #HITOKEN
         BCS .NOTMINE

         PLP
         jsr CHRGET   ;inc $3b??
         JSR .DISP
         JMP $8bdc  ;$A7AE        ;Exit through NEWSTT
.DISP
         EOR #$E0
         ASL              ;Mult by two
         TAX
         LDA TOKENLOC+1,X
         PHA
         LDA TOKENLOC,X
         PHA
         JMP CHRGET       ;Exit to routine

.NOTMINE PLP
         JMP $8bd9  ;$A7E7        ;Normal routine

;
; PLOT -- plot a point!
;
DONTPLOT DFB 1           ;0=Don't plot point, just compute
                          ;coordinates (used by e.g. circles)

PLOT     JSR GETPAR       ;Get coordinate pair
         LDA LINNUM       ;Add in origin offset
         SEC
         SBC ORGX
         STA LINNUM
         BCS .CONT1

         DEC LINNUM+1
         BMI .ERROR       ;Underflow

         SEC
.CONT1   TXA
         SBC ORGY
         BCC .ERROR

         TAX
         CPX #200         ;Check range
         BCS .ERROR

         LDA LINNUM
         CMP #<320
         LDA LINNUM+1
         SBC #>320
         BCC SETPOINT
.ERROR   RTS              ;Just don't plot point
;.ERROR LDX #14
; JMP (IERROR)
SETPOINT                  ;Alternative entry point
                          ;X=y-coord, LINNUM=x-coord
; ;X is preserved
; STX TEMP2
; STY TEMP2+1
                          ;On exit, X,Y are AND #$07
                          ;i.e. are set up correctly.
         TXA
         AND #248
         STA POINT
         LSR
         LSR
         LSR
         ADC BASE         ;Base of bitmap
         STA POINT+1
         LDA #00
         ASL POINT
         ROL
         ASL POINT
         ROL
         ASL POINT
         ROL
         ADC LINNUM+1
         ADC POINT+1
         STA POINT+1
         TXA
         AND #7
         TAY
         LDA LINNUM
         AND #248
         CLC              ;Overflow is possible!
         ADC POINT
         STA POINT
         BCC SETPIXEL
         INC POINT+1
SETPIXEL
         LDA LINNUM
         AND #$07
         TAX
         LDA DONTPLOT
         BEQ .RTS

         LDA POINT+1
         SEC
         SBC BASE         ;Overflow check
         CMP #$20
         BCS .RTS

         LDA (POINT),Y
         EOR BITMASK
         AND BITTAB,X
         EOR (POINT),Y
         STA (POINT),Y
; LDX TEMP2
; LDY TEMP2+1
                          ;On exit, X,Y are AND #$07
                          ;i.e. are set up correctly.
                          ;for more plotting
.RTS     RTS

BITMASK  DFB $FF         ;Set point

;-------------------------------
; Drawin' a line.  A fahn lahn.
;
; To deal with off-screen coordinates, the current row
; and column (40x25) is kept track of.  These are set
; negative when the point is off the screen, and made
; positive when the point is within the visible screen.

; Little bit position table
;BITCHUNK HEX FF7F3F1F0F070301
BITCHUNK BYTE $FF,$7F,$3F,$1F,$0F,$07,$03,$01
CHUNK    EQU X2
OLDCHUNK EQU X2+1

; DOTTED -- Set to $01 if doing dotted draws (diligently)
; X1,X2 etc. are set up above (x2=LINNUM in particular)
; Format is LINE x2,y2,x1,y1

LINE
         JSR GETPAR
         STX Y2
         LDA LINNUM
         STA X2
         LDA LINNUM+1
         STA X2+1
         JSR CHKCOM
         JSR GETPAR
         STX Y1

.CHECK   LDA X2           ;Make sure x1<x2
         SEC
         SBC X1
         TAX
         LDA X2+1
         SBC X1+1
         BCS .CONT

         LDA Y2           ;If not, swap P1 and P2
         LDY Y1
         STA Y1
         STY Y2
         LDA X1
         LDY X2
         STY X1
         STA X2
         LDA X2+1
         LDY X1+1
         STA X1+1
         STY X2+1
         BCC .CHECK

.CONT    STA DX+1
         STX DX

         LDX #$C8         ;INY
         LDA Y2           ;Calculate dy
         SEC
         SBC Y1
         BCS .DYPOS       ;Is y2>=y1?

         EOR #$FF         ;Otherwise dy=y1-y2
         ADC #$01
         LDX #$88         ;DEY

.DYPOS   STA DY
         STX YINCDEC
         STX XINCDEC

         LDA X1           ;Sub origin from 1st point
         SEC
         SBC ORGX
         STA X1
         LDA X1+1
         SBC #00
         STA X1+1
         PHP              ;Save carry flag
         STA TEMP         ;Next compute column
         LDA X1
         LSR TEMP
         ROR
         LSR TEMP
         ROR
         LSR TEMP
         ROR
         STA CX           ;X-column
         PLP
         BCC .NEGX        ;If negative, then fix up
         CMP #40          ;If past column 40, then punt!
         BCC .CONT1
         RTS

.NEGX    LDA X1           ;coordinate start and count
         AND #$07
         STA X1
         LDA #00
         STA X1+1
         ;LDA CX     ;remove??

.CONT1   LDA Y1           ;Now do the same for Y
         SEC
         SBC ORGY
         STA Y1
         TAX              ;X=y-coord
         PHP              ;Save carry bit
         LSR
         LSR
         LSR
         STA CY           ;Y-column (well, OK, row then)
         PLP
         BCC .NEGY        ;If negative, then fix stuff up!

         SBC #25          ;Check if we are past bottom of
         BCC .CONT2       ;screen

         ORA #$80         ;Otherwise, 128+rows past 24
         STA CY           ;(for plot range checking)
         TXA
         AND #$07
         ORA #8*24        ;Start in last row
         TAX
         BMI .CONT2

.NEGY    ORA #$E0         ;Set high bits of column
         STA CY
         TXA
         AND #$07
         TAX              ;Start in 1st row
.CONT2
         LDA #00
         STA DONTPLOT
         JSR SETPOINT     ;Set up X,Y and POINT
         INC DONTPLOT
         LDA BITCHUNK,X
         STA OLDCHUNK
         STA CHUNK

         LDX DY
         CPX DX           ;Who's bigger. dy or dx?
         BCC STEPINX      ;If dx, then...

         LDA DX+1
         BNE STEPINX

;
; Big steps in Y
;
;   To simplify my life, just use PLOT to plot points.
;
;   No more!
;   Added special plotting routine -- cool!
;
;   X is now counter, Y is y-coordinate
;
; On entry, X=DY=number of loop iterations, and Y=
;   Y1 AND #$07
STEPINY
         LDA #00
         STA OLDCHUNK     ;So plotting routine will work right
         LDA CHUNK
         SEC
         LSR              ;Strip the bit
         EOR CHUNK
         STA CHUNK
         TXA
         BNE .CONT        ;If dy=0 it's just a point
         INX
.CONT    LSR              ;Init counter to dy/2
;
; Main loop
;
YLOOP    STA TEMP
; JSR LINEPLOT

         LDA CX           ;Range check
         ORA CY
         BMI .SKIP

         LDA (POINT),Y    ;Otherwise plot
         EOR BITMASK
         AND CHUNK
         EOR (POINT),Y
         STA (POINT),Y
.SKIP
YINCDEC  INY              ;Advance Y coordinate
         CPY #8
         BCC .CONT        ;No prob if Y=0..7

         JSR FIXY
.CONT    LDA TEMP         ;Restore A
         SEC
         SBC DX
         BCC YFIXX

YCONT    DEX              ;X is counter
         BNE YLOOP
YCONT2   LDA (POINT),Y    ;Plot endpoint
         EOR BITMASK
         AND CHUNK
         EOR (POINT),Y
         STA (POINT),Y
YDONE    RTS

YFIXX                     ;x=x+1
         ADC DY
         LSR CHUNK
         BNE YCONT        ;If we pass a column boundary...
         ROR CHUNK        ;then reset CHUNK to $80
         STA TEMP2
         LDA CX
         BMI .CONT        ;Skip if column is negative

         CMP #39          ;End if move past end of screen
         BCS YDONE

         LDA POINT        ;And add 8 to POINT
         ADC #8
         STA POINT
         BCC .CONT
         INC POINT+1
.CONT    INC CX           ;Increment column
         LDA TEMP2
         DEX
         BNE YLOOP
         BEQ YCONT2

;
; Big steps in X direction
;
; On entry, X=DY=number of loop iterations, and Y=
;   Y1 AND #$07

COUNTHI  DFB 00           ;Temporary counter
                          ;only used once
STEPINX
         LDX DX
         LDA DX+1
         STA COUNTHI
         LSR              ;Need bit for initialization
         STA Y1           ;High byte of counter
         TXA
         BNE .CONT        ;Could be $100

         DEC COUNTHI
.CONT    ROR
;
; Main loop
;
XLOOP
         LSR CHUNK
         BEQ XFIXC        ;If we pass a column boundary...

XCONT1   SBC DY
         BCC XFIXY        ;Time to step in Y?

XCONT2   DEX
         BNE XLOOP

         DEC COUNTHI      ;High bits set?
         BPL XLOOP
XDONE
         LSR CHUNK        ;Advance to last point
         JMP LINEPLOT     ;Plot the last chunk
;
; CHUNK has passed a column, so plot and increment pointer
; and fix up CHUNK, OLDCHUNK.
;
XFIXC
         STA TEMP
         JSR LINEPLOT
         LDA #$FF
         STA CHUNK
         STA OLDCHUNK
         LDA CX
         BMI .CONT        ;Skip if column is negative

         CMP #39          ;End if move past end of screen
         BCS EXIT

         LDA POINT
         ADC #8
         STA POINT
         BCC .CONT
         INC POINT+1
.CONT    INC CX
         LDA TEMP
         JMP XCONT1
;
; Check to make sure there isn't a high bit, plot chunk,
; and update Y-coordinate.
;
XFIXY
         DEC Y1           ;Maybe high bit set
         BPL XCONT2
         ADC DX
         STA TEMP
         LDA DX+1
         ADC #$FF         ;Hi byte
         STA Y1

         JSR LINEPLOT     ;Plot chunk
         LDA CHUNK
         STA OLDCHUNK

         LDA TEMP
XINCDEC  INY              ;Y-coord
         CPY #8           ;0..7 is ok
         BCC XCONT2
         STA TEMP
         JSR FIXY
         LDA TEMP
         JMP XCONT2

;
; Subroutine to plot chunks/points (to save a little
; room, gray hair, etc.)
;
LINEPLOT                  ;Plot the line chunk
         LDA CX
         ORA CY
         BMI EXIT

         LDA (POINT),Y    ;Otherwise plot
         EOR BITMASK
         ORA CHUNK
         AND OLDCHUNK
         EOR CHUNK
         EOR (POINT),Y
         STA (POINT),Y
EXIT     RTS

;
; Subroutine to fix up pointer when Y decreases through
; zero or increases through 7.
;
FIXY     CPY #255         ;Y=255 or Y=8
         BEQ .DECPTR
.INCPTR                   ;Add 320 to pointer
         LDY #0           ;Y increased through 7
         LDA CY
         BMI .CONT1       ;If negative, then don't update

         CMP #24
         BCS .TOAST       ;If at bottom of screen then quit

         LDA POINT
         ADC #<320
         STA POINT
         LDA POINT+1
         ADC #>320
         STA POINT+1
.CONT1   INC CY
         RTS
.DECPTR                   ;Okay, subtract 320 then
         LDY #7           ;Y decreased through 0
         LDA CY
         BEQ .TOAST
         BMI .CONT2

         CMP #$7F         ;It is possible we just decreased
         BNE .C1          ;through row 25

         LDA #24
         STA CY           ;In which case, set correct row
.C1      LDA POINT
         SEC
         SBC #<320
         STA POINT
         LDA POINT+1
         SBC #>320
         STA POINT+1
.CONT2   DEC CY
         RTS

.TOAST   PLA              ;Remove old return address
         PLA
         RTS

;
; CIRCLE draws a circle of course, using my
; super-sneaky algorithm.
;   CIRCLE cx,cy,radius (16,8,8)
;

CIRCLE   JSR GETPAR
         STX CY           ;CX,CY = center

         LDA X1
         SEC
         SBC ORGX
         STA CX
         STA X1
         LDA X1+1
         SBC #0
         STA CX+1
         STA X1+1
         PHP              ;Save carry
         LSR              ;Compute which column we start
         LDA CX           ;in
         ROR
         LSR
         LSR
         PLP
         BCS .CONT        ;Underflow means negative column

         TAX
         LDA X1           ;Set X to first column
         AND #$07
         STA X1
         LDA #00
         STA X1+1
         TXA
         ORA #$E0         ;so set high bits
.CONT    STA RCOL
         STA LCOL
         BMI .SKIP

         CMP #40          ;Check for benefit of SETPOINT
         BCC .SKIP

         LDA X1           ;Set X in last column
         AND #$07
         ORA #64-8        ;312+X AND 7
         STA X1
         LDA #1
         STA X1+1
.SKIP
         JSR CHKCOM
         JSR GETBYT
CIRCENT                   ;Alternative entry point
         STX YC
         STX RADIUS
         TXA
         BNE .C           ;Skip R=0

         LDX CY
         JMP SETPOINT     ;Plot it as a point.

.C       CLC
         ADC CY
         BCS .BLAH

         SEC
         SBC ORGY
         BCS .C4          ;cy+y<orgy implies circle off screen
.RTS     RTS

.BLAH    SBC ORGY         ;Always positive
         BCS .C3          ;Handle overflow sneaky

.C4      TAX
         CMP #200         ;If Y>200 then set pointer to
         BCC .C2          ;last row, but set TROW

         CLC              ;correctly
.C3      TAY
         AND #$07
         ORA #$C0         ;Last row, set Y1 correctly
         TAX
         TYA
.C2      ROR
         LSR
         LSR
         STA TROW         ;Top row

         LDA #0
         STA DONTPLOT     ;Don't plot points
         JSR SETPOINT     ;Plot XC,YC+Y
         STY Y2           ;Y AND 07
         LDA BITCHUNK,X
         STA CHUNK1       ;Forwards chunk
         STA OLDCH1
         LSR
         EOR #$FF
         STA CHUNK2       ;Backwards chunk
         STA OLDCH2
         LDA POINT
         STA TEMP2        ;TEMP2 = forwards high pointer
         STA X2           ;X2 = backwards high pointer
         LDA POINT+1
         STA TEMP2+1
         STA X2+1

         LDA CY           ;Now compute upper points
         SEC
         SBC ORGY
         BCS .CSET

         SEC              ;We are so very negative
         SBC YC
         CLC
         BCC .BNEG

.CSET    SBC YC            ;Compute CY-Y-ORGY
.BNEG    PHP
         TAX
         LSR              ;Compute row
         LSR
         LSR
         STA BROW
         PLP
         BCS .CONT
         ORA #$E0         ;Make row negative
         STA BROW
         TXA
         AND #07          ;Handle underflow special!
         TAX
.CONT    JSR SETPOINT     ;Compute new coords
         STY Y1
         LDA POINT
         STA X1           ;X1 will be the backwards
         LDA POINT+1      ;low-pointer
         STA X1+1         ;POINT will be forwards

         LDA YC
         LSR              ;A=r/2
         LDX #00
         STX XC            ;y=0

; Main loop

.LOOP
         INC XC            ;x=x+1

         LSR CHUNK1       ;Right chunk
         BNE .CONT1

         JSR UPCHUNK1     ;Update if we move past a column
.CONT1   ASL CHUNK2
         BNE .CONT2

         JSR UPCHUNK2
.CONT2                    ;LDA TEMP
         SEC
         SBC XC            ;a=a-x
         BCS .LOOP

         ADC YC            ;if a<0 then a=a+y; y=y-1
         TAX
         JSR PCHUNK1
         JSR PCHUNK2
         LDA CHUNK1
         STA OLDCH1
         LDA CHUNK2
         STA OLDCH2
         TXA

         DEC YC            ;(y=y-1)

         DEC Y2           ;Decrement y-offest for upper
         BPL .CONT3       ;points

         JSR DECYOFF
.CONT3   LDY Y1
         INY
         STY Y1
         CPY #8

         BCC .CONT4
         JSR INCYOFF
.CONT4
         LDY XC
         CPY YC            ;if y<=x then punt
         BCC .LOOP        ;Now draw the other half
;
; Draw the other half of the circle by exactly reversing
; the above!
;
NEXTHALF
         LSR OLDCH1       ;Only plot a bit at a time
         ASL OLDCH2
         LDA RADIUS       ;A=-R/2-1
         LSR
         EOR #$FF
.LOOP
         TAX
         JSR PCHUNK1      ;Plot points
         JSR PCHUNK2
         TXA
         DEC Y2           ;Y2=bottom
         BPL .CONT1
         JSR DECYOFF
.CONT1   INC Y1
         LDY Y1
         CPY #8
         BCC .CONT2
         JSR INCYOFF
.CONT2
         LDX YC
         BEQ .DONE
         CLC
         ADC YC            ;a=a+y
         DEC YC            ;y=y-1
         BCC .LOOP

         INC XC
         SBC XC            ;if a<0 then x=x+1; a=a+x
         LSR CHUNK1
         BNE .CONT3
         TAX
         JSR UPCH1        ;Upchunk, but no plot
.CONT3   LSR OLDCH1       ;Only the bits...
         ASL CHUNK2       ;Fix chunks
         BNE .CONT4
         TAX
         JSR UPCH2
.CONT4   ASL OLDCH2
         BCS .LOOP
.DONE
CIRCEXIT                  ;Restore interrupts
         LDA #1           ;Re-enable plotting
         STA DONTPLOT
         RTS
;
; Decrement upper pointers
;
DECYOFF
         TAY
         LDA #7
         STA Y2
         LDA TROW         ;First check to see if Y is in
         BEQ EXIT2

         CMP #25          ;range (rows 0-24)
         BCS .SKIP

         LDA X2           ;If we pass through zero, then
         SEC
         SBC #<320        ;subtract 320
         STA X2
         LDA X2+1
         SBC #>320
         STA X2+1
         LDA TEMP2
         SEC
         SBC #<320
         STA TEMP2
         LDA TEMP2+1
         SBC #>320
         STA TEMP2+1
.SKIP    TYA
         DEC TROW
         RTS
EXIT2    PLA              ;Grab return address
         PLA
         JMP CIRCEXIT     ;Restore interrupts, etc.

; Increment lower pointers
INCYOFF
         TAY
         LDA #00
         STA Y1
         LDA BROW
         BMI .ISKIP       ;If <0 then don't update pointer.

         CMP #24          ;If we hit bottom of screen then
         BEQ EXIT2        ;just quit

         LDA X1
         CLC
         ADC #<320
         STA X1
         LDA X1+1
         ADC #>320
         STA X1+1
         LDA POINT
         CLC
         ADC #<320
         STA POINT
         LDA POINT+1
         ADC #>320
         STA POINT+1
.ISKIP   TYA
         INC BROW
         RTS

;
; UPCHUNK1 -- Update right-moving chunk pointers
;             Due to passing through a column
;
UPCHUNK1
         TAX
         JSR PCHUNK1
UPCH1    LDA #$FF         ;Alternative entry point
         STA CHUNK1
         STA OLDCH1
         LDA RCOL
         BMI .DONE        ;Can start negative

         LDA TEMP2
         CLC
         ADC #8
         STA TEMP2
         BCC .CONT

         INC TEMP2+1
         CLC
.CONT    LDA POINT
         ADC #8
         STA POINT
         BCC .DONE
         INC POINT+1
.DONE    TXA
         INC RCOL
         RTS

;
; UPCHUNK2 -- Update left-moving chunk pointers
;
UPCHUNK2
         TAX
         JSR PCHUNK2
UPCH2    LDA #$FF
         STA CHUNK2
         STA OLDCH2
         LDA LCOL
         CMP #40
         BCS .DONE

         LDA X2
         SEC
         SBC #8
         STA X2
         BCS .CONT
         DEC X2+1
         SEC
.CONT    LDA X1
         SBC #8
         STA X1
         BCS .DONE

         DEC X1+1
.DONE    TXA
         DEC LCOL
         RTS
;
; Plot right-moving chunk pairs for circle routine
;
PCHUNK1
         LDA RCOL         ;Make sure we're in range
         CMP #40
         BCS .SKIP2

         LDA CHUNK1       ;Otherwise plot
         EOR OLDCH1
         STA TEMP
         LDA BROW         ;Check for underflow
         BMI .SKIP

         LDY Y1
         LDA (POINT),Y
         EOR BITMASK
         AND TEMP
         EOR (POINT),Y
         STA (POINT),Y

.SKIP    LDA TROW         ;If CY+Y >= 200...
         CMP #25
         BCS .SKIP2

         LDY Y2
         LDA (TEMP2),Y
         EOR BITMASK
         AND TEMP
         EOR (TEMP2),Y
         STA (TEMP2),Y
.SKIP2
         RTS

;
; Plot left-moving chunk pairs for circle routine
;
PCHUNK2
         LDA LCOL         ;Range check in X
         CMP #40
         BCS .SKIP2

         LDA CHUNK2       ;Otherwise plot
         EOR OLDCH2
         STA TEMP
         LDA BROW         ;Check for underflow
         BMI .SKIP

         LDY Y1
         LDA (X1),Y
         EOR BITMASK
         AND TEMP
         EOR (X1),Y
         STA (X1),Y

.SKIP    LDA TROW         ;If CY+Y >= 200...
         CMP #25
         BCS .SKIP2

         LDY Y2
         LDA (X2),Y
         EOR BITMASK
         AND TEMP
         EOR (X2),Y
         STA (X2),Y
.SKIP2
         RTS

BASE     DFB $20          ;Address of bitmap, hi byte

CLEAR    JSR CHRGOT       ;See if there's a color
         BEQ .l1

         JSR GETPAR       ;Get bg color for buffer 1
         dex
         stx r2l
         lda LINNUM
         asl
         asl
         asl
         asl
         sta r2h
         jsr CHKCOM
         JSR GETPAR       ;Get fg color for buffer 1
         dex
         txa
         asl
         asl
         asl
         asl
         ora r2l
         sta .m1
         lda LINNUM
         jmp .l2
.l1
         lda $ff15  ;use colors for buffer 0
         pha
         and #$f   ;color
         sta r2l
         pla
         and #$f0   ;lum
         sta r2h
         lda $86
         asl
         asl
         asl
         asl
         ora r2l
         sta .m1
         lda $86
         lsr
         lsr
         lsr
         lsr
.l2      ora r2h
         sta .LOOP+1
         LDA MODENUM
         CMP #18
         BNE .rts

         LDY #0          ;Low byte of base address
         STY POINT
         sty TEMP2
         LDA #$60        ;Colormap is fixed for buffer 1
         STA POINT+1
         LDA #$64        ;colors
         sta TEMP2+1

         LDX #4
.LOOP    lda #0
         STA (POINT),Y
.m1 = * + 1
         lda #0
         sta (TEMP2),Y
         INY
         BNE .LOOP

         INC POINT+1
         inc TEMP2+1
         DEX
         BNE .LOOP

         LDA #$40         ;Now clear bitmap for buffer 1
         STA POINT+1
         LDX #32
         TYA
.LOOP2   STA (POINT),Y
         INY
         BNE .LOOP2

         INC POINT+1
         DEX
         BNE .LOOP2
.rts     RTS

;
; COLOR -- Set drawing color
;
COLOR    JSR GETBYT
COLENT   CPX #0          ;MODE enters here
         BEQ .C2

.C1      CPX #1          ;remove??
         BNE .RTS

         LDX #$FF
.C2      STX BITMASK
.RTS     RTS

;
; MODE -- catch-all command.  Currently implemented.
;   00  Erase (background color)
;   01  Foreground color
;   17  Normal mode
;   18  Double buffer mode
;
;  Anything else -> BITMASK
;
MODENUM  DFB 17           ;Current mode
MODE     JSR GETBYT
         CPX #2
         BCC COLENT

.C18     cpx MODENUM
         beq COLENT.RTS

         CPX #18          ;Double-buffer mode!
         BNE .C17

         STX MODENUM   ;MODE18
         jsr $a954  ;gc
         ;check out of memory situation!!
         lda #$28
         sta $63
         lda #$68
         ldx #$40
         stx BASE
         ;ldy #0
         ;sty $6000
         jmp relocate

.C17     CPX #17
         BNE MODEDONE

MODE17   STX MODENUM
         LDA #$20
         STA BASE
         lda #$d8
         sta $63
         lda #$40
         ldx #$68
         ;ldy #0
         ;sty $4000
         jmp relocate

MODEDONE STX BITMASK
         RTS

write22 inc $22
        bne *+4
        inc $23
        sta ($22),y
        rts

relocate ldy #0
         sta $23
         sta $2c
         stx $3c
         lda $2e
         clc
         adc $63
         sta $2e
         lda $30
         clc
         adc $63
         sta $30
         lda $32
         clc
         adc $63
         sta $32
         sty $3b
         sty $22
         tya
         sta ($22),y
.l2      jsr $ad88
         jsr write22
         jsr $ad88
         beq write22

         clc
         adc $63
         jsr write22
         ldx #2
.l1      jsr $ad88
         jsr write22
         dex
         bne .l1

.l4      jsr $ad88
         php
         jsr write22
         plp
         bne .l4
         beq .l2

;
; BUFFER -- Sets the current drawing buffer to 1 or 2,
;   depending on arg being even or odd.  If double-
;   buffer mode is not enabled then punt.
;
;   Now, buffer=0 swaps draw buffers, even/odd otherwise.
;
BUFFER   JSR GETBYT
         LDA MODENUM
         CMP #18
         BNE .PUNT

         LDY #$20
         TXA
         BNE .CONT

         CPY BASE
         BNE .CONT

         LDA #1
.CONT    LSR
         BCC .LOW         ;even = low buffer

         LDY #$40         ;odd = high buffer
.LOW     STY BASE
.PUNT    RTS

;
; SWAP -- Swap displayed buffers.  MODE 18 must
;   be enabled first.
;
SWAP     LDA MODENUM
         CMP #18
         BNE .PUNT

         lda $ff12
         eor #$18
         sta $ff12
         lda $ff14
         eor #$50
         sta $ff14
         lda $7fb
         eor #$78
         sta $7fb
.PUNT    RTS

;
; ORIGIN -- Set upper-left corner of the screen to
;   new coordinate offset.
;
ORIGIN
         JSR GETBYT
         STX ORGX
         JSR CHKCOM
         JSR GETBYT
         STX ORGY
         RTS

init
    lda #<eob
    sta $2d
    sta $2f
    sta $31
    lda #>eob
    sta $2e
    sta $30
    sta $32
         LDX #5           ;Copy CURRENT vectors
.LOOP3   LDA ICRUNCH,X
         STA OLDCRNCH,X
         DEX
         BPL .LOOP3
    rts

PEND                      ;To get that label right :)


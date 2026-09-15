# BLARG &ndash; Basic Language Graphics extension for the Commodore+4

It is based on [BLARG v1.0 or the Commodore 64](http://www.ffd2.com/fridge/programs/blarg/).

BLARG is a little BASIC extension which adds some new graphics commands to the normal C+4 BASIC.  It is free for use in your own programs, so feel free to do so!

This extension add means to draw lines and circomferences much faster than standard Basic 3.5 statements.  For lines it is about 4 times faster, for circomferences &ndash; about 60 times faster!  It also provides means to use double-buffer mode.

However BLARG means have several limitations.  BLARG assumes that we only use two colors on the whole screen.  BLARG doesn't support multicolor mode.  It can't draw ovals, polygons, arcs like Basic CIRCLE statement.  Its circles slightly differ from standard Basic circles and can't use radii more than 255.

The total size of the program right now is a bit less 2K, and sits at $1001.  To install the program, just load and run.  To re-initialize
the system (after a warm reset for instance) just type SYS4125 but you need to activate hires graphic at first.  If it looks like your machine has completely frozen try pressing RUN-STOP-RESET, then X, then GRAPHIC1:GRAPHIC0:SYS4125.

Several demo programs are included, and offer a good way of learning the commands (for instance, try typing ORIGIN 10,10 before running
MOIRE3).

New statements are added to Basic3.5:

CLEAR \[bg color 0, bg lum 0, bg color 1, fg color 1\] &ndash; clear graphics buffer 1.  If no parameters are used then colors for buffer 0 are applied.

FCOL n &ndash; Fast Color - FCOL 1 sets the drawing color to the foreground color; COLOR 0 sets it to background.

ORIGIN CX, CY &ndash; Sets the upper-left corner of the screen to have oordinates CX,CY.  More precisely, commands will subtract CX,CY from coordinates passed into it.  Among other things, this provides a mechanism for negative numbers to be handled &ndash; LINE -10,0,40,99 will not work, but ORIGIN 10,0:LINE 0,0,50,99 will.

PLOT X,Y &ndash; Sticks a point at coordinates X,Y.  (Actually at coordinates X-XC, Y-YC).  X may be in the range 0..319 and Y may be 0..199; points outside this range will not be plotted.

LINE X1,Y1,X2,Y2 &ndash; Draws a line from X1,Y1 to X2,Y2 (subtracting XC,YC as necessary).  X1 may be any 16-bit value and Y2 may be any 8-bit value.  Coordinates off of the screen will simply not be plotted!

FCIRC XC,YC,R &ndash; Draws a (fast) circumference of radius R centered at XC,YC (translating as necessary).  The algorithm is smart and can	handle R=0..255 correctly (as far as SLJ knows).  BLARG uses a modified version of SLJ's algorithm, which makes very nice circles in SLJ's quite biased opinion, except for a few radii which come out a little ovalish.

MODE n &ndash; New graphics MODE.

* MODE 17 &ndash; Normal mode.  Bitmap->$2000, attributes ->$1800, text screen -> $0800.  It is default.

* MODE 18 &ndash; Double buffer mode.  The additional bitmap (buffer 1) ->$4000, attributes ->$6000.

Any other MODE parameter will be set to the BITMASK parameter.  What is BITMASK?  Anything drawn to the screen is first ANDed with BITMASK.  (Try MODE 85 sometime).

BUFFER n &ndash; Set drawing buffer.  When double-buffer mode is activated (MODE 18), both buffers are available for drawing and displaying.  It is then 	possible to draw in one buffer while displaying the other.  BUFFER n selects which buffer the PLOT, LINE, and CIRCLE commands will affect.  If n=0 then it swaps the target buffer.  Otherwise, n=odd references the buffer at $2000 and n=even selects the buffer at $4000.

SWAP &ndash; Swap displayed buffer.  Assuming MODE18 is selected, SWAP simply selects which buffer is displayed on the screen; specifically, it flips between the two.  SWAP only affects what is displayed on the screen; BUFFER only affects the target of the drawing commands.


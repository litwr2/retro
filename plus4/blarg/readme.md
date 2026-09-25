# BLARG &ndash; Basic Language Graphics extension for the Commodore+4

It is based on [BLARG v1.0 for the Commodore 64](http://www.ffd2.com/fridge/programs/blarg/).

BLARG is a little BASIC extension which adds some new graphics commands to the normal C+4 BASIC.  It is free for use in your own programs, so feel free to do so!

This extension enables you to draw lines and circles much faster than with the standard Basic 3.5 statements.  For lines, it is around four times faster; for circumferences, it is around 60 times faster!  It also enables you to use double-buffer mode.

However BLARG has several limitations.  For example, BLARG assumes that only two colours are used across the entire screen.  It doesn't support multicolour mode.  It cannot draw ovals, polygons or arcs as the Basic CIRCLE statement can.  Its circles differ slightly from standard Basic circles and cannot use radii greater than 255.

The total size of the program right now is a bit less 2K, and sits at $1001.  To install the program, just load and run.  To re-initialize the system (after a warm reset for instance) just type SYS4123 but you need to activate hires graphic at first.  So if it looks like your machine has completely frozen try pressing RESET followed by GRAPHIC1:GRAPHIC0:SYS4123.  Do not use GRAPHIC CLR unless you fully understand the consequences.

Several demo programs are included, and offer a good way of learning the commands (for instance, try typing ORIGIN 10,10 before running MOIRE3).

New statements are added to Basic 3.5:

**CLEAR** \[bg color 0, bg lum 0, bg color 1, fg color 1\] &ndash; clear the current graphics buffer.  If no parameters are specified then colors for buffer 0 are applied.

**FCOL** n &ndash; Fast Color - FCOL 1 sets the drawing color to the foreground color; FCOL 0 sets it to the background.

**ORIGIN** CX, CY &ndash; Sets the upper-left corner of the screen to have coordinates CX,CY.  More precisely, commands will subtract CX,CY from coordinates passed into it.  Among other things, this provides a mechanism for negative numbers to be handled &ndash; LINE -10,0,40,99 will not work, but ORIGIN 10,0:LINE 0,0,50,99 will.  CX is limited to 0..255.

**PLOT** X,Y &ndash; Sticks a point at coordinates X,Y.  (Actually at coordinates X-XC, Y-YC).  X may be in the range 0..319 and Y may be 0..199; points outside this range will not be plotted.

**LINE** X1,Y1,X2,Y2 &ndash; Draws a line from X1,Y1 to X2,Y2 (subtracting XC,YC as necessary).  X1 may be any 16-bit value and Y2 may be any 8-bit value.  Coordinates off of the screen will simply not be plotted!

**FCIRC** XC,YC,R &ndash; Draws a circumference of radius R centered at XC,YC (translating as necessary).  The algorithm is smart and can handle R=0..255 correctly (as far as SLJ knew).  BLARG uses a modified version of SLJ's algorithm, which makes very nice circles in SLJ's quite biased opinion, except for a few radii which come out a little ovalish.

**MODE** n &ndash; New graphics MODE.

* MODE 17 &ndash; Normal mode.  Bitmap &#8594; $2000, attributes &#8594; $1800, text screen &#8594; $0800.  It is default.

* MODE 18 &ndash; Double buffer mode.  The additional bitmap (buffer 1) &#8594; $4000, attributes &#8594; $6000.

Any other MODE parameter will be set to the BITMASK parameter.  What is BITMASK?  Anything drawn to the screen is first ANDed with BITMASK.  (Try MODE 85 sometime).

**BUFFER** n &ndash; Set drawing buffer.  When double-buffer mode is activated (MODE 18), both buffers are available for drawing and displaying.  It is then 	possible to draw in one buffer while displaying the other.  BUFFER n selects which buffer the PLOT, LINE, and CIRCLE commands will affect.  If n=0 then it swaps the target buffer.  Otherwise, n=odd references the buffer at $2000 and n=even selects the buffer at $4000.  So you need BUFFER2 (not BUFFER0) to set buffer 0.

**SWAP** &ndash; Swap displayed buffer.  Assuming MODE18 is selected, SWAP simply selects which buffer is displayed on the screen; specifically, it flips between the two.  SWAP only affects what is displayed on the screen; BUFFER only affects the target of the drawing commands.

The differences from BLARG for the C64:

* use GRAPHIC and COLOR statements instead of GRON and GROFF.  However there are some specific details.  GRAPHIC activates buffer 0 whereas GRON doesn't change the active buffer.  GRAPHIC with the second parameter equals to 1 can be used instead of CLEAR for buffer 0 but CLEAR is slightly (by about 1%) faster;

* MODE17 and MODE18 set the active buffer to 0 and 1 respectively under the C64.  They also make this buffer visual.  Under the C+4 these commands don't affect these settings.  Use BUFFER, GRAPHIC and SWAP explicitly;

* MODE18 doesn't allocate an additional text buffer under the C+4;

* CLEAR has different arguments;

* CIRCLE is replaced with FCIRC, and COLOR is replaced with FCOL.

* The re-initialization of the system doesn't change the origin.

Executables are [here](https://litwr2.github.io/plus4/plus4.html?item=36).


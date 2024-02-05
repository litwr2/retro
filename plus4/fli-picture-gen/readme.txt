Just make your picture in the fligen.c source using the setbmc function that
sets a pixel on the FLI screen that has 160x224 size, 2 free colors
in each 4x2 matrix, and additional 2 free colors for each raster line

On the PAL systems you may use up to 160x280 screen sizes.  However only 256
raster lines are visible on the old monitors

If you have the out.prg file you don't need to compile svn.asm.

For the assembly programming the next functions are provided.

tobasic - return to Basic, after the call to this function you can call other functions, for example to print characters or check the keyboard status.  The actual return to Basic happens when the RTS instruction will be executed, for instance

    jsr tobasic
    lda #$a1
    jsr $ffd2
    rts

setp - set a pixel.  The X register must contain the X coordinate, the Y register must contain the lower byte of the Y coordinate, the high byte must be in $d8.  However if the screen height is less than or equal to 256 then the high byte is ignored.  The screen size is set by the VSIZE variable in the svn.asm source file.  The A register must contain the color source.  There are 4 color sources available:
0 - multicolor 1
1 - the background color
2 - the foreground color
3 - multicolor 2

seta - set attributes.  The X register must contain the X coordinate, the Y register must contain the lower byte of the Y coordinate, the high byte must be in $d8.  If the screen height is less than or equal to 256 then the high byte is ignored.  The A register must contain the color source.  The $d9 memory location must contain the color code, for example, $05 for the darkgreen.  If the multicolor is set then the X coordinate is ignored because the C+4 hardware allows us to use only 2 multicolors per line.  If the background or foreground color is set then the change applies to the whole 4x2 matrix.  So, for instance pixels on the coordinates in range (0,0)-(3,1) have the same background or foreground color.

The 50/60 Hz timer is available on memory locations $a4-$a5, $a5 is the low byte.  The frequency is set by the PAL or NTSC hardware.

The memory location $d4 contains the vertical scrolling value.  The positive number means scrolling down while the negative scrolling up.  Put a value there and the screen will scroll once.  The scrolling action also sets this value to 0.

The library routines use memory locations in range $d0-$d7, don't use these addresses.


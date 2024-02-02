Just make your picture in the fligen.c source using the setbmc function that
sets a pixel on the FLI screen that has 160x224 size, 2 free colors
in each 4x2 matrix, and additional 2 free colors for each raster line

On the PAL systems you may use up to 160x280 screen sizes.  However only 256
raster lines are visible on the old monitors

If you have the out.prg file you don't need to compile svn.asm

This program converts an image in the PPM (type P6) format into the PRG-file for the C+4 and the PPM-file containing the equivalent of the image generated on the C+4 screen.

This program can be used to convert images that have sizes up to 160x280.  The height must be a multiple of 8 in range from 208 to 280.  For the NTSC systems the maximum height is 224.  Some PAL monitors cannot display more than 256 lines.  The width must be a multiple of 4.

The C+4 hardware allows us to have only 2 free colors in the 4x2 matrix and 2 additional free colors per raster line.  So in a 160 pixel line we can have up to 82 different colors but the next line must use 80 colors from the previous line and 2 arbitrary colors.  This limitation actually only applies to the even line and the next odd line.  The even line that follows the odd is completely free to use any set of 82 colors.

This program doesn't do any preprocessing: scaling, dithering, color substitution, ...  You have to prepare your image with your favorite graphic editor.  So you have to set the proper size and palette for your image.  The program simply converts it into the form that can be accepted by your +4.

First you need to scale your image.  Then do some optional pre-processing, such as increasing the luminance and saturation of the image.  This step is often useful because the C+4 palette tends to be light rather than dark.  Then you need to apply the standard C+4 palette to your image.  The GIMP editor can do this very easily.  The last step is to save the image in PPM (binary) format.  The saved file may be converted by the program.

There is a special case for image preprocessing.  The C+4 hardware allows us to use all colors freely if we use the large pixels, which are a 2x2 matrix of the normal pixels.  This allows us to have up to 80x140 pixel images where each pixel can have any color.  To get such an image you need to scale your image to the right size, then make the image 2 times bigger without any interpolation.  Then apply the palette and save the result.

This program has some useful features:
1) the generated images don't flicker on the C+4 screen;
2) the generated images can have the maximum size allowed by the C+4 hardware;
3) it is an open source software that suggests code modification by the end users.

Just compile mc-pic-cnv.cpp and call it with two parameters.  The first parameter is the name of the input file, the second is the name of the output file.  You also need to have the file out.prg in the current directory.  This file is the result of compiling the svn.asm file.  The resulting file for the C+4 has name out1.prg.


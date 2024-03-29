This program converts an image in the PPM (type P6) format into the PRG-file for the C+4 and the PPM-file containing the equivalent of the image generated on the C+4 screen.

The program can be used to convert images that have sizes up to 160x280.  The height must be a multiple of 8 in the range from 200 to 280.  For the NTSC systems the maximum height is 224.  Some PAL monitors cannot display more than 256 lines.  The width must be a multiple of 4.

The C+4 hardware allows us to have only 2 free colors in the 4x2 matrix and 2 additional free colors per raster line.  So in a 160 pixel line we can have up to 82 different colors but the next line is limited to the 80 colors from the previous line and 2 arbitrary colors.  This limitation actually only applies to the even line and the next odd line.  The even line following the odd line is completely free to use any set of 82 colors.

This program doesn't do any preprocessing: scaling, dithering, color substitution, ...  You have to prepare your image with your favorite graphic editor.  So you have to set the proper size and palette for your image.  The program simply converts it into the form that can be accepted by your +4.

First you need to scale your image.  Then do some optional pre-processing, such as increasing the luminance and saturation of the image.  This step is often useful because the C+4 palette tends to be light rather than dark.  Then you need to apply the standard C+4 palette (you can get it from any C+4 screenshot or [there](https://litwr2.github.io/plus4/plus4-palette.html)) to your image.  The GIMP editor can do this very easily.  The last step is to save the image in the PPM (binary) format.  The saved file may be converted by the program.

There is a special case for image preprocessing.  The C+4 hardware allows us to use all colors freely if we use the large pixels, which are a 2x2 matrix of the normal pixels.  This allows us to have up to 80x140 pixel images where each pixel can have any color.  To get such an image you need to scale your image to the proper size, then make the image 2 times bigger without any interpolation.  Then apply the palette.  Now you can optionally superimpose two arbitrary colors on each line.  The final step is to save the result.

This program has several useful features:

1. the generated images don't flicker on the C+4 screen;
2. the generated images can have the maximum size allowed by the C+4 hardware;
3. it generates the preview images;
4. it is easy to compile open source software that encourages code modification by the end users.

Just compile **flic.cpp** and call it with two parameters.  The first parameter is the name of the input file, the second is the name of the output preview file.  The second parameter may be equal to the first.  You also need to have the file **out.prg** in the current directory.  This file is the result of compiling the **svn.asm** file.  The resulting files for the C+4 have names **out-2.prg**, **out-1.prg**, **out+0.prg**, **out+1.prg**, and **out+2.prg**.  So the program generates five images, choose the best one.  These images differ only in the horizontal offset, which is set between -2 and 2.

To convert images to/from the PPM format many tools can be used, such as the Image Magick **convert** or GIMP.


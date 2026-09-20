# fast routines to draw lines for the C+4

The routines require approximately 75-130 CPU cycles per pixel.  This delivers approximately 8700-15800 pixels per second on the C+4.

The repo contains Basic programs that implement the same algos as the 'test1' tests in assembly.  Let's check the benchmark results in 1/60s on the C+4 PAL.

Mode       |Basic   |Basic compiled by Austrospeed|[BLARG+4](https://github.com/litwr2/retro/tree/main/plus4/blarg)|Assembly
-----------|-------:|----------------------------:|------:|-------:
HiRes      |3223    |3213                         |827    |498
Multicolor |1508    |1503                         |-      |207

BLARG doesn't change attributes so its result for true comparison must be about 15% slower.

The code size is 598(hr)/591(mc) bytes.


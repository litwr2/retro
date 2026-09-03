# fast routines to draw lines for the C+4

The routines require approximately 95-125 CPU cycles per pixel.  This delivers approximately 9100-12000 pixels per second on the C+4.

The repo contains Basic programs that implement the same algos as the 'test1' tests in assembly.  Let's check the benchmark results in 1/60s on the C+4 PAL.

Mode       |Basic   |Basic compiled by Austrospeed|Assembly
-----------|-------:|----------------------------:|-------:
HiRes      |3444    |3045                         |582
Multicolor |1617    |1421                         |249

The code size is 613(hr)/617(mc) bytes +30 bytes for the multiplication routine.



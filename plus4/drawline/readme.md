# fast routines to draw lines for the C+4

The routines require approximately 210(hr)/220(mc) CPU cycles per pixel.  This delivers approximately 5480(hr)/5140(mc) pixels per second on the C+4.

The repo contains Basic programs that implement the same algos as the 'test1' tests in assembly.  Let's check the benchmark results.

Mode       |Basic   |Basic compiled by Austrospeed|Assembly
-----------|-------:|----------------------------:|-------:
HiRes      |3444    |3045                         |958
Multicolor |1617    |1421                         |395

The code size is 545(hr)/544(mc) bytes +30 bytes for the multiplication routine.


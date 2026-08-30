# fast routines to draw lines for the C+4

The routines require approximately 120(hr)/125(mc) CPU cycles per pixel.  This delivers approximately 9500(hr)/9200(mc) pixels per second on the C+4.

The repo contains Basic programs that implement the same algos as the 'test1' tests in assembly.  Let's check the benchmark results.

Mode       |Basic   |Basic compiled by Austrospeed|Assembly
-----------|-------:|----------------------------:|-------:
HiRes      |3444    |3045                         |678
Multicolor |1617    |1421                         |295

The code size is 611(hr)/616(mc) bytes +30 bytes for the multiplication routine.


# fast routines to draw lines for the C+4

The routines require approximately 95-125 CPU cycles per pixel.  This delivers approximately 9100-12000 pixels per second on the C+4.

The repo contains Basic programs that implement the same algos as the 'test1' tests in assembly.  Let's check the benchmark results in 1/60s on the C+4 PAL.

Mode       |Basic   |Basic compiled by Austrospeed|[BLARG+4](https://github.com/litwr2/retro/tree/main/plus4/blarg)|Assembly
-----------|-------:|----------------------------:|------:|-------:
HiRes      |3223    |3213                         |827    |581
Multicolor |1508    |1503                         |-      |246

The code size is 631(hr)/628(mc) bytes.

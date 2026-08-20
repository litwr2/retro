# fast routines to draw lines for the C+4

They can easily be adapted for use with the C64/128.  The changes required are tiny for hires and minimal for multicolor.

Perhaps they are the fastest routines for drawing lines for the 6502 and Commodore bitmap graphics.  They require approximately 210(hr)/280 (mc) CPU cycles per pixel.  This delivers approximately 5460(hr)/4100 (mc) pixels per second on the C+4.  It is doubtful that routines faster than 5% are possible for this task.  There have been programs that use algos with similar performance.

The repo contains Basic programs that implement the same algos as the 'test1' tests in assembly.  Let's check the benchmark results.

Mode       |Basic   |Basic compiled by Austrospeed|Assembly
-----------|-------:|----------------------------:|-------:
HiRes      |3452    |3053                         |972
Multicolor |1625    |1427                         |398

The code size is 589(hr)/600(mc) bytes +30 bytes for the multiplication routine.


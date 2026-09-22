# fast routines to draw lines for the C+4

The routines require approximately 75-130 CPU cycles per pixel.  This delivers approximately 8700-15800 pixels per second on the C+4.

The repo contains Basic programs that implement the same algos as the 'test1' tests in assembly.  Let's check the benchmark results in 1/60s on the C+4 PAL.

Mode       |Basic   |Basic compiled by Austrospeed|[BLARG+4](https://github.com/litwr2/retro/tree/main/plus4/blarg)|Assembly
-----------|-------:|----------------------------:|------:|-------:
HiRes      |3223/-  |3213/-                       |-/827  |466/375
Multicolor |1508/-  |1503/-                       |-/-    |200/164

The timer value before the slash corresponds to cases where attributes are drawn. The timer value after the slash corresponds to cases where attributes are not drawn.

The code size is 608/432 bytes for HR graphics and 595/409 bytes for MC graphics.


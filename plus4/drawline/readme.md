# fast routines to draw lines for the C+4

The routines require approximately 75-130 CPU cycles per pixel.  This delivers approximately 8700-15800 pixels per second on the C+4.

The repo contains Basic programs that implement the same algos as the 'test1' tests in assembly.  Let's check the benchmark results in 1/60s on the C+4 PAL.

Mode       |Basic   |Basic compiled by Austrospeed|[BLARG+4](https://github.com/litwr2/retro/tree/main/plus4/blarg)|Assembly
-----------|-------:|----------------------------:|------:|-------:
HiRes      |3223/-  |3213/-                       |-/827  |452/361
Multicolor |1508/-  |1503/-                       |-/-    |194/158

The timer value before the slash corresponds to cases where attributes are drawn. The timer value after the slash corresponds to cases where attributes are not drawn.

Let's also run the moire pattern benchmark.

Tool                          |Timings
------------------------------|--------
Basic                         |4627/-
Basic compiled by Austrospeed |4610/-
BLARG+4                       |-/1124
Assembly                      |712/575

The library code size is below 650/470 bytes for HR graphics and below 620/430 bytes for MC graphics.

The library provides functions:

* **drawhline** (hr) with the next parameters located at zero page x0 - 3/4, y0 - $42, x1 - $bc/$bd, y1 - $15, cs - $66;

* **drawmline** (mc) with the next parameters x0 - 3, y0 - $42, x1 - $bc, y1 - $15, cs - $66.

For the first function there are three options: 

* *ROM8table* - 0 means to use the table in RAM, this takes 8 bytes.  If you program doesn't block access to ROM use an address from the list provided in sources, this saves these 8 bytes;

* *usehrattr* - 0 means to draw only on bitmap, 1 means to set up color attributes too;

* *hrcoorcheck* - 0 means doesn't check if the coordinates are more than the screen capacity, 1 means to cut such coordinates.  However the negative values for coordinates may cause problems.

The second function has similar options:

* *ROM4table* - can help you save 4 bytes if *usemcattr* = 1;

* *usemcattr* - if you don't use cs = 1 and cs = 2 then 0 doesn't reduce any functionality;

* *mccoorcheck*.

If you get the WRONG ALIGNMENT error during compilation try moving the library code.  You may just shuffle library elements.  Anyway the allocation on the page boundary must work.


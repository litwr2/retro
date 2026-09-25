# fast routines to draw lines for the C+4

The routines require approximately 55-100 CPU cycles per pixel.  This delivers approximately 11500-21000 pixels per second on the C+4.

The repo contains Basic programs that implement the same algos as the 'test1' tests in assembly.  Let's check the benchmark results in 1/60s on the C+4 PAL.

Mode       |Basic   |Basic compiled by Austrospeed|[BLARG+4](https://github.com/litwr2/retro/tree/main/plus4/blarg)|Fastlines
-----------|-------:|----------------------------:|------:|-------:
HiRes      |3223/-  |3213/-                       |-/827  |444/355
Multicolor |1508/-  |1503/-                       |-/-    |179/144

The timer value before the slash corresponds to cases where color attributes are drawn.  The timer value after the slash corresponds to cases where the attributes are not drawn.

Let's also run the moire pattern benchmark.

Graphic Subsystem             |Timings
------------------------------|--------:
Basic                         |4627/-
Basic compiled by Austrospeed |4610/-
BLARG+4                       |-/1124
Fastlines                     |687/551

The library code size is below 610/430 bytes for HR graphics and below 570/380 bytes for MC graphics.

The library provides functions:

* **drawhrline** with the next parameters located at zero page x0 - 3/4, y0 - $42, x1 - $bc/$bd, y1 - $15, cs - $66; all arguments but y0 and cs are preserved;

* **drawmcline** with the next parameters x0 - 3, y0 - $42, x1 - $bc, y1 - $15, cs - $66; all arguments but cs are preserved.

For the first function there are five options: 

* *ROM8table* - 0 means to use the table in RAM, this takes 8 bytes.  If you program doesn't block access to ROM use an address from the list provided in sources, this saves these 8 bytes;

* *usehrattr* - 0 means to draw only on bitmap, 1 means to set up color attributes too;

* *hrcoorcheck* - 0 means doesn't check if the coordinates are more than the screen capacity, 1 means to cut such coordinates.  However the negative values for coordinates may cause problems;

* *reduce1hr* and *reduce2hr*, if either value is set to 1 then the code is shortened by 10 bytes.  Two 1s shorten it by 20 bytes.  However this doesn't always work.  If you get a compilation error you can change the values to zero or try to shuffle your code parts.

The second function has similar options:

* *ROM4table* - can help you save 4 bytes if *usemcattr* = 1;

* *usemcattr* - if you don't use cs = 1 and cs = 2 then 0 doesn't reduce any functionality;

* *mccoorcheck*;

* *reduce1mc* and *reduce2mc*.

There are also two identical functions that initialize the graphic subsystem: **hrinit** and **mcinit** &ndash; use the first for HR graphics and the second for MC graphics.

All zero page locations used by the library are listed in sources.


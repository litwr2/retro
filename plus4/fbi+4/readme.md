# Faster Basic Interpreter +4
## version 2

Why is the Commodore 264 series so slow when using BASIC?  It's because almost all the RAM is provided for Basic programming.  Computers with faster BASICs (such as the BBC Micro or the Amstrad CPC) have much less RAM allocated to this purpose.  Can we make the Plus/4 or the C16/116 (with 64 KB of RAM) faster in the same way?  Indeed we can!  This FBI+4 utility speeds up your Basic programs by 5–35%, but leaves only 28 KB for code.  The program simply copies the ROM to the RAM and patches the system code.  This allows us to easily fix bugs in the C+4, optimise the firmware and add new features, as well as increasing the size of the available RAM for Basic and accelerating Basic further (faster graphics, I/O, etc).  Just run it and then use your system as usual.

Version 2 optimizes one more system call that gives a slight (hard to notice) speed boost.  It also resolves all known ROM bugs:

* [RS-232C #1](https://archive.org/details/YourCommodoreIssue35Aug87/page/n77/mode/2up) - Your Commodore 8/1987 pages 78-84;
* [RS-232C #2](https://plus4world.powweb.com/forum/45313#post21);
* [28FF](https://plus4world.powweb.com/forum/45313#post27), [more details](https://plus4world.powweb.com/plus4encyclopedia/500015);
* [DS](https://plus4world.powweb.com/plus4encyclopedia/500292);
* [Multiply](https://www.c64-wiki.com/wiki/Multiply_bug) - it is fixed in the same way as on the C128, but this slows down some mathematical ops by a few percent.  If you don't want this fix, use two pokes: POKE41104,169:POKE41119,169 - this makes the performance slightly above v1. 

This version modifies the system initial message and let us use the reset switch.

The results of several benchmarks are below.

Benchmark | Speedup
----------|--------:
[Rugg/Feldman #1](https://en.wikipedia.org/wiki/Rugg/Feldman_benchmarks#Benchmark_1) | 26.14%
[Rugg/Feldman #2](https://en.wikipedia.org/wiki/Rugg/Feldman_benchmarks#Benchmark_2) | 15.64%
[Rugg/Feldman #3](https://en.wikipedia.org/wiki/Rugg/Feldman_benchmarks#Benchmark_3) | 13.81%
[Rugg/Feldman #4](https://en.wikipedia.org/wiki/Rugg/Feldman_benchmarks#Benchmark_4) |  8.56%
[Rugg/Feldman #5](https://en.wikipedia.org/wiki/Rugg/Feldman_benchmarks#Benchmark_5) | 11.86%
[Rugg/Feldman #6](https://en.wikipedia.org/wiki/Rugg/Feldman_benchmarks#Benchmark_6) |    17%
[Rugg/Feldman #7](https://en.wikipedia.org/wiki/Rugg/Feldman_benchmarks#Benchmark_7) | 18.95%
[Rugg/Feldman #8](https://en.wikipedia.org/wiki/Rugg/Feldman_benchmarks#Benchmark_8) |  2.24%
[ASCII Mandelbrot](https://gitlab.com/retroabandon/bascode/-/blob/master/generic/mandel.bas) | 32.84%
[Basic Mandelbrot](https://github.com/litwr2/basic-mandelbrot/blob/main/commodore%2B4.bas) | 14.14%

The prg-file is [here](https://litwr2.github.io/plus4/plus4.html?item=24).

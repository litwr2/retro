# Faster Basic Interpreter +4

Why is the Commodore 264 series so slow when using BASIC?  It's because almost all the RAM is provided for Basic programming.  Computers with faster BASICs (such as the BBC Micro or the Amstrad CPC) have much less RAM allocated to this purpose.  Can we make the Plus/4 or the C16/116 (with 64 KB of RAM) faster in the same way?  Indeed we can!  This FBI+4 utility speeds up your Basic programs by 5–35%, but leaves only 28 KB for code.  The program simply copies the ROM to the RAM and patches the system code.  This allows us to easily fix bugs in the C+4, optimise the firmware and add new features, as well as increasing the size of the available RAM for Basic and accelerating Basic further (faster graphics, I/O, etc).  Just run it and then use your system as usual.

The results of several benchmarks are below.

Benchmark | Speedup
----------|--------:
[Rugg/Feldman #1](https://en.wikipedia.org/wiki/Rugg/Feldman_benchmarks#Benchmark_1) | 26.14%
[Rugg/Feldman #2](https://en.wikipedia.org/wiki/Rugg/Feldman_benchmarks#Benchmark_2) | 15.64%
[Rugg/Feldman #3](https://en.wikipedia.org/wiki/Rugg/Feldman_benchmarks#Benchmark_3) | 15.33%
[Rugg/Feldman #4](https://en.wikipedia.org/wiki/Rugg/Feldman_benchmarks#Benchmark_4) | 10.55%
[Rugg/Feldman #5](https://en.wikipedia.org/wiki/Rugg/Feldman_benchmarks#Benchmark_5) | 13.73%
[Rugg/Feldman #6](https://en.wikipedia.org/wiki/Rugg/Feldman_benchmarks#Benchmark_6) | 18.17%
[Rugg/Feldman #7](https://en.wikipedia.org/wiki/Rugg/Feldman_benchmarks#Benchmark_7) | 19.70%
[Rugg/Feldman #8](https://en.wikipedia.org/wiki/Rugg/Feldman_benchmarks#Benchmark_8) |  3.65%
[ASCII Mandelbrot](https://gitlab.com/retroabandon/bascode/-/blob/master/generic/mandel.bas) | 34.46%
[Basic Mandelbrot](https://github.com/litwr2/basic-mandelbrot/blob/main/commodore%2B4.bas) |    17%

The prg-file is [here](https://litwr2.github.io/plus4/plus4.html?item=24).

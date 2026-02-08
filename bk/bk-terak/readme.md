This folder contains patched files for [bk-terak-emu](https://sourceforge.net/p/bk-terak-emu/cvs/).  These add several new features:
* a fullthrottle mode toggle key;
* a Tcl-widget for faster loading of bin-files.

They also impose several modifications:
* the Left Windows key is replaced with the Right Windows key (some keyboards just lack the former);
* the default ROM path is changed to `/usr/local/share/games/bk`;
* the directory for the `bindtextdomain` function is changed to `/usr/share/locale`;
* the debugger works with hexadecimals.

It is easy to change the directory locations by editing the file `main.c`.  Simply replace the original files with the patched ones, compile the sources and install the executable.  Then move the Tcl script to the same directory as the executable.  The script requires Tcl/Tk to be present on your system.  The file `kbdinfo.txt` contains information about the keyboard layout.

All the changes are minimal and can be easily reverted.


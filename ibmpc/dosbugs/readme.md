# DOS Bugs

I've encountered several problems while working with FreeDOS. I caught two tricky bugs. They don't break any documentation standards, but MS-DOS and, in one case, DR-DOS can successfully manage them. FreeDOS and the other DOSes I've tested hang the computer in these two cases.

## Bug 1

FreeDOS cannot terminate a program using INT 20H or DOS Fn 4cH if the data at offset 16h (the segment of the parent's PSP) in its PSP is invalid. Microsoft has not documented this data.  MS-DOS versions 5.00, 6.00, 6.22 and 7.xx, as well as DR-DOS version 7.03, do not have this problem.  PTS-DOS 32 crashes in the same way as FreeDOS.

The small program TSRERR.ASM can demonstrate the described incompatibility.  This program installs a TSR containing 267 zeros without PSP.  Proper execution of TSRERR.COM reduces the conventional memory size by 272 bytes.  Deleting the commented semicolons at the beginning of lines 48 and 49 will enable TSRERR to run without errors under FreeDOS and PTS-DOS.

## Bug 2

I reprogrammed the timer hardware to generate an IRQ0 at 37 kHz.  I also intercepted interrupts 9 (IRQ1, keyboard) and 8 (IRQ0).

The IRQERR.COM program can demonstrate the problem (type FASM IRQERR.ASM to compile the source code).  While it is running, pressing any key on the keyboard causes the scancode of that key to be displayed in the top left corner of the screen.  Press Esc to exit the program.

Make any key stick in the pressed state.  After some short delay, this will produce beeps to signal the DOS keyboard buffer overflow.  With MS-DOS (versions 5.00, 6.00, 6.22 and 7.xx), I can hold down any key for any period of time without encountering any problems.  With any other tested DOS (Free, DR 7/8, PTS), the system will crash after several seconds.  MS-DOS 8 crashed too.  However, neither MS-DOS 8 nor FreeDOS (nor any other DOS!) crashed when used under VirtualBox!  Neither did DOSbox.

This crash was caused by the PIC (Programmable Interrupt Controller) 8259, the bits of which corresponded to IRQ1 in IRR (Interrupt Request Register) and IMR (Interrupt Mask Register) are sometimes remain set after the end of interrupt 9.  The IRQERRX.COM program can demonstrate this.  These set bits prevent interrupt 9 from occurring and therefore lock the keyboard.

I resolved this problem by using IMR in my interrupt 9 handler.  I mask IRQ 0 before calling the system keyboard handler, which I call using CALL FAR, and then I restore the IMR.  However, this "solution" raises a new question about the stability of IRQs with a priority of less than 1 (COM1, COM2, FDD, etc.).

I can only suppose that the problem may be in
>  MOV AL,20H<br>
>  OUT 20H,AL

command sequence in the end of each (?) hardware interrupt.  This sequence is the command to the PIC which must clear the set bit in the ISR (In-Service Register) with the largest IRQ priority.  Maybe it is connected with Special Mask Mode (SMM)...

I may be wrong about the details, but I'm pretty sure that IRQERR.COM crashes FreeDOS and other DOSes, but not MS-DOS.

I tested this problem on several PCs, including ones based on 486DX4@120MHz, Pentium@90MHz, Celeron@766MHz and AMD-Phenom@&#8203;3.2GHz, among others.

### Test results on the IBM PC compatible computers

Developer       |DOS name, VER                         | Comments|DOS Fn 30h | Year | Status
---------------:|-------------------------------------:|--------:|----------:|-----:|-------:
Microsoft       |MS-DOS Version 3.30                   |         | 3.30      | 1987 | +
Microsoft       |MS-DOS Version 5.00                   |         | 5.00      | 1991 | +
Microsoft       |MS-DOS Version 6.22                   |         | 6.22      | 1994 | +
Microsoft       |Windows 98 [Version 4.10.2222]        |         | 7.10      | 1999 | +
Microsoft       |Windows Millenium [Version 4.90.3000] |         | 8.00      | 1999 | -
IBM             |PC DOS Version 7.00 Rev 0             | 1995    | 7.00      | 1995 | +
IBM             |PC DOS Version 7.00 Rev 1             | 2000    | 7.00      | 1995 | +
IBM             |PC DOS Version 7.1 Rev 0              |         | 7.10      | 2003 | +
Digital research|DR DOS 5.00                           |         | 3.31      | 1990 | -
Caldera         |Caldera DR DOS 7.03                   |         | 6.00      | 1998 | -
DeviceLogics    |DeviceLogics DR DOS 8.00              |         | 6.00      | 2004 | -
DrDOS, Inc. Lindon,<br>Utah 84042 |DrDOS 8.1                             | DR DOS  | 6.00       | 2005 | -
Физтех-софт     |Версия PTS-DOS 6.70                   |         | 6.70      | 1998 | -
Paragon         |DOS Version 7.01 Rev 9                | PTS-DOS | 7.01      | 2000 | -
GNU             |FreeDOS kernel version 1.1.35         |         | 7.10      | 2004 | -
GNU             |FreeDOS kernel 2043                   |         | 7.10      | 2021 | -

**+** means no bug, **-** means the bug crashes DOS.

## Appendix

All examples were written for the FASM assembler.  Different kernel versions of FreeDOS were used for tests.


Overheating
When the maximum acceleration is installed by 23 extra lines the CPU effective frequency is approximately at 1.27 MHz and this value is much lower than the effective CPU frequency with the blank screen.  So there is no danger of the CPU overheating.  Only the TED gets some overclocking, around 6.39%, when all the extra lines are used.  In this case the TED frequency is approximately 952.2 KHz and this is below the industry limit of 1 MHz for this chip.  So the possibility of overheating is minimal.

Interrupts
The driver uses an interrupt handler chain and redefines the vector at $314.  You can install your own interrupt handler by adding it to this chain, but it must use the raster interrupt only.

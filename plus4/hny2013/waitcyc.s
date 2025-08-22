cyc    .macro
       ;STY $FF19
       ;STX $FF19
       .repeat \1, $8c, $19, $ff, $8e, $19, $ff
       .endm

cycx   .macro
       ;STX $FF19
       ;STY $FF19
       .repeat \1, $8e, $19, $ff, $8c, $19, $ff
       .endm

hcycb  .macro
       ;STX $FF19
       .repeat \1, $8e, $19, $ff
       .endm

wait2  .macro
       nop
       .endm

wait3  .macro
       cmp $d0
       .endm

wait4  .macro
       cmp $d0,x
       .endm

wait8  .macro
       #wait4
       #wait4
       .endm

wait12 .macro
       #wait8
       #wait4
       .endm

wait24 .macro
       #wait12
       #wait12
       .endm


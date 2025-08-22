                   cyc    .macro
                          STY $FF19
                          STX $FF19
                          .endm

                   cyc2   .macro
                          #cyc
                          #cyc
                          .endm

                   cyc4   .macro
                          #cyc2
                          #cyc2
                          .endm

                   cyc8   .macro
                          #cyc4
                          #cyc4
                          .endm

                   cycx   .macro
                          STX $FF19
                          STY $FF19
                          .endm

                   cyc2x   .macro
                          #cycx
                          #cycx
                          .endm

                   cyc4x   .macro
                          #cyc2x
                          #cyc2x
                          .endm

                   cyc8x   .macro
                          #cyc4x
                          #cyc4x
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


                   line2c .macro   ;infinine, doesn't allow v-sync
                   l1     STX $FF19
                          #cyc
                          #cyc4
                          #cyc4
                          STY $FF19
                          sta $ff1e
                          STX $FF19
                          #cyc
                          #cyc2
                          #cyc
                          #wait12
                          #wait4
                           jmp l1
                          .endm

                   line2o .macro   ;open, needs 7 cycs
                   l1     STX $FF19
                          #cyc
                          #cyc4
                          #cyc4
                          STY $FF19
                          sta $ff1e
                          STX $FF19
                          #cyc
                          #cyc2
                          #cyc
                          #wait12
                          ;#wait4
                          .endm

                   line2i .macro
                          STX $FF19
                          #cyc
                          #cyc4
                          #cyc4
                          STY $FF19
                          sta $ff1e
                          STX $FF19
                          #cyc
                          #cyc2
                          #cyc
                          #wait8
                          iny
                          inx
                          #wait4
                          #wait3
                          .endm

                   line2  .macro
                          STX $FF19
                          #cyc
                          #cyc4
                          #cyc4
                          STY $FF19
                          sta $ff1e
                          STX $FF19
                          #cyc
                          #cyc2
                          #cyc
                          #wait12
                          #wait4
                          #wait3
                          .endm

                   line2cb  .macro  ;base for the codes
                          #wait24
                          #wait24
                          #wait24
                          #wait8
                          sta $ff1e
                          #wait24
                          #wait24
                          #wait4
                          #wait3
                          .endm

                   line2x .macro
                          STY $FF19
                          #cycx
                          #cyc4x
                          #cyc4x
                          STX $FF19
                          sta $ff1e
                          STY $FF19
                          #cycx
                          #cyc2x
                          #cycx
                          #wait12
                          #wait4
                          #wait3
                          .endm

                   line2m .macro
                   l1     STA $FF19
                          STY $FF19
                          STA $FF19
                          #cyc4
                          #cyc4
                          STA $FF19
                          sta $ff1e
                          STY $FF19
                          STX $FF19
                          STA $FF19
                          #cyc2
                          STY $FF19
                          STA $FF19
                          #wait12
                          #wait4
                          #wait3
                          .endm

                   line3  .macro
                          ldy #15
                   pcl   .var <*
                         .if pcl/$fd
                   v1    .var 1
                          cmp $1500
                         .endif
                   c1     dey
                          bne c1
                         .ifndef v1
                          cmp $1500
                         .endif
                          sta $ff1e
                          ldy #10
                   pcl   .var <*
                         .if pcl/$fd
                   v2     .var 1
                          cmp $1500
                         .endif
                   c2     dey
                          bne c2
                         .ifndef v2
                          cmp $1500
                         .endif
                         .endm

                   line3s .macro
                          sty $d1
                          nop
                          ldy #14
                   pcl   .var <*
                         .if pcl/$fd
                   v1    .var 1
                          cmp $1500
                         .endif
                   c1     dey
                          bne c1
                          nop
                         .ifndef v1
                          nop
                         .endif
                          sta $ff1e
                          lda $ff1d
                          sec
                          sbc #50
                          sta $ff1d
                          ldy #7
                   pcl   .var <*
                         .ifeq pcl/$fe
                   v2    .var 1
                          LDA #(255-cval).3
                         .endif
                   c2     dey
                          bne c2
                         .ifndef v2
                          LDA #(255-cval).3
                         .endif
                          ldy $d1
                          nop
                          .endm

                   line3sx .macro
                          #wait24
                          #wait24
                          #wait24
                          #wait8
                          sta $ff1e
                          lda $ff1d
                          sec
                          sbc #50
                          sta $ff1d
                          LDA #(255-cval).3
                          #wait24
                          #wait12
                          #wait2
                          #wait3
                          .endm

                   line2_2 .macro
                          #line2
                          #line2
                          .endm

                   line2_4 .macro
                          #line2_2
                          #line2_2
                          .endm

                   line2_8 .macro
                          #line2_4
                          #line2_4
                          .endm

                   line2_16 .macro
                          #line2_8
                          #line2_8
                          .endm

                   line2_32 .macro
                          #line2_16
                          #line2_16
                          .endm

                   line2_64 .macro
                          #line2_32
                          #line2_32
                          .endm

                   line2_128 .macro
                          #line2_64
                          #line2_64
                          .endm

                   line2_2y .macro
                          #line2
                          #line2x
                          .endm

                   line2_4y .macro
                          #line2_2y
                          #line2_2y
                          .endm

                   line2_8y .macro
                          #line2_4y
                          #line2_4y
                          .endm

                   line2_16y .macro
                          #line2_8y
                          #line2_8y
                          .endm

                   line2_32y .macro
                          #line2_16y
                          #line2_16y
                          .endm

                   line2_64y .macro
                          #line2_32y
                          #line2_32y
                          .endm

                   line2_128y .macro
                          #line2_64y
                          #line2_64y
                          .endm

line3_2 .macro
       #line3
       #line3
       .endm

line3_4 .macro
       #line3_2
       #line3_2
       .endm

line3_8 .macro
       #line3_4
       #line3_2
       #line3
       #line2
       .endm

line3_16 .macro
       #line3_8
       #line3_8
       .endm

line3_32 .macro
       #line3_16
       #line3_16
       .endm

line3_64 .macro
       #line3_32
       #line3_32
       .endm

line3_128 .macro
       #line3_64
       #line3_64
       .endm

line2cx .macro
l1     stx $ff1e
       sta $ff19
       #cyc
       #cyc2
       #cyc4
       STA $FF19
       sta $ff1e
       STX $FF19
       #cyc2
       #cyc4
       #wait12
       jmp l1
       .endm


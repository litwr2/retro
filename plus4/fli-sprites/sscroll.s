     macro assign2,bau,p
     lda \bau+1104+\p*40,x
     sta \bau+1024+\p*40,x
     lda \bau+80+\p*40,x
     sta \bau+\p*40,x
     endm
     macro assign3,bau,bal,p
     lda \bal+1104+\p*40,x
     sta \bau+1024+\p*40,x
     lda \bal+80+\p*40,x
     sta \bau+\p*40,x
     endm
     macro assigny,bau,bal
     ldx #39
.l\@ lda \bau,x
     sta .slu0\@+1
     lda \bau+$400,x
     sta .sco0\@+1
     lda \bau+40,x
     sta .slu1\@+1
     lda \bau+$428,x
     sta .sco1\@+1
     assign2 \bau,0
     assign2 \bau,1
     assign2 \bau,2
     assign2 \bau,3
     assign2 \bau,4
     assign2 \bau,5
     assign2 \bau,6
     assign2 \bau,7
     assign2 \bau,8
     assign2 \bau,9
     assign2 \bau,10
     assign2 \bau,11
     assign2 \bau,12
     assign2 \bau,13
     assign2 \bau,14
     assign2 \bau,15
     assign2 \bau,16
     assign2 \bau,17
     assign2 \bau,18
     assign2 \bau,19
     assign2 \bau,20
     assign2 \bau,21
     assign3 \bau,\bal,22
     assign3 \bal,\bal-$400,24
     cpx #24
     bcs .l1\@

     assign3 \bau,\bal,23
     assign3 \bal,\bal-$400,25
     bcc .l2\@  ;always
.l1\@
     assign3 \bau,\bal-$400,23
     assign2 \bal-$400,25
.l2\@
     assign2 \bal-$400,26
     assign2 \bal-$400,27
     assign2 \bal-$400,28
     assign2 \bal-$400,29
.sco0\@ lda #0
     sta \bal+30*40,x
.slu0\@ lda #0
     sta \bal-$400+30*40,x
.sco1\@ lda #0
     sta \bal+31*40,x
.slu1\@ lda #0
     sta \bal-$400+31*40,x
     dex
     bmi *+5
     jmp .l\@
     endm

sscroll_up8:
     assigny $2800,$9800
     assigny $3000,$7000
     assigny $3800,$8000
     assigny $9000,$8800
     rts



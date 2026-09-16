 5 ti$="000000
10 color0,5,3:color1,2,7:graphic1,1
20 xc=int(rnd(1)*100+110):yc=int(rnd(1)*100+50)
30 fori=0to319step2:fcol1:line xc,yc,i,0:fcol0:line xc,yc,i+1,0:next
40 fori=0to199step2:fcol1:line xc,yc,319,i:fcol0:line xc,yc,319,i+1:next
50 fori=319to0step-2:fcol1:line xc,yc,i,199:fcol0:line xc,yc,i-1,199:next
60 fori=199to0step-2:fcol1:line xc,yc,0,i:fcol0:line xc,yc,0,i-1:next
99 i=ti
100 getkeya$
110 graphic0
120 print"time="i"jiffies


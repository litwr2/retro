10 rem circle test
20 ti$="000000"
25 color0,5,3:color1,2,7:graphic1,1
30 fori=1to120step2:fcol1:fcirci,100,i:fcol0:fcirci+1,100,i+1:next
40 fori=120to1step-2:fcol1:fcirc240-i,100,i:fcol0:fcirc241-i,100,i-1:next
50 i=ti
60 getkeya$
70 print"time="i"jiffies"
80 graphic0

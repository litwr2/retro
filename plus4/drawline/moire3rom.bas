 5 ti$="000000
10 color0,5,3:color1,2,7:graphic1,1
20 xc=int(rnd(1)*100+110):yc=int(rnd(1)*100+50)
30 fori=0to319step2:draw,xc,yctoi,0:draw0,xc,yctoi+1,0:next
40 fori=0to199step2:draw,xc,ycto319,i:draw0,xc,ycto319,i+1:next
50 fori=319to0step-2:draw,xc,yctoi,199:draw0,xc,yctoi-1,199:next
60 fori=199to0step-2:draw,xc,ycto0,i:draw0,xc,ycto0,i-1:next
99 i=ti
100 getkeya$
110 graphic0
120 print"time="i"jiffies


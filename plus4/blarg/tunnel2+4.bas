0 rem tunnel slj 1/20/97, litwr 17-9-26
3 print"{clr}":color0,5,3:color1,2,7
4 dim c(200),s(200),r(20):a=2:b=3
5 fori=0to200:p=2*i*~/180
6 c(i)=130*(1+cos(p))+10*(1+cos(12*p)):s(i)=95*(1+sin(2*p))+4*(1+sin(6*p))
7 print"{home}"i;:next
8 fori=0to20:r(i)=0:next
10 mode18:graphic1:clear:buffer0:clear
20 b=0:a=2.8:fcol1
30 fori=19to0step-1
35 if r(i)=0 then 50
40 fcirc c(b+i),s(b+i),r(i)
50 if r(i)>2 then r(i+1)=r(i+1)*1.1+a
55 next
56 r(0)=r(0)*1.1+a
60 swap:buffer0:clear
70 if r(0)<220 then 30
80 fori=0to19:r(i)=r(i+1):next:r(19)=1
90 b=b+1:if b=180 then b=0
100 goto 30


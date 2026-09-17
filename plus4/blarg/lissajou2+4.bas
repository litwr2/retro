  0 rem lissajou  slj 1/20/97, litwr 17-9-26
  1 print "press q to quit, any other key"
  2 print "to redraw with random parameters"
  3 print "remove line 130 and set c=d=0"
  4 print "for normal lissajous"
  6 getkeya$
  9 a=1:b=2:c=12:d=6
 10 color0,5,3:color1,2,7:graphic1,1:fcol1:p=~/180
 20 fori=0to360step.3:phi=i*p
 30 x=130*(1+cos(a*phi))+10*(1+cos(c*phi))
 35 y=95*(1+sin(b*phi))+4*(1+sin(d*phi))
 40 plot x,y
 50 next
100 getkeya$
110 if a$="q" then 180
130 c=int(32*rnd(1)):d=int(16*rnd(1))
140 a=int(10*rnd(1)+1):b=int(10*rnd(1)+1):clear:goto10
180 print "a,b,c,d="a;b;c;d
190 graphic0

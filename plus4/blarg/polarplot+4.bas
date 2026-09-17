   0 rem polar function plotter
   1 rem remove rems for different
   2 rem function plots.
   3 rem slj 1/20/97, litwr 17-9-26
   4 rem :
  10 color0,5,3:color1,2,7:graphic1,1:fcol1
  20 xc=160:yc=100:rad=~/180/2
  30 for phi=0 to 2*~ step rad
  40 r=80*sin(3*phi)+10*cos(36*phi)
  45 rem r=90*cos(4*phi)
  50 rem r=60*(1-cos(phi))
  55 rem r=50*(1-2*cos(phi))
  60 rem r=12*phi
  70 rem r=50*cos(phi)
 100 x=r*cos(phi):y=r*sin(phi)
 110 plot xc+x,yc-y
 120 next
 999 getkeya$
1000 graphic0


10 graphic1,1:a=ti
15 for i=1 to 5
20 x=0:do
30 cs=(peek(65310)/2)and1
40 draw cs,x,0 to 319-x,199
50 x=x+4:loop until x>319
60 next
70 print ti-a
80 graphic0


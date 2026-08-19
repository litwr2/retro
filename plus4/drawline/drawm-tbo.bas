10 a=ti:graphic3,1
12 color2,6,4:color3,5,4
15 for i=1 to 5
20 x=0:do
30 cs=(peek(65310)/2)and3
40 draw cs,x,0 to 159-x,199
50 x=x+4:loop until x>159
60 next
70 print ti-a
80 graphic0


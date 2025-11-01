 10 print"** ntsc throttle v1 by litwr, 2025"
 20 print"use ecmeter to find the best values for"spc(29)"your monitor"
 25 if peek(44)<>16 then print"load this code at $1001!":end
 30 if peek(65287)and64 then print"this only works on pal computers":end
 40 input"extra lines before the vsync (1-11)";a:ifa<1ora>11then40
 50 input"extra lines after the vsync (3-12)";b:ifb<3orb>12then50
 60 printusing"this sets about #.##% acceleration and";.475*(a+b-3)+.16
 70 printspc(5);:printusing"distorts about ##.##% of the raster";(a+b)*50/39
 80 printspc(10);:printusing"ted overclocking #.##%";(312+a+b)*.317576-100
 90 print"proceed?(y/n)":getkeya$:ifa$="n"goto40:else:ifa$<>"y"goto90
100 print"where put the code:":print"1 @$332 (cassette buffer)"
110 print"2 @$1000 (no graphics)"
120 print"3 @$1000 (graphics on)"
130 inputc:ifc<1orc>3then100
140 print"do not use split screen modes!"
150 poke8192,a:poke8193,b:poke8194,c-1:clr:sys1111

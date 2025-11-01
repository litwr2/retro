 10 print"** ntsc throttle v1 by litwr, 2025"
 20 print"use ecmeter to find the best values for"spc(29)"your monitor"
 30 if peek(44)<>16 then print"load this code at $1001!":end
 40 if peek(65287)and64 then print"this only works on pal computers":end
 50 input"extra lines before the vsync (1-11)";a:ifa<1ora>11then50
 60 input"extra lines after the vsync (3-12)";b:ifb<3orb>12then60
 70 printusing"this sets about #.##% acceleration and";.475*(a+b-3)+.16
 80 printspc(5);:printusing"distorts about ##.##% of the raster";(a+b)*50/39
 90 printspc(10);:printusing"ted overclocking #.##%";(312+a+b)*.317576-100
100 print"proceed?(y/n)":getkeya$:ifa$="n"goto50:else:ifa$<>"y"goto100
110 print"where put the code:":print"1 @$332 (cassette buffer)"
120 print"2 @$1000 (no graphics)"
130 print"3 @$1000 (graphics on)"
140 inputc:ifc<1orc>3then110
150 ifc=3andfre(0)<16000thenprint"more RAM is needed for this option":goto110
160 print"do not use split screen modes!"
170 poke8192,a:poke8193,b:poke8194,c-1:clr:sys1111

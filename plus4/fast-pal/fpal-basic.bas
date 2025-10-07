10 print"** ntsc throttle v1 by litwr, 2025"
20 print"use ecmeter to find the best values for your monitor"
30 if peek(65287)and64 then print"this only works on pal computers":end
40 input"extra lines before the vsync (1-11)";a:ifa<1ora>11then40
50 input"extra lines after the vsync (3-12)";b:ifb<3orb>12then50
60 printusing"this sets about #.##% acceleration and  distorts about ##.##% of the raster";.475*(a+b-3)+.16,(a+b)*50/39
70 print"proceed?(y/n)":getkeya$:ifa$="n"goto40:else:ifa$<>"y"goto70
80 print"do not use split screen modes!"
90 poke8192,a:poke8193,b:clr:sys1111

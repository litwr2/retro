10 a$="aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
20 b$=a$
30 print ds$:directory
40 c$=a$
50 gosub1000
60 c$=a$+a$
70 b$=a$
80 gosub1000
90 print b$
100 end
1000 for i=1 to 1600
1010 d$="dddddddddddddddddddddddddddddddddddddddd"
1020 next
1030 return

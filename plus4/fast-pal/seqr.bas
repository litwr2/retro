 10 rem *** sequential files reader, light
 20 rem *** by litwr, 2005, 2013, 2021, 2025
100 a$="read.me"
110 print"{clr}{ensh}{swlc}";
120 open3,8,3,a$+",s,r"
130 get#3,a$:ifa$=""thena$=chr$(0)
150 printa$;:ifst=0then130
160 ifds>19thenprintds$
170 close3

#include<stdio.h>

int map[256];

void inimap() {
   int i, k;
   for (i = 0; i < 256; i++)
      map[i] = -1;
   for (i = 0; i <= 'Z' - 'A'; i++)
      map['A' + i] = i;
   map['['] = i++;
   map[']'] = i++;
   map[' '] = i++;
   map['!'] = i++;
   map['\''] = i++;
   map['#'] = i++;
   map['('] = i++;
   map[')'] = i++;
   map['*'] = i++;
   map['+'] = i++;
   map[','] = i++;
   map['-'] = i++;
   map['.'] = i++;
   map['/'] = i++;
   k = i;
   for (; i < k + 10; i++)
      map['0' + i - k] = i;
   map[':'] = i++;
   map[';'] = i++;
   map['<'] = i++;
   map['='] = i++;
   map['>'] = i++;
   map['?'] = i;
}
//ROMPPAINEN
int main() {
   FILE *f = fopen("demo.prg", "r+"), *g = fopen("64x4x8.prg", "r");
   unsigned char buf[65000], cg[256], *p, 
      phrases[][16] = {" BORDER", "   30:288", "GRAPHICS",  " NTSC ON", " PAL  2013", 
         "   HAVE", " A VERY", "     HAPPY", "NEW YEAR!", " GREET--", "  INGS TO", " PATRICK",
         "SVS GAIA", " MIKS 16+", "CSABO RO--", "MPPAINEN", "THANX TO", "  ISTVANV", ""};
   int l = fread(buf, 1, 65000, f), scode, scode2, scode3, i, k, b, gc, v = 0, f1 = 1;
   fread(cg, 1, 2, g);
   fread(cg, 1, 256, g);
   fclose(g);
   scanf("%x\n", &scode);
   scanf("%x\n", &scode3);
   scanf("%x\n", &scode2);
   scode -= 0xfff + 13*103;
   scode2 -= 0xfff;
   scode3 -= 0xfff;
   inimap();
   while (*(p = phrases[v])) {
      scode += 0x67*16;
      if (scode + 6*103 >= scode3 && f1) scode = scode2 + 4*103, f1 = 0;
      v++;
      gc = 0;
      for (i = 0; p[i]; i++) {
         int a = map[p[i]];
         if (a < 0) {
            printf("WRONG CHAR\n");
            return 1;
         }
         for (k = 0; k < 4; k++) {
            int t = cg[a*4 + k];
            if (t == 0xff) break;
            for (b = 7; b >= 0; b--)
               if (t & 1 << b)
                  if (buf[scode + 103*(7 - b) + gc*3] == 0x8e)
                     buf[scode + 103*(7 - b) + gc*3] = 0x8c;
                  else {
                     printf("WRONG POS = %x\n", scode + 103*(7 - b) + gc*3 + 0xfff);
                     return 2;
                  }
            gc++;
            if (gc == 20) gc++;
         }
      }
   }
   rewind(f);
   fwrite(buf, 1, l, f);
   fclose(f);
   return 0;
}

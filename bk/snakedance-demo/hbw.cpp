#include <iostream>
#include <cstdio>
#include <string>
#include <map>
using namespace std;
#include "hbw-data.h"
int X = 6*8 - 1, Y = 107, lSZ = 0, startX = X, startY = Y; //start
unsigned char t[SZ], l[MAXX*50];
int dy[] = {-1, 1, 0, 0}, dx[] = {0, 0, -1, 1};

int r(int x, int y) {
  if (x < MAXX && x >= 0 && y < MAXY && y >= 0)
    return y*MAXX + x;
  else
    return 0;
}

void fill_t() {
   for (int x = 0; x < MAXX; x++)
     for (int y = 0; y < MAXY; y++)
        t[r(x,y)] = '.';
}

int check() {
   for (int y = 0; y < MAXY; y++)
     for (int x = 0; x < MAXX; x++)
        if (t[r(x,y)] == pixels[r(x,y)] || x == startX && y == startY || t[r(x,y)] == '0' && string("uldr").find(pixels[r(x, y)]) != string::npos || t[r(x,y)] == '0' && pixels[r(x,y)] == '.');
        else if (t[r(x,y)] == '0' || pixels[r(x,y)] == '0')
            return 0;
        else
            return 0;
   return 1;
}

void print() {
   for (int y = 0; y < MAXY; y++) {
     for (int x = 0; x < MAXX; x++)
        cout << t[r(x,y)];
     cout << endl;
   }
}

void print1() {
   for (int y = 0; y < MAXY; y++) {
     for (int x = 0; x < MAXX; x++)
        if (x == startX && y == startY)
            cout << 'S';
        else if (t[r(x,y)] == pixels[r(x,y)] || x == startX && y == startY || t[r(x,y)] == '0' && string("uldr").find(pixels[r(x, y)]) != string::npos || t[r(x,y)] == '0' && pixels[r(x,y)] == '.')
            cout << t[r(x,y)];
        else if (t[r(x,y)] == '0')
            cout << 'Z';
        else if (pixels[r(x,y)] == '0')
            cout << 'X';
        else cout << '@';
     cout << endl;
   }
}

void print2() {
   unsigned char t2[SZ];
   char T[] = "udlr";
   for (int y = 0; y < MAXY; y++)
     for (int x = 0; x < MAXX; x++)
        t2[r(x,y)] = t[r(x,y)];
   int x = startX, y = startY;
   for (int i = 0; i < lSZ; i++)
       t2[r(x,y)] = T[l[i]], x += dx[l[i]], y += dy[l[i]];
   for (int y = 0; y < MAXY; y++) {
     for (int x = 0; x < MAXX; x++)
        cout << t2[r(x,y)];
     cout << endl;
   }
}

int nextpoint() {
   switch (pixels[r(X,Y)]) {
     case 'l': return 2;
     case 'd': return 1;
     case 'u': return 0;
     case 'r': return 3;
   }
   if (t[r(X,Y)] == '.')
     switch (pixels[r(X,Y)]) {
       case 'L': return 2;
       case 'D': return 1;
       case 'U': return 0;
       case 'R': return 3;
     }
   for (int x = -1; x < 2; ++x)
     for(int y = -1; y < 2; ++y)
         if ((x|y) != 0 && x*y == 0 && pixels[r(X + x, Y + y)] != '.' && t[r(X + x, Y + y)] == '.') {
             if (x == 1) return 3;
             if (x == -1) return 2;
             if (y == 1) return 1;
             if (y == -1) return 0;
         }
   for (int x = -1; x < 2; ++x)
       for(int y = -1; y < 2; ++y)
          if ((x|y) != 0 && x*y == 0 && string("UDLR").find(pixels[r(X + x, Y + y)]) != string::npos) {
             pixels[r(X + x, Y + y)] = '.';
             if (x == 1) return 3;
             if (x == -1) return 2;
             if (y == 1) return 1;
             if (y == -1) return 0;
          }
   for (int x = -1; x < 2; ++x)
       for(int y = -1; y < 2; ++y)
          if ((x|y) != 0 && x*y == 0 && X + x == startX && Y + y == startY) {
             t[r(X, Y)] = '0';
             throw string("ok");
          }
   throw string("fail");
}

void checkpoint() {
   int p = nextpoint();
   l[lSZ++] = p;
   t[r(X,Y)] = '0';
   X += dx[p];
   Y += dy[p];
}

void printres() {
   FILE *f;
   for (int i = 0; i < lSZ; i++) l[i] *= 2;
   f = fopen("img.vec","w");
   fwrite(l, 1, lSZ, f);
   fclose(f);
   f = fopen("img.s","w");
   for (int i = 0; i < lSZ; i++) {
       if (i%16 == 0) fprintf(f, "\n    .BYTE "); else fprintf(f, ",");
       fprintf(f, "%d", l[i]);
   }
   fclose(f);
}

int main() {
  fill_t();
  try {
    while (1) 
      checkpoint();
  }
  catch (string &s) {
     if (s != "ok") {
         print();
         print2();
     } else {
         if (check())
             printres();
         else {
             print1();
             print2();
         }

     }
     cout << s << ' ' << lSZ << endl;
  }
  return 0;
}


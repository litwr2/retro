#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <map>
using namespace std;
#define msqr(a) ((a)*(a))
#define mabs(a) ((a) > 0 ? (a) : -(a))
#define BSZ 512
#define VS 280
#define HS 160
int pic[HS][VS], picr[HS][VS], mc1[VS], mc2[VS];
struct Cell {
   int c1, c2;
} cell[HS/4][VS/2];
int vs, hs;
#include "p4prg.cpp"
int getR(int c) {
   return c >> 16;
}
int getG(int c) {
   return (c >> 8)&255;
}
int getB(int c) {
   return c&255;
}
int q(int x, int y, int c) {
   int n = 0;
   for (int ix = 0; ix < 4; ix++)
       for (int iy = 0; iy < 2; iy++)
           if (c != mc1[y + iy] && c != mc2[y + iy] && c == pic[x + ix][y + iy])
               n++;
   return n;
}
int eq(int x, int y, int c) {
   int n = 0;
   if (x > 0) {
       for (int iy = 0; iy < 2; iy++) 
           if (c != mc1[y + iy] && c != mc2[y + iy] && c == pic[x - 1][y + iy])
               n++;
       if (y > 0 && c != mc1[y - 1] && c != mc2[y - 1] && c == pic[x - 1][y - 1])
           n++;
       if (y < VS - 2 && c != mc1[y + 2] && c != mc2[y + 2] && c == pic[x - 1][y + 2])
           n++;
   }
   if (x < hs - 4) {
       for (int iy = 0; iy < 2; iy++) 
           if (c != mc1[y + iy] && c != mc2[y + iy] && c == pic[x + 4][y + iy])
               n++;
       if (y > 0 && c != mc1[y - 1] && c != mc2[y - 1] && c == pic[x + 4][y - 1])
           n++;
       if (y < VS - 2 && c != mc1[y + 2] && c != mc2[y + 2] && c == pic[x + 4][y + 2])
           n++;
   }
   if (y > 0)
       for (int ix = 0; ix < 4; ix++) 
           if (c != mc1[y - 1] && c != mc2[y - 1] && c == pic[x + ix][y - 1])
              n++;
   if (y < VS - 2)
       for (int ix = 0; ix < 4; ix++) 
           if (c != mc1[y + 2] && c != mc2[y + 2] && c == pic[x + ix][y + 2])
              n++;       
   return n;
}
int find_best(int c, int x, int y) {
    int z[4], w[4];
    z[2] = z[3] = z[1] = z[0] = 1000000;
    if ((w[0] = cell[x/4][y/2].c1) >= 0)
        z[0] = msqr(getR(c) - getR(w[0])) + msqr(getG(c) - getG(w[0])) + msqr(getB(c) - getB(w[0]));
    if ((w[1] = cell[x/4][y/2].c2) >= 0)
        z[1] = msqr(getR(c) - getR(w[1])) + msqr(getG(c) - getG(w[1])) + msqr(getB(c) - getB(w[1]));
    if (y%2 == 0 && (w[2] = mc1[y]) >= 0)
        z[2] = msqr(getR(c) - getR(w[2])) + msqr(getG(c) - getG(w[2])) + msqr(getB(c) - getB(w[2]));
    if (y%2 == 0 && (w[3] = mc2[y]) >= 0)
        z[3] = msqr(getR(c) - getR(w[3])) + msqr(getG(c) - getG(w[3])) + msqr(getB(c) - getB(w[3]));
    if (y%2 == 1 && (w[2] = mc1[y]) >= 0)
        z[2] = msqr(getR(c) - getR(w[2])) + msqr(getG(c) - getG(w[2])) + msqr(getB(c) - getB(w[2]));
    if (y%2 == 1 && (w[3] = mc2[y]) >= 0)
        z[3] = msqr(getR(c) - getR(w[3])) + msqr(getG(c) - getG(w[3])) + msqr(getB(c) - getB(w[3]));
    int m = 1000000, bc;
    for (int i = 0; i < 4; i++)
        if (m > z[i]) m = z[i], bc = w[i];
    return bc;
}
int main(int argc, char **argv) {
    unsigned char b[BSZ];
    int t;
    FILE *fi = fopen(argv[1], "r"), *fo = fopen(argv[2], "w");
    fgets((char*)b, BSZ, fi);
    fputs((char*)b, fo);
    if (strstr((char*)b, "P6") != (char*)b) {
E1:     fprintf(stderr, "incorrect format\n");
        return 2;
    }
    for(;;) {
       fgets((char*)b, BSZ, fi);
       if (b[0] != '#') break;
       fputs((char*)b, fo);
    }
    t = sscanf((char*)b, "%d %d", &hs, &vs);
    if (t != 2 || hs%8 != 0 || vs%2 !=0) goto E1;
    fprintf(fo, "%d %d\n", hs*2, vs);
    fgets((char*)b, BSZ, fi);
    fputs((char*)b, fo);
    t = atoi((char*)b);
    if (t != 255) goto E1;  //wrong format
    for (int y = 0; y < vs; y++)
        for (int x = 0; x < hs; x++) {
				fread(b, 1, 3, fi);
				pic[x][y] = b[0] << 16 | b[1] << 8 | b[2];
			}
	for (int y = 0; y < vs; y += 2)
        for (int x = 0; x < hs; x += 4) {
            int m = 0, c1, c2;
			for (int ix = 0; ix < 4; ix++)
                for (int iy = 0; iy < 2; iy++) {
                    int c = pic[x + ix][y + iy];
                    int tq = q(x, y, c);
                    if (tq > m || tq == m && eq(x, y, c) + tq > eq(x, y, c1) + m)
                        m = tq, c1 = c;
                }
            if (m) cell[x/4][y/2].c1 = c1, m = 0; else cell[x/4][y/2].c1 = -1;
            for (int ix = 0; ix < 4; ix++)
                for (int iy = 0; iy < 2; iy++) {
                    int c = pic[x + ix][y + iy];
                    if (c1 != c) {
                        int tq = q(x, y, c);
                        if (tq > m || tq == m && eq(x, y, c) + tq > eq(x, y, c2) + m)
                            m = tq, c2 = c;
                    }
                }
            if (m) cell[x/4][y/2].c2 = c2; else cell[x/4][y/2].c2 = -1;
		}
    for (int y = 0; y < vs; y++) {
        map<int, int> tc;
        mc1[y] = mc2[y] = -1;
        for (int x = 0; x < hs; x++) {
           int c = pic[x][y], a = (c != cell[x/4][y/2].c1) && (c != cell[x/4][y/2].c2);
           if (tc.find(c) == tc.end())
              tc[c] = a;
           else
              tc[c] += a;
        }
        int m1 = 0, m2 = 0, c1, c2;
        for (auto i = tc.begin(); i != tc.end(); i++)
            if (m1 < i->second) m2 = m1, c2 =c1, m1 = i->second, c1 = i->first;
            else if (m2 < i->second) m2 = i->second, c2 = i->first;
        mc1[y] = c1, mc2[y] = c2;    
    }
    for (int y = 0; y < vs; y += 2)
        for (int x = 0; x < hs; x += 4)
            for (int ix = 0; ix < 4; ix++)
                for (int iy = 0; iy < 2; iy++) {
                    int c = pic[x + ix][y + iy];
                    if (c == cell[x/4][y/2].c1)
                        picr[x + ix][y + iy] = cell[x/4][y/2].c1;
                    else if (c == cell[x/4][y/2].c2)
                        picr[x + ix][y + iy] = cell[x/4][y/2].c2;
                    else if (c == mc1[y + iy])
                        picr[x + ix][y + iy] = mc1[y + iy];
                    else if (c == mc2[y + iy])
                        picr[x + ix][y + iy] = mc2[y + iy];
                    else
                        picr[x + ix][y + iy] = find_best(c, x + ix, y + iy);
                }
    t = 0;
    for (int y = 0; y < vs; y++)
        for (int x = 0; x < hs; x++) {
                if (pic[x][y] != picr[x][y]) t++;
                b[0] = getR(picr[x][y]);
                b[1] = getG(picr[x][y]);
                b[2] = getB(picr[x][y]);
				fwrite(b, 1, 3, fo);
				fwrite(b, 1, 3, fo);
			};
    fclose(fi);
    fclose(fo);
    fprintf(stdout, "%.4f\n", 100.*t/hs/vs);
#if 0
    for (int i = 0; i < vs; i++)
        fprintf(stderr, "%d %06x %06x\n", i, mc1[i], mc2[i]);
    for (int y = 0; y < vs; y += 2)
        for (int x = 0; x < hs; x += 4)
            fprintf(stderr, "%d %d %06x %06x\n", x, y, cell[x/4][y/2].c1, cell[x/4][y/2].c2);
#endif
    fi = fopen("out.prg", "r");
    int co = fread(prg + 0xfff, 1, 50000, fi);
    fclose(fi);
    prginit();
    setattr();
    setmc();
    setbm();
    fo = fopen("out1.prg", "w");
    fwrite(prg + 0xfff, 1, co, fo);
    fclose(fo);
    return 0;
}


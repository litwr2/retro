//PPM (ASCII) to PPI converter
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define BSZ 512
unsigned short p[3][32768]; //RGB
int main() {
    char b[BSZ];
    int vs, hs, t, mc, ph, divider, shifter;
    fgets(b, BSZ, stdin);
    if (strstr(b, "P3") != b) {
        fprintf(stderr, "only the 3 plane format is supported\n");
        return 2;
    }
    do {
       fgets(b, BSZ, stdin);
    } while (b[0] == '#');
    hs = atoi(b);
    if (hs%2 == 1) goto E;
    if (hs <= 256)
       divider = 16, shifter = 4;
    else if (hs <= 512)
       divider = 64, shifter = 2;
    else if (hs <= 1024)
       divider = 128, shifter = 1;
    else {
E:      fprintf(stderr, "the picture has a wrong size\n");
        return 1;
    }
    vs = atoi(strchr(b, ' ') + 1);
    if (vs > 512)
       goto E;
    fgets(b, BSZ, stdin);
    mc = atoi(b);
    if (mc != 255) goto E;  //wrong format
    b[0] = 3;
    b[1] = b[7] = 0;
    b[2] = hs%256;
    b[3] = hs/256;
    b[4] = vs%256;
    b[5] = vs/256;
    b[6] = shifter;
    fwrite(b, 1, BSZ, stdout);
    ph = 0;
    for (int i = 0; i < 3*hs*vs; i++) {
    //for (int i = 0; i < 200; i++) {
        fgets(b, BSZ, stdin);
        t = atoi(b)/divider;
        p[i%3][i/3/(16/shifter)] += t << ph*shifter;
   //fprintf(stderr, "%d %d %d %d %d %x\n", i, t, ph, i%3, i/3/(16/shifter), p[i%3][i/3/(16/shifter)]);
        if ((1 + i)%3 == 0) ph < 16/shifter - 1 ? ++ph : (ph = 0);
    }
    for (int i = 0; i < 3; i++)
        t = hs*shifter/16*vs, fwrite(p[i], 2, (t/512 + (t%512 != 0))*512, stdout);
    return 0;
}


//converts images in the standard PPM format to the Corvette PIC format, it uses a palette file
//USAGE: ppm2pic PALETTE-file <PPM-file >PIC-file

#include <stdio.h>
#define SZ 65536
unsigned char bi[SZ*6], bo[SZ/4*3];
int pal[16][3] = {
    {0, 0, 0},
    {0, 0, 255},
    {0, 255, 0},
    {0, 255, 255},
    {255, 0, 0},
    {255, 0, 255},
    {255, 255, 0},
    {255, 255, 255}};
void loadpal(const char *fn) {
    FILE *f = fopen(fn, "r");
    for (int i = 0; i < 15; i++) {
        int l, n, r, g, b;
        fgets(bi, 64, f);
        l = sscanf(bi, "%d %d %d %d", &n, &r, &g, &b);
        if (l != 4) break;
        pal[n][0] = r;
        pal[n][1] = g;
        pal[n][2] = b;
    }
    fclose(f);
}
int seekpal(int r, int g, int b) {
    for (int i = 0; i < 8; i++)
        if (pal[i][0] == r && pal[i][1] == g && pal[i][2] == b)
            return i;
    return -1;
}
int main(int argc, char **argv) {
    int i, l, n;
    if (argc == 2) loadpal(argv[1]);
    fgets(bi, SZ, stdin);
    if (bi[0] != 'P' || bi[1] != '6') {
E:      fputs("Wrong format\n", stderr);
        return 1;
    }
    fgets(bi, SZ, stdin);
    if (bi[0] != '#') goto E;
    fgets(bi, SZ, stdin);
    if (sscanf(bi, "%d %d", &i, &l) != 2 || i != 512 || l != 256) goto E;
    fgets(bi, SZ, stdin);
    if (sscanf(bi, "%d", &i) != 1 || i != 255) goto E;
    n = fread(bi, 1, 6*SZ, stdin)/SZ;
    if (n != 6) goto E;
    for (i = 0; i < 512*256/8; i++)
        for (l = 0; l < 8; l++) {
            int t = seekpal(bi[24*i + 3*l], bi[24*i + 3*l + 1], bi[24*i + 3*l + 2]);
            bo[i] += (t & 1) << (7 - l);
            bo[i + SZ/4] += ((t & 2) >> 1) << (7 - l);
            bo[i + SZ/2] += ((t & 4) >> 2) << (7 - l);
        }
    n = 3;
    for (i = SZ/2; i < SZ/4*3; i++)
       if (bo[i]) break;
    if (i == SZ/4*3) n = 2;
    fwrite(bo, 1, n*SZ/4, stdout);
    return 0;
}

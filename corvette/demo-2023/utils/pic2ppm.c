//converts images in the Corvette PIC format to the standard PPM format, it uses a palette file
//USAGE: pic2ppm PALETTE-file <PIC-file >PPM-file

#include <stdio.h>
#define SZ 16384
unsigned char b[SZ*3];
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
        int l, n, r, g, bl;
        fgets(b, 64, f);
        l = sscanf(b, "%d %d %d %d", &n, &r, &g, &bl);
        if (l != 4) break;
        pal[n][0] = r;
        pal[n][1] = g;
        pal[n][2] = bl;
    }
    fclose(f);
}
int main(int argc, char **argv) {
    int i, l, n;
    if (argc == 2) loadpal(argv[1]);
    puts("P6\n#\n512 256\n255");
    n = fread(b, 1, 3*SZ, stdin)/SZ;
    for (i = 0; i < 512*256/8; i++)
        for (l = 7; l >= 0; l--) {
            int t = (b[i] >> l & 1) << 0;
            t += (b[i + SZ] >> l & 1) << 1;
            t += (b[i + 2*SZ] >> l & 1) << 2;
            for (int k = 0; k < 3; k++)
                fwrite(&pal[t][k], 1, 1, stdout);
    }
    return 0;
}

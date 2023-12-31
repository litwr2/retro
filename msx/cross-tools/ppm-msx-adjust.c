//PPM (BINARY, P6) to PPM (BINARY, P6) converter, it adjust colors to the MSX-2/Enterprise standard
//2023, Litwr
//USAGE: ppm-msx-adjust <INFILE.ppm >OUTFILE.ppm
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define BSZ 512
int main() {
    unsigned char b[BSZ];
    int vs, hs, t;
    fgets(b, BSZ, stdin);
    fputs(b, stdout);
    if (strstr(b, "P6") != (char*)b) {
E1:     fprintf(stderr, "incorrect format\n");
        return 2;
    }
    do {
       fgets(b, BSZ, stdin);
       fputs(b, stdout);
    } while (b[0] == '#');
    t = sscanf(b, "%d %d", &hs, &vs);
    if (t != 2) goto E1;
    fgets(b, BSZ, stdin);
    fputs(b, stdout);
    t = atoi(b);
    if (t != 255) goto E1;  //wrong format
    do {
        fread(b, 1, 3, stdin);
        if (feof(stdin)) break;
        b[0] = (b[0]/32)*32 + 16;
        b[1] = (b[1]/32)*32 + 16;
        b[2] = (b[2]/64)*64 + 32;
        fwrite(b, 1, 3, stdout);
    } while (1);
    return 0;
}


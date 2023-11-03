//it converts the INC sound file into the WAV format
//it reverses the work of WAV2INC but with two volume levels only
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define VOLMAX 192
#define VOLMIN 64
#define BSZ 65000
unsigned char buf[BSZ];
int main(int argc, char** argv) {
    int c, n, i, freq, t = 0;
    unsigned char b0 = VOLMIN, b1 = VOLMAX, ib[127], *p;
    if (argc != 2) {
O:      fputs("USAGE: inc2wav FREQUENCY <INC-file >WAV-file\n", stderr);
        return 2;
    }
    freq = atoi(argv[1]);
    if (freq < 1000 || freq > 22000) goto O;
    n = 0;
    while (!feof(stdin)) {
        int z[16];
        fgets(ib, 127, stdin);
        if (strlen(ib) < 3 || strstr(ib + 1, "db") == 0 || strchr(ib, ';') != 0 && strchr(ib, ';') < strstr(ib, "db"))
            continue;
        c = sscanf(ib, " db %d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d", &z[0], &z[1], &z[2], &z[3], &z[4], &z[5], &z[6], &z[7], &z[8], &z[9], &z[10], &z[11], &z[12], &z[13], &z[14], &z[15]);
        for (i = 0; i < c; i++)
            buf[n + i] = z[i];
        n += c;
        if (n >= BSZ) {
            fputs("too long input\n", stderr);
            return 1;
        }
    }
    printf("RIFF");
    i = n*8 + 36; fwrite(&i, 1, 4, stdout);
    printf("WAVEfmt ");
    i = 16; fwrite(&i, 1, 4, stdout);  //fmt-chunk size 
    i = 0x10001; fwrite(&i, 1, 4, stdout); //PCM, one channel
    fwrite(&freq, 1, 4, stdout);
    fwrite(&freq, 1, 4, stdout);
    i = 0x80001; fwrite(&i, 1, 4, stdout);  //8-bit bytes
    printf("data");
    i = n*8; fwrite(&i, 1, 4, stdout);
    for (i = 0; i < n; i++)
       for (int j = 0; j < 8; j++) {
           if ((buf[i]&1) == 0)
               fwrite(&b0, 1, 1, stdout);
           else
               fwrite(&b1, 1, 1, stdout);
           buf[i] >>= 1;
       }
    return 0;
}

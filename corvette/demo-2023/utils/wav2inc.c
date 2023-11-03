//it converts 8-bit sound to 1-bit sound in the assembly format for the Z80 and x86 assemblers
#define _GNU_SOURCE   //for memmem()
#include <stdio.h>
#include <string.h>
#define BSZ 65000
unsigned char buf[BSZ], *p;
int main(int argc, char** argv) {
    int c, n, max = 0, min = 255, i;
    int b = 0, k = 0;
    if (argc != 2 || argv[1][0] != '0' && argv[1][0] != '1') {
        fputs("USAGE: wav2inc FORMAT <WAV-file >INC-file\n", stderr);
        fputs("  FORMAT=0 - standard\n", stderr);
        fputs("  FORMAT=1 - pseudo 3-level, doubles frequency\n", stderr);
        return 2;
    }
    n = fread(buf, 1, BSZ, stdin);
    if (strncmp(buf, "RIFF", 4) != 0) {
L:      fputs("wrong format!\n", stderr);
        return 1;
    }
    if (strncmp(buf + 8, "WAVE", 4) != 0 || (p = memmem(buf, n, "fmt ", 4)) == 0) goto L;
    if (*(short*)(p + 8) != 1 || *(short*)(p + 10) != 1) goto L; //PCM, one channel, 8 bits per byte
    c = *(int*)(p + 12);  //rate
    fprintf(stderr, "Sampling must be %d Hz\n", c*(argv[1][0] - '0' + 1));
    if (c != *(int*)(p + 16) || *(short*)(p + 20) != 1 || *(short*)(p + 22) != 8) goto L;
    if ((p = memmem(p + 24, n - 24, "data", 4)) == 0) goto L;
    for (i = p + 8 - buf; i < n; i++) {
        if (buf[i] < min) min = buf[i];
        if (buf[i] > max) max = buf[i];
    }
    if (argv[1][0] == '0') {
		for (int j = p + 8 - buf; j < n; j += 8) {
		    if ((k & 15) == 0) printf("\n db ");
		    b = 0;
		    for (i = 0; i < 8; i++) {
		        if (i + j >= n) break;
		        c = buf[i + j];
		        if (2*c < min + max + 1) c = 0; else c = 1;
		        b |= (1 << i)*c;
		    }
		    printf("%d", b);
		    if (7 + j >= n) break;
		    if ((++k & 15) != 0) printf(",");
		}
    } else {
		for (int j = p + 8 - buf; j < n; j += 4) {
		    if ((k & 15) == 0) printf("\n db ");
		    b = 0;
		    for (i = 0; i < 4; i++) {
		        int c1, c2;
		        if (i + j >= n) break;
		        c = buf[i + j];
		        if (3*c < max + 2*min) c1 = 0, c2 = 0;
		        else if (3*c < 2*max + min) c1 = 0, c2 = 1;
		        else c1 = 1, c2 = 1;
		        b |= (1 << i*2)*c1;
		        b |= (1 << (i*2 + 1))*c2;
		    }
		    printf("%d", b);
		    if (3 + j >= n) break;
		    if ((++k & 15) != 0) printf(",");
        }
    }
    return 0;
}

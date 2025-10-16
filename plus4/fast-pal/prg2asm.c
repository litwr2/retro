#include<stdio.h>
#define SZ 2048
int main() {
    unsigned char buf[SZ];
    int i, k, s;
    s = fread(buf, 1, SZ, stdin) - 7;
    i = 2;
    for(;;) {
        printf("  byte ");
        for (k = 0; k < 20; k++) {
           if (i >= s) goto E;
           printf("$%x",buf[i++]);
           if(k < 19 && i < s)printf(",");
           if(i == s) {puts(""); goto E;}
        }
        puts("");
    }
E:
    return 0;
}


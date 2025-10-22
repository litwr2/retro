/* 2rle <IN >OUT */
#include <stdio.h>
#include <string.h>
int range(int start, int max, int *data) {
   int k = start;
   for(;;) {
       k = k + 1;
       if (k == max || data[start] != data[k]) break;
   }
   return k;
}
int main() {
    int i, k, n, q, xsz, ysz, data[4096], odata[4096], totali = 0, totalq = 0;
    char tlb[128] = "";
    for(;;) {
        gets(tlb);
        puts(tlb);
        n = sscanf(tlb, " sprite_t2 %*[^,],%d,%d%*s\n", &xsz, &ysz);
        if (n == 2) break;
    }
l2: for(;;) {
        if (feof(stdin)) goto l3;
        gets(tlb);
        if (feof(stdin) && !strcmp(tlb, "EOF777")) goto l3;
        puts(tlb);
        if (strstr(tlb, "data") == tlb) break;
        strcpy(tlb, "EOF777");
    }
    puts("   if !RLE");
    q = 0;
    for (k = 0; k < ysz; k++) {
	    for(;;) {
	        n = scanf(" byte $%x, ", &data[q++]);
	 	    if (n == 1) break;
		    gets(tlb);
	    }
	    for(i = 1; i < xsz - 1; i++)
		    scanf("$%x , ", &data[q++]);
	    scanf("$%x ", &data[q++]);
    }
    if (q != xsz*ysz) {
        puts("ERROR!");
        return 1;
    }
    n = 0;
    for (k = 0; k < ysz; k++) {
        printf("  byte ");
	    for(i = 0; i < xsz - 1; i++)
		    printf("$%02x,", data[n++]);
	   printf("$%02x\n", data[n++]);
    }
    puts("   else;rle");
    q = 0;
    for (i = 0; i < xsz*ysz; i++) {
        k = range(i, xsz*ysz, data);
        if (k < i + 3)
            odata[q++] = data[i];
        else {
            odata[q++] = 128 + k - i;
            odata[q++] = data[i];
            i += k - i - 1;
        }
    }
    for (i = 0, n = 0;;) {
        printf("  byte ");
        for (k = 0; k < xsz - 1; k++) {
            printf("$%02x", odata[i++]);
            if (i < q)
                printf(",");
            else {
                n = 1;
                puts("");
                break;
            }
        }
        if(n) break;
        printf("$%02x\n", odata[i++]);
        if (i == q) break;
    }
    printf("   endif  ;%d/%d +%d %.2f%\n", q, xsz*ysz, xsz*ysz - q, 100.*q/xsz/ysz);
    totali += xsz*ysz;
    totalq += q;
    goto l2;
l3:
    printf(";rle= %d/%d +%d %.2f%\n", totalq, totali, totali - totalq, 100.*totalq/totali);
l1:
    return 0;
}


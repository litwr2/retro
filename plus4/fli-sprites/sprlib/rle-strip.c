/* removes RLE variants */
#include <stdio.h>
#include <string.h>
int main() {
    int i, k;
    char tlb[128] = "";
    for(;;) {
		for(;;) {
		    gets(tlb);
		    if (strstr(tlb, ";rle=") == tlb) goto l1;
		    if (strstr(tlb, "!RLE") && strstr(tlb, "if")) break;
		    puts(tlb);
		}
		for(;;) {
		    gets(tlb);
		    if (strstr(tlb, "else;rle")) break;
		    puts(tlb);
		}
		for(;;) {
		    gets(tlb);
		    if (strstr(tlb, "endif")) break;
		}
    }
l1:
    return 0;
}


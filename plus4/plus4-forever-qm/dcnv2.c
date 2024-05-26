#include <stdio.h>

FILE *fi, *fo;

void out1 (unsigned char c, unsigned char prev) {
  if (c < 33 || c > 128 || prev < 0x83)
    fprintf(fo, " %02x", c);
  else
    fprintf(fo, " %c", c);
}

main() {
  unsigned char buf[1024*400], prev = 0;
  int sz, i, j = 0;

  fi = fopen("iecdebug.bin", "rb");
  fo = fopen("iecdebu2.txt", "w");

  sz = fread(buf, 1, 1024*400, fi);
  i = 0;
  while (sz > i) {
    prev = buf[i];
    fprintf(fo, "%02x:", prev);
    out1(buf[i + 1], prev);
    j = 2;
    i += 2;
    while (prev == buf[i] && i < sz) {
      out1(buf[i + 1], prev);
      i += 2;
      if (j++ > 24) {
        fprintf(fo, "\n");
        j = 0;
      }
    }
    if (j != 0)
      fprintf(fo, "\n");
  }
  close(fi);
  close(fo);
}

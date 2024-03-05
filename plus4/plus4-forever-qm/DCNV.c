#include <stdio.h>

FILE *fi, *fo;








main() {
  unsigned char buf[1024*60], prev = 0;
  int sz, i, j = 0;

  fi = fopen("iecdebug.bin", "rb");
  fo = fopen("iecdebug.txt", "w");

  sz = fread(buf, 1, 1024*60, fi);
  i = 0;
  while (sz > i) {
    prev = buf[i];
    fprintf(fo, "%02x: %02x", prev, buf[i+1]);
    j = 2;
    i += 2;
    while (prev == buf[i] && i < sz) {
      fprintf(fo, " %02x", buf[i+1]);
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

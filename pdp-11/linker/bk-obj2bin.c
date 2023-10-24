//obj to raw binary
#include <stdio.h>
#include <string.h>
#define MAX_PRG_SZ 65536
#define BUF_SZ 128

int main(int argc, char **argv) {
   char buf[BUF_SZ];
   short prg[MAX_PRG_SZ];
   FILE *fin, *fout;
   int l, addr, len, len_sum = 0, pc = 2, line = 0, mod, mod2, f = 0;
   fputs("Macro-11 linker for the BK, v2\n", stderr);
   if (argc != 1 && argc != 3) {
      fputs("Run this program without arguments, e.g., obj2bin <IN >OUT\n", stderr);
      fputs("Or run it with two arguments, e.g., obj2bin IN OUT\n", stderr);
      return 1;
   }
   if (argc == 1) {
      fin = stdin;
      fout = stdout;
   } else {
      fin = fopen(argv[1], "r");
      if (fin == 0) {
         fputs("Can't open the file to read\n", stderr);
         return 5;
      }
      fout = fopen(argv[2], "w");
      if (fout == 0) {
         fputs("Can't open the file to write\n", stderr);
         return 4;
      }
   }
   for (;;) {
      fgets(buf, 80, fin);
      line++;
      l = sscanf(buf, "TEXT ADDR=%o LEN=%o\n", &addr, &len_sum);
      if (addr%2) {
          fprintf(stderr, "Odd start address\n");
          return 3;
      }
      if (l == 2) break;
   }
   for(;;) {
      int cpc, cpc2;
      fgets(buf, BUF_SZ, fin);
mainloop:
      buf[37] = 0;
      line++;
      l = sscanf(buf, " %o: %o %o %o %o %*s\n", &cpc,
               prg + pc, prg + pc + 1, prg + pc + 2, prg + pc + 3);
      if (l == 0) {
         l = sscanf(buf, "TEXT ADDR=%o LEN=%o\n", &cpc2, &len);
         if (l == 2) {
            len_sum += len;
            continue;
         }
         if (strstr(buf, "RLD")) {
            fgets(buf, BUF_SZ, fin);
            line++;
            l = sscanf(buf, " Location counter modification %o", &mod);
            if (l == 1) {
               pc = mod/2 + 2 - addr/2;
               continue;
            }
repeatit:
            l = sscanf(buf, " Internal displaced %o=%o ", &mod, &mod2);
            if (l == 2) {
                prg[mod/2 - addr/2 + 2] = mod2 - mod - 2;
                fgets(buf, BUF_SZ, fin);
                goto repeatit;
            }
            l = sscanf(buf, " Internal %o=%o ", &mod, &mod2);
            if (l == 2) {
                fgets(buf, BUF_SZ, fin);
                goto repeatit;
            }
            goto mainloop;
         }
         break;
      }
      pc += l - 1;
   }
   prg[0] = addr;
   prg[1] = (pc - 2)*2;
   fprintf(stderr, "@%x %x>=%x lines=%d\n", addr, (pc - 2)*2, len_sum, line);
   if (!strstr(buf, "ENDMOD")) {
      fprintf(stderr, "Possible wrong relocation @%x/%o!\n", mod, mod);
      return 2;
   }
   fwrite(prg, pc, 2, fout);
   if (argc == 3) {
      fclose(fout);
      fclose(fin);
   }
   return 0;
}


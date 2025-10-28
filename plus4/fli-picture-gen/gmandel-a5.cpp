#include <iostream>
#include <cstdlib>
#include <string>
#include <map>
using namespace std;

#define xmax 80
#define ymax 128

#define BSZ 512
#define VS 280
#define HS 160
int oneblack[121];
int picr[HS][VS], mc1[VS], mc2[VS];
struct Cell {
   int c1, c2;
} cell[HS/4][VS/2];
int vs, hs;
#include "../fli-picture-conv/p4prg.cpp"
int getR(int c) {
   return c >> 16;
}
int getG(int c) {
   return (c >> 8)&255;
}
int getB(int c) {
   return c&255;
}

void mandel() {
    struct D {
        double y[2], x[2];
        int iter;
    };
    struct D data = 
//    {{-1.24, 1.24}, {-2.25, .75}, 121};
//    {{-1.3, 1.3}, {-2,.5}, 121};
    {{-1.15, 1.15}, {-1.95,.5}, 121};
    int maxiter = data.iter;
    double syl = data.y[0], syu = data.y[1];
    double sxl = data.x[0], sxu = data.x[1];
    for (int px = 0; px < xmax; px++)
        for (int py = 0; py < ymax/2; py++) {
            double x0 = (sxu-sxl)*px/(xmax - 1) + sxl, y0 = (syu-syl)*py/(ymax - 1) + syl, x2 = 0, y2 = 0, x = 0, y = 0;
            int iter = maxiter, xiter;
            while (x2 + y2 <= 4 && iter != 0) {
                y = 2*x*y + y0;
                x = x2 - y2 + x0;
                x2 = x*x;
                y2 = y*y;
                iter--;
            }
            picr[2*px][2*py] = picr[2*px + 1][2*py] = picr[2*px][2*py + 1] = picr[2*px + 1][2*py + 1] =
                picr[2*px][2*(ymax - 1 - py)] = picr[2*px + 1][2*(ymax - 1 - py)] =
                picr[2*px][2*(ymax - py) - 1] = picr[2*px + 1][2*(ymax - py) - 1] = n2rgb[oneblack[iter]]; //n2rgb[iter^0x70];
        }
    for (int y = 0; y < ymax*2; y += 2)
		    for (int x = 0; x < xmax*2; x += 4){
	                cell[x/4][y/2].c1 = picr[x][y];
	                cell[x/4][y/2].c2 = picr[x + 2][y];
		    }
}

void bubble_sort(int *a) {
    bool epf;
    int UBound = 120;
    do {
        epf = false;
        for (int i = 0; i < UBound; ++i)
            if ((a[i]&0xf) > (a[i + 1]&0xf) || (a[i]&0xf) == (a[i + 1]&0xf) && (a[i]&0xf0) > (a[i + 1]&0xf0)) {
                swap(a[i], a[i + 1]);
                epf = true;
            }
        --UBound;
    }
    while (epf);
}

int main(int argc, char **argv) {
    FILE *fi, *fo;
    unsigned char b[3];

    hs = 1;
    for (int i = 0; i < 128; i++)
        if ((i&0xf) != 0) oneblack[hs++] = i;
    bubble_sort(oneblack);

    hs = xmax*2;
    vs = ymax*2;
	prginit();
    mandel();
	fo = fopen("out-a5.ppm", "w");
	fprintf(fo, "P6\n160 256\n255\n");
	for (int y = 0; y < ymax*2; y++)
	    for (int x = 0; x < xmax*2; x++) {
	            b[0] = getR(picr[x][y]);
	            b[1] = getG(picr[x][y]);
	            b[2] = getB(picr[x][y]);
				fwrite(b, 1, 3, fo);
			};
	fclose(fo);
	fi = fopen("out.prg", "r");
	if (fi == 0) {
	    fprintf(stderr, "out.prg not found\n");
        return 5;
	}
	int co = fread(prg + 0xfff, 1, 65536, fi);
	fclose(fi);
	setattr();
	setbm();
	fo = fopen("out-a5.prg", "w");
	fwrite(prg + 0xfff, 1, co, fo);
	fclose(fo);
    return 0;
}


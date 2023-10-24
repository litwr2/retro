#include <iostream>
#include <sstream>
#include <cstdlib>
#include <cmath>
#include <string>
#include <set>
#include <FL/Fl.H>
#include <FL/Fl_Window.H>
#include <FL/Fl_Box.H>
#include <FL/Fl_Button.H>
#include <FL/Fl_Choice.H>
#include <FL/fl_ask.H>
#include <FL/fl_draw.H>
using namespace std;

#define xmax 256
#define ymax 256
#define bpp 4

#define idx -5
#define idy 5
#define ix0 (-dx*xmax/2-384)
#define niter 4095

Fl_Window *gwindow;
typedef unsigned short TAB;
typedef signed short STAB;
TAB sqr[16384];
TAB sqra(int n) {
    if (n < 0 || n > 16383) {cerr << n << endl; throw 1;}
    return sqr[n];
}

void mandel_bk() {
    static TAB dy = idx;
    static TAB dx = idy;
    static TAB x0 = ix0;
    static int iter = niter;
    double r4, r5, r0, r1, r3;
    int r2, px = 0, py = 0;
    r5 = dy*128;
loop0:    //py step
    r4 = x0;
loop2:    //px step
    r4 += dx;
    r2 = iter;
    r0 = r4;
    r1 = r5;
loc1:
    r3 = r1*r1;
    r1 += r0;
    r0 = r0*r0;
    r0 += r3;
    if (r0 >= 4) goto loc2;
    r1 = r1*r1;
    r1 -= r0;
    r1 += r5;
    r0 -= r3;
    r0 -= r3;
    r0 += r4;
    if (--r2 != 0) goto loc1;
loc2:
    fl_color(r2%8);
    fl_point(255 - 2*px, py);
    fl_point(254 - 2*px, py);
    fl_point(255 - 2*px, 255 - py);
    fl_point(254 - 2*px, 255 - py);
    if (++px != 128) goto loop2;
    px = 0;
    r5 -= dy;
    if (++py != 128) goto loop0;
    iter++;
}
double cnv(STAB n) {
    return n/512.;
}
void mandel_bk_tab() {
    static TAB dy = idx;
    static TAB dx = idy;
    static TAB x0 = ix0;
    static int iter = niter;
    TAB r4, r5, r0, r1, r3;
    int r2, px = 0, py = 0, r, g, b;
try {
    r5 = dy*128;
loop0:    //py step
    r4 = x0;
loop2:    //px step
    r4 += dx;
    r2 = iter;
    r0 = r4;
    r1 = r5;
loc1:
    r3 = sqra((TAB)((STAB)(r1&0xfffe) + 8192));
    r1 += r0;
    r0 = sqra((TAB)((STAB)(r0&0xfffe) + 8192));
    r0 += r3;
    if (r0 >= 2048) goto loc2;
    r1 = sqra((TAB)((STAB)(r1&0xfffe) + 8192));
    r1 -= r0;
    r1 += r5;
    r0 -= r3;
    r0 -= r3;
    r0 += r4;
    if (--r2 != 0) goto loc1;
loc2:
    if (bpp == 4)
       b =  (r2 & 15)<<4, g = ((r2>>4)&15)<<4, r = ((r2>>8)&15)<<4;
    else if (bpp == 2)
       r = (r2 & 3)<<6, g = ((r2>>2)&3)<<6, b = ((r2>>4)&3)<<6;
    else
       r = (r2 & 1)<<7, g = ((r2>>1)&1)<<7, b = ((r2>>2)&1)<<7;
    fl_color(fl_rgb_color(r, g, b));
    fl_point(255 - px, py);
    fl_point(255 - px, 255 - py);
    if (++px != 256) goto loop2;
    px = 0;
    r5 -= dy;
    if (++py != 128) goto loop0;
    iter++;
//cout << iter << ' ' << cnv(x0) << ' ' << cnv(dx) << ' ' << cnv(dy) << ' ' << cnv(mx) << endl;
}
catch (int) {
    cerr << "catched\n";
}
}

class Drawing : public Fl_Widget {
   void draw() {
       mandel_bk_tab();
       //mandel_bk();
   }
public:
    Drawing(int X, int Y, int W, int H) : Fl_Widget(X, Y, W, H) {}
    ~Drawing() {}
} *gdrawing;

void callback(void*) {
    gwindow->redraw();
    Fl::repeat_timeout(.2, callback);
}

void button1_callback(Fl_Widget *w) {
    static int count = 1;
//    cout << ++count << endl;
    gwindow->redraw();
}

void button2_callback(Fl_Widget *w) {
   std::exit(0);
}

void fill_sqr() {
    TAB *r4 = sqr+8192, *r5 = sqr+8192;
    TAB r2 = 0, stack, r3;
    unsigned r0 = 0, r1 = 0;
fstr:
    *r5 = r1&0xffff, r5 += 2;
    r2++;
    stack = r2;
    r2 *= 2;
    r2 = ((r2&255) << 8) + ((r2 >> 8) & 255);  //swap
    r3 = r2&255;
    r0 += r2;
    if (r0 > 65535) r0 -= 65536, r1++;
    r1 += r3;
    r4 -= 2, *r4 = r1 & 0xffff;
    r2 = stack;
    if (r1 > 65535) return;
    r2++;
    goto fstr;
}
int main(int argc, char **argv) {
    fill_sqr();
    Fl_Window window(340, 80, "Mandel Proxy");
    Fl_Button button1(10, 10, 320, 20, "Step");
    button1.labelsize(12);
    button1.callback(button1_callback);
    Fl_Button button2(10, 40, 320, 20, "Exit");
    button2.labelsize(12);
    button2.callback(button2_callback);
    window.end();
    window.show();

    gwindow = new Fl_Window(xmax, ymax, "mandel");
    gdrawing = new Drawing(0, 0, xmax, ymax);
    gwindow->resizable(*gdrawing);
    gwindow->position(500, 0);
    gwindow->end();
    gwindow->show();
    //Fl::add_timeout(.2, callback);
    int r = Fl::run();
    return 0;
}


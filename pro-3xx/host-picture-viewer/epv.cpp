#include <iostream>
#include <sstream>
#include <fstream>
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

Fl_Window *gwindow;

int xmax, ymax, bpp;

#define DSZ 100000
unsigned short gdata[DSZ];

int gd(int x, int y, int o) {
   int p = gdata[256 + y*64 + x*bpp/16 + o*xmax*ymax*bpp/16];
   return (p >> x%(16/bpp)*bpp & (1 << bpp) - 1)*256/(1 << bpp);
}

class Drawing : public Fl_Widget {
   void draw() {
    for (int y = 0; y < ymax; ++y)
       for (int x = 0; x < xmax; ++x) {
            fl_color(fl_rgb_color(gd(x, y, 0), gd(x, y, 1), gd(x, y, 2)));
            fl_point(x, y);
        }
   }
public:
    Drawing(int X, int Y, int W, int H) : Fl_Widget(X, Y, W, H) {}
    ~Drawing() {}
} *gdrawing;

int main(int argc, char **argv) {
    ifstream fo(argv[1]);
    if (!fo) {
       cerr << "file can’t be opened for read\n";
       return 1;
    }
    fo.read((char*)gdata, DSZ*2);
    unsigned long int total = fo.gcount();
    xmax = gdata[1];
    ymax = gdata[2];
    bpp = gdata[3];
    fo.close();

    gwindow = new Fl_Window(xmax, ymax, argv[1]);
    gdrawing = new Drawing(0, 0, xmax, ymax);
    gwindow->resizable(*gdrawing);
    gwindow->position(500, 0);
    gwindow->end();
    gwindow->show();
    int r = Fl::run();
    return 0;
}


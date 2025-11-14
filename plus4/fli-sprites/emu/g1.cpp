#include <iostream>
#include <sstream>
#include <cstdlib>
#include <cmath>
#include <string>
#include <map>
#include <set>
#include <FL/Fl.H>
#include <FL/Fl_Window.H>
#include <FL/Fl_Box.H>
#include <FL/Fl_Button.H>
#include <FL/Fl_Choice.H>
#include <FL/fl_ask.H>
#include <FL/fl_draw.H>
#include "../../fli-picture-conv/p4colors.h"
using namespace std;

#define xmax 160
#define ymax 256

#define x_scale 4
#define y_scale 2

#define Xmax (xmax*x_scale)
#define Ymax (ymax*y_scale)

#include "../../fli-picture-gen/flilib.c"
#include "eflilib.c"
#include "eflilib22.c"

Fl_Window *gwindow;
map<int, int> n2rgb, rgb2n;

int getR(int c) {
   return c >> 16;
}
int getG(int c) {
   return (c >> 8)&255;
}
int getB(int c) {
   return c&255;
}
void fillscr() {
    int c = 8, cs;
    for (int y = 0; y < ymax; y += 2)
        for (int x = 0; x < xmax; x += 2) {
            if ((x&2) == 0) cs = 2; else cs = 1;
            setbm(x, y, cs);
            setbm(x + 1, y, cs);
            setbm(x, y + 1, cs);
            setbm(x + 1, y + 1, cs);
            //setcolor22(x/2, y/2, 0x6e);
            //setcolor22(x/2, y/2, c);
            c = abs((x - y)/2)%128; if (c < 8) c = (c + 8); setcolor22(x/2, y/2, c);
            //c = y%128; if (c < 8) c = (c + 8); setcolor22(x/2, y/2, c);
            //c = x%128; if (c < 8) c = (c + 80); setcolor22(x/2, y/2, c);
            if (++c > 127) c = 8;
        }
//for(int x = 0; x < 40; x++) setcolu22(x*2, 127, 0x23, 0x54);
}

#include "sprites.cpp"
#include "sscroll.cpp"

class Drawing : public Fl_Widget {
    void draw() {
        for (int y = 0; y < ymax; y++)
        	for (int x = 0; x < xmax; x++) {
            	int c = n2rgb[getcolor(x, y)];
            	fl_color(getR(c), getG(c), getB(c));
            	for (int ys = 0; ys < y_scale; ys++)
                	for (int xs = 0; xs < x_scale; xs++)
                    	fl_point(x*x_scale + xs, y*y_scale + ys);
        }
   }
public:
    Drawing(int X, int Y, int W, int H) : Fl_Widget(X, Y, W, H) {}
    ~Drawing() {}
} *gdrawing;

void button1_callback(Fl_Widget *w) {
    s1.put();
    gdrawing->damage(1, s1.xpos*x_scale, s1.ypos*y_scale, s1.xsize*x_scale*2, s1.ysize*y_scale*2);
}

void button2_callback(Fl_Widget *w) {
    s1.remove();
    gdrawing->damage(1, s1.xpos*x_scale, s1.ypos*y_scale, s1.xsize*x_scale*2, s1.ysize*y_scale*2);
}

void button3_callback(Fl_Widget *w) {
    s1.up();
    gdrawing->damage(1, s1.xpos*x_scale, s1.ypos*y_scale, s1.xsize*x_scale*2, (s1.ysize + 1)*y_scale*2);
}

void button4_callback(Fl_Widget *w) {
    s1.down();
    gdrawing->damage(1, s1.xpos*x_scale, (s1.ypos - 2)*y_scale, s1.xsize*x_scale*2, (s1.ysize + 1)*y_scale*2);
}

void button5_callback(Fl_Widget *w) {
    s1.left();
    //gdrawing->redraw();
    gdrawing->damage(1, s1.xpos*x_scale, s1.ypos*y_scale, (s1.xsize + 1)*x_scale*2, s1.ysize*y_scale*2);
}

void button6_callback(Fl_Widget *w) {
    s1.right();
    //gdrawing->redraw();
    gdrawing->damage(1, (s1.xpos - 2)*x_scale, s1.ypos*y_scale, (s1.xsize + 1)*x_scale*2, s1.ysize*y_scale*2);
}

void button7_callback(Fl_Widget *w) {
    s1.downleft();
    gdrawing->damage(1, s1.xpos*x_scale, (s1.ypos - 2)*y_scale, (s1.xsize + 1)*x_scale*2, (s1.ysize + 1)*y_scale*2);
}

void button8_callback(Fl_Widget *w) {
    s1.downright();
    gdrawing->damage(1, (s1.xpos - 2)*x_scale, (s1.ypos - 2)*y_scale, (s1.xsize + 1)*x_scale*2, (s1.ysize + 1)*y_scale*2);
}

void button9_callback(Fl_Widget *w) {
    s1.upleft();
    gdrawing->damage(1, s1.xpos*x_scale, s1.ypos*y_scale, (s1.xsize + 1)*x_scale*2, (s1.ysize + 1)*y_scale*2);
}

void button10_callback(Fl_Widget *w) {
    s1.upright();
    gdrawing->damage(1, (s1.xpos - 2)*x_scale, s1.ypos*y_scale, (s1.xsize + 1)*x_scale*2, (s1.ysize + 1)*y_scale*2);
}
void buttonC_callback(Fl_Widget *w) {
    if (s1.visible) {
		s1.remove();
        s1.xpos = xmax/2;
        s1.ypos = ymax/2;
		s1.put();
		gdrawing->redraw();
    } else
        s1.xpos = xmax/2, s1.ypos = ymax/2;
}
void buttonSU_callback(Fl_Widget *w) {
    if (s1.visible) {
		s1.remove();
        sscroll_up8f();
//        sscroll_up4f();
//        sscroll_up();
		s1.put();
		gdrawing->redraw();
    }
}
void buttonSD_callback(Fl_Widget *w) {
    gdrawing->redraw();
}
void buttonX_callback(Fl_Widget *w) {
    std::exit(0);
}

void init() {
    for (int i = 0; i < 128; i++)
        rgb2n[p4palette[i][1]] = p4palette[i][0],
        n2rgb[p4palette[i][0]] = p4palette[i][1];
    fillscr();
}

int main(int argc, char **argv) {
    init();
    gwindow = new Fl_Window(Xmax, Ymax, "Sprites");
    gdrawing = new Drawing(0, 0, Xmax, Ymax);
    gwindow->resizable(0);
    gwindow->position(500, 0);
    gwindow->end();
    gwindow->show();

    Fl_Window window(340, 250, "Sprite type 1 Control Center");
    window.position(700,0);
    Fl_Button button1(10, 10, 320, 20, "Put");
    button1.labelsize(12);
    button1.callback(button1_callback);
    Fl_Button button2(10, 40, 320, 20, "Remove");
    button2.labelsize(12);
    button2.callback(button2_callback);
    Fl_Button button3(10, 70, 150, 20, "Up");
    button3.labelsize(12);
    button3.callback(button3_callback);
    Fl_Button button4(180, 70, 150, 20, "Down");
    button4.labelsize(12);
    button4.callback(button4_callback);
    Fl_Button button5(10, 100, 150, 20, "Left");
    button5.labelsize(12);
    button5.callback(button5_callback);
    Fl_Button button6(180, 100, 150, 20, "Right");
    button6.labelsize(12);
    button6.callback(button6_callback);
    Fl_Button button7(10, 130, 150, 20, "Down-Left");
    button7.labelsize(12);
    button7.callback(button7_callback);
    Fl_Button button8(180, 130, 150, 20, "Down-Right");
    button8.labelsize(12);
    button8.callback(button8_callback);
    Fl_Button button9(10, 160, 150, 20, "Up-Left");
    button9.labelsize(12);
    button9.callback(button9_callback);
    Fl_Button button10(180, 160, 150, 20, "Up-Right");
    button10.labelsize(12);
    button10.callback(button10_callback);
    Fl_Button buttonSU(10, 190, 150, 20, "Scroll Up");
    buttonSU.labelsize(12);
    buttonSU.callback(buttonSU_callback);
    Fl_Button buttonSD(180, 190, 150, 20, "Scroll Down");
    buttonSD.labelsize(12);
    buttonSD.callback(buttonSD_callback);
    Fl_Button buttonC(10, 220, 150, 20, "Center");
    buttonC.labelsize(12);
    buttonC.callback(buttonC_callback);
    Fl_Button buttonX(180, 220, 150, 20, "Exit");
    buttonX.labelsize(12);
    buttonX.callback(buttonX_callback);
    window.end();
    window.show();

    int r = Fl::run();
    return 0;
}


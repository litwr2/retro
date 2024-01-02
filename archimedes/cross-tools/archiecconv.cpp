/*
The Archimedes Color Converter v2, Litwr, 2023
it converts colors of the PPM P6 image to the Archimedes/VIDC1 colors
it may not be optimal, but it must be close to optimal
it calculates color distances using RGB coordinates
USAGE:
   archiecconv <input.ppm >output.ppm 2>color-tranlation-information.log
*/
#include<iostream>
#include<iomanip>
#include<cstring>
#include<cmath>
#include<map>
#include<set>
#include<list>
#include<deque>
#include<climits>
#define BSZ 512
#define msqr(a) ((a)*(a))
using namespace std;
inline int getR(int c) {
   return c >> 16;
}
inline int getG(int c) {
   return (c >> 8)&255;
}
inline int getB(int c) {
   return c&255;
}
int find_max(const deque<list<map<int, int>::iterator>> &p) {
    int m = 0, x;
    for (auto i = p.begin(); i != p.end(); i++)
        if (m < i->size()) m = i->size(), x = i - p.begin();
    return x;
}
void split(deque<list<map<int, int>::iterator>> &p, int k) {
   int minR = INT_MAX, maxR = 0;
   int minG = INT_MAX, maxG = 0;
   int minB = INT_MAX, maxB = 0;
   for (auto i = p[k].begin(); i != p[k].end(); i++) {
       if (minR > getR((*i)->first)) minR = getR((*i)->first);
       if (maxR < getR((*i)->first)) maxR = getR((*i)->first);
       if (minG > getG((*i)->first)) minG = getG((*i)->first);
       if (maxG < getG((*i)->first)) maxG = getG((*i)->first);
       if (minB > getB((*i)->first)) minB = getB((*i)->first);
       if (maxB < getB((*i)->first)) maxB = getB((*i)->first);
   }
   list<multimap<int, int>::iterator> l1, l2;
   if (maxR - minR >= maxG - minG && maxR - minR >= maxB - minB) {
       double v = (maxR + minR)/2.;
       for (auto i = p[k].begin(); i != p[k].end(); i++)
           if (getR((*i)->first) < v)
               l1.push_back(*i);
           else
               l2.push_back(*i);
   } else if (maxB - minB > maxG - minG && maxB - minB >= maxR - minR) {
       double v = (maxB + minB)/2.;
       for (auto i = p[k].begin(); i != p[k].end(); i++)
           if (getB((*i)->first) < v)
               l1.push_back(*i);
           else
               l2.push_back(*i);
   } else {
       double v = (maxG + minG)/2.;
       for (auto i = p[k].begin(); i != p[k].end(); i++)
           if (getG((*i)->first) < v)
               l1.push_back(*i);
           else
               l2.push_back(*i);
   }
   p.erase(p.begin() + k);
   p.push_back(l1);
   p.push_back(l2);
}
inline int cdistance(int c1, int c2) {
     return msqr(getR(c1) - getR(c2)) + msqr(getB(c1) - getB(c2)) + msqr(getG(c1) - getG(c2));
}
int find_best(const list<map<int, int>::iterator> &l) {
    int r = 0, g = 0, b = 0;
    for (auto p = l.begin(); p != l.end(); p++) {
       r += getR((*p)->first);
       g += getG((*p)->first); 
       b += getB((*p)->first);
    }
    r = r/l.size() + (r%l.size() > l.size()/2);
    g = g/l.size() + (g%l.size() > l.size()/2);
    b = b/l.size() + (b%l.size() > l.size()/2);
    return (r << 16) + (g << 8) + b;
}
int main() {
    map<int, int> clist, cclist;
    multimap<int, int> rclist;
    list<int> data;
    unsigned char b[BSZ];
    int vs, hs, t;
    fgets((char*)b, BSZ, stdin);
    fputs((char*)b, stdout);
    if (strstr((char*)b, "P6") != (char*)b) {
E1:     fprintf(stderr, "incorrect format\n");
        return 2;
    }
    do {
       fgets((char*)b, BSZ, stdin);
       fputs((char*)b, stdout);
    } while (b[0] == '#');
    t = sscanf((char*)b, "%d %d", &hs, &vs);
    if (t != 2) goto E1;
    fgets((char*)b, BSZ, stdin);
    fputs((char*)b, stdout);
    t = atoi((char*)b);
    if (t != 255) goto E1;  //wrong format
    do {
        fread(b, 1, 3, stdin);
        if (feof(stdin)) break;
        b[0] = b[0]/16;
        b[1] = b[1]/16;
        b[2] = b[2]/16;
        t = 65536*b[0] + 256*b[1] + b[2];
        data.push_back(t);
        if (clist.find(t) == clist.end()) {
            int z = ((b[0]&7)<<16) + ((b[1]&3)<<8) + (b[2]&7);
            clist[t] = 1, rclist.insert(pair<int, int>(z, t));
            if (cclist.find(z) == cclist.end())
               cclist[z] = 1;
            else
               cclist[z]++;
        } else
            clist[t]++;
    } while (1);
    /*t = 0;
    for (auto i = rclist.begin(); i != rclist.end(); i++)
        cout << t++ << ' ' << hex << i->first << ' ' << i->second << ' ' << dec << clist[i->second] << ' ' << cclist[i->first] << endl;*/
    deque<list<map<int, int>::iterator>> parts;
    {
		list<map<int, int>::iterator> l;
		for (auto i = cclist.begin(); i != cclist.end(); i++)
		    l.push_back(i);
		parts.push_back(l);
    }
    while (parts.size() != 16) {
        int i = find_max(parts);
        if (parts[i].size() <= 1) break;
        split(parts, i);
    }
    /* for (int i = 0; i < parts.size(); i++)
       cerr << "# " << i << ' ' << parts[i].size() << endl; */ 
    {
        deque<int> z;
        int f = 0;
        do {
		    f = 1;
		    for (int i = 0; i < parts.size(); i++)
		        z.push_back(find_best(parts[i]));
		    f = 0;
		    for (int i = 0; i < parts.size(); i++) {
                auto p = parts[i].begin();
                while (p != parts[i].end()) {
                    auto x = p++;
		            int k = cdistance(z[i], (*x)->first), min = INT_MAX, idx;
		            for (int j = 0; j < z.size(); j++) {
		                int d1 = cdistance(z[j], (*x)->first);
		                if (d1 < min) min = d1, idx = j;
		            }
		            if (min < k) {
		                f = 1;
		                parts[idx].push_back(*x);
		                parts[i].erase(x);
		            }
		        }
            }
	        z.clear();
        } while (f);
    }
    /*for (int i = 0; i < parts.size(); i++)
       cerr << "# " << i << ' ' << parts[i].size() << endl;*/
    cerr << "# N original archie/vdc1 distance\n";
    cerr << "# multiply each componend by 16 to get the real palette\n";
    map<int, int> pconv;
    double dsum = 0;
    t = 0;
    for (int i = 0; i < parts.size(); i++) {
        int b = find_best(parts[i]);
        for (auto p = parts[i].begin(); p != parts[i].end(); p++) {
            auto q = rclist.lower_bound((*p)->first);
            for (int k = 0; k < (*p)->second; k++, q++) {
               int z = q->second, y = (z&0x80c08) + b;
               double d = sqrt(cdistance(z, y));
               dsum += d;
               cerr << dec << t++ << ' ' << hex << setfill('0') << setw(6) << z << ' '<< setw(6) << y << ' ' << setprecision(2) << d << endl;
               pconv.insert(pair<int, int>(z, y));
            }
        }
    }
    {
        set<int> s;
        for (auto i = pconv.begin(); i != pconv.end(); i++)
           s.insert(i->second);
        cerr << "# " << dec << clist.size() << " -> " << s.size() << ' ' << fixed << setprecision(2) << dsum/clist.size() << endl;
    }
    for (auto i = data.begin(); i != data.end(); i++) {
        t = pconv[*i];
        b[0] = getR(t)*16 + 8;
        b[1] = getG(t)*16 + 8;
        b[2] = getB(t)*16 + 8;
        fwrite(b, 1, 3, stdout);
    }
    return 0;
}


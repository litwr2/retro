{Picture Viewer for Express Pascal}
const
   stdpal: array[0..15]of array[0..2]of byte = (
      (0, 0, 0),
      (0, 0, 192),
      (0, 192, 0),
      (0, 192, 192),
      (192, 0, 0),
      (192, 0, 192),
      (192, 192, 0),
      (192, 192, 192),
      (64, 64, 64),
      (64, 64, 255),
      (64, 255, 64),
      (64, 255, 255),
      (255, 64, 64),
      (255, 64, 255),
      (255, 255, 64),
      (255, 255, 255));
var
   i, k, p, l, c: integer;
   fass: file;
   ftext: text;
   buf: array [0..2048] of byte;
   count: word;
   s: string[8];
function findpal(r, g, b: byte): byte;
    label L;
    var i: byte;
    begin
        for i := 0 to 15 do
            if (r = stdpal[i][0]) and (g = stdpal[i][1]) and (b = stdpal[i][2]) then goto L;
L:      findpal := i
    end;
procedure togr;
    begin
        inline($3e / $3c / $f3 / $32 / $7f / $fa)
    end;
procedure tostd;
    begin
        inline($3e / $1c / $32/ $7f / $ff / $fb)
    end;
begin
   write('Enter the picture filename without its extension: ');
   readln(s);
   assign(ftext, s + '.PAL');
   reset(ftext);
   clrscr;
   write(#27';');
   clrgscr;
   for i := 0 to 15 do begin
       readln(ftext, k, p, l, c);
       mem[$fafb] := k + findpal(p, l ,c)*16
   end;
   close(ftext);
   assign(fass, s + '.PIC');
   reset(fass, 1);
   togr;
   for i := 0 to 16384 do
       mem[$4000 + i] := 255;
   tostd;
   for k := 1 to 3 do begin
       p := $4000;
       mem[$fabf] := $71 + ((1 shl k) xor $e);
       for i := 0 to 7 do begin
           blockread(fass, buf, 2048, count);
           togr;
           for l := 0 to 2047 do
               mem[p + 2048*i + l] := buf[l];
           tostd
       end
   end;
   close(fass);
   repeat until keypressed
end.


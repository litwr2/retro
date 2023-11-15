{Picture Viewer, Express Pascal variant}
{compile it to disk}
{$M ,$BEFF}
label
   L1, L2, L3, L4, L5, L6;
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
   pal: array[0..15]of byte;
   count: word;
   f: string[9];
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
        inline($3e / $6c / $f3 / $32 / $7f / $fa)
    end;
procedure tostd;
    begin
        inline($3e / $1c / $32/ $7f / $bf / $fb)
    end;
begin
   f := paramstr(1);
   if (paramcount > 1)or(paramcount = 1)and((length(f) > 8)or(pos('?', f) <> 0)or(pos('.', f) <> 0)or(f[1] = '-')) then begin
       writeln('USAGE: vp PICTURE-FILE-WITHOUT-FILENAME-EXTENSION');
       exit
   end;
   if (paramcount = 1) then
       goto L6;
   write('Enter the picture filename without its extension: ');
   readln(f);
L6:for i := 0 to 15 do
      pal[i] := i*17;
   write(#31#27';');
   assign(ftext, f + '.PAL');
{$I-}   
   reset(ftext);
{$I+}
   if ioresult <> 0 then goto L2;
   for i := 0 to 15 do begin
       readln(ftext, k, p, l, c);
       pal[i] := k + findpal(p, l ,c)*16
   end;
   close(ftext);
L2:assign(ftext, f + '.CHR');
{$I-}
   reset(ftext);
{$I+}
   if ioresult <> 0 then goto L1;
   repeat
      readln(ftext, i);
      if i = 0 then goto L3;
      write(chr(i));
   until false;
L3:close(ftext);
L1:assign(fass, f + '.PIC');
{$I-}
   reset(fass, 1);
{$i+}
   if ioresult <> 0 then begin
      writeln(f, '.pic is not found');
      goto L4
   end;
   for i := 0 to 15 do
      mem[$fafb] := pal[i];
   mem[$fabf] := $80;
   togr;
   for i := 0 to 16383 do
       mem[$c000 + i] := 255;
   tostd;
   for k := 1 to 3 do begin
       mem[$fabf] := $71 + ((1 shl k) xor $e);
       for i := 0 to 7 do begin
           blockread(fass, buf, 2048, count);
           if count <> 2048 then goto L5;
           togr;
           for l := 0 to 2047 do
               mem[$c000 + 2048*i + l] := buf[l];
           tostd
       end
   end;
L5:close(fass);
L4:f[1] := readkey;
   clrscr
end.


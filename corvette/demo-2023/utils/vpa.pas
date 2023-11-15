{Picture Viewer, Pascal MT+ variant}
{compilation:
   MTPLUS VPA
   LINKMT VPA,PASLIB/S
}
program vp;
label
   1, 2, 3, 4, 5, 6, 8;
const
   paldata = '000003030033300303330333111114141144411414441444';
var
   i, k, p, l, c: integer;
   kbd: file of char;
   fass: file;
   ftext: text;
   buf: array [0..2048] of byte;
   stdpal: array[0..15]of array[0..2]of byte;
   pal: array[0..15]of byte;
   f: string[8];
   mem: absolute [0] array[0..1]of byte; (* range check must be disabled! *)
function findpal(r, g, b: byte): byte;
    label 1;
    var i: byte;
    begin
        for i := 0 to 15 do
            if (r = stdpal[i][0]) and (g = stdpal[i][1]) and (b = stdpal[i][2]) then goto 1;
1:      findpal := i
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
   inline($21 / $ff / $be / $f9);
   for i := 0 to 15 do begin
      for k := 0 to 2 do begin
         f := copy(paldata, i*3 + k + 1, 1);
         p := (ord(f[1]) - 48)*64;
         if p = 256 then p := 255;
         stdpal[i][k] := p
      end;
      pal[i] := i*17
   end;
   l := mem[$80];
   p := $81;
   f := '';
   if l > 1 then begin
      while(mem[p] = 32) do p := p + 1;
      while(mem[p] <> 32)and(length(f) < 8)and(l > p - $81) do begin
          f := concat(f, chr(mem[p]));
          p := p + 1
      end;
      if (length(f) = 0)or(mem[p] <> 32)and(l > p - $81) then
         goto 6;
      while(mem[p] = 32) do p := p + 1;
      if l > p - $81 then goto 6;
   end;
   if (pos('?', f) <> 0)or(pos('.', f) <> 0)or(f[1] = '-') then begin
6:     writeln('USAGE: vpa PICTURE-FILE-WITHOUT-FILENAME-EXTENSION');
       exit
   end;
   if length(f) <> 0 then goto 8;
   write('Enter the picture filename without its extension: ');
   readln(f);
8: write(chr(31),chr(27),';');
   assign(ftext, concat(f, '.PAL'));
   reset(ftext);
   if ioresult = 255 then goto 2;
   for i := 0 to 15 do begin
       readln(ftext, k, p, l, c);
       pal[i] := k + findpal(p, l ,c)*16
   end;
   close(ftext, i);
2: assign(ftext, concat(f, '.CHR'));
   reset(ftext);
   if ioresult = 255 then goto 1;
   repeat
      readln(ftext, i);
      if i = 0 then goto 3;
      write(chr(i))
   until false;
3: close(ftext, i);
1: assign(fass, concat(f, '.PIC'));
   reset(fass);
   if ioresult = 255 then begin
      writeln(f, '.pic is not found');
      goto 4
   end;
   for i := 0 to 15 do
      mem[$fafb] := pal[i];
   mem[$fabf] := $80;
   togr;
   for i := 0 to 16383 do
       mem[$c000 + i] := 255;
   tostd;
   for k := 1 to 3 do begin
       i := $e;
       clrbit(i, k);
       mem[$fabf] := $71 + i;
       for i := 0 to 7 do begin
           blockread(fass, buf, p, 2048, -1);
           if p <> 0 then goto 5;
           togr;
           for l := 0 to 2047 do
               mem[$c000 + 2048*i + l] := buf[l];
           tostd
       end
   end;
5: close(fass, i);
4: assign(kbd, 'kbd:');
   reset(kbd);
   read(kbd, f[1]);
   close(kbd, i);
   write(chr(31))
end.


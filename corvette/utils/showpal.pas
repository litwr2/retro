{shows palette, lists the border color}
var
   i,p:byte;
   c:char;
begin
   clrscr;
   clrgscr;
   for i:=0 to 15 do
      mem[$fafb] := i*17;
   write(#27,'6');
   for i:=0 to 31 do
      for p:=0 to 7 do
         mem[$fc20+p*64+i]:=32;
   write(#27,'7');
   for i:=0 to 7 do begin
      setcolor(i);
      rectangle(i*32, 0, i*32+31, 127, true);
      rectangle(i*32+256, 0, i*32+287, 127, true)
   end;
   p := 0;
   repeat
      gotoxy(9,9);write('   ');gotoxy(1,9);
      write('black is ', p);
      mem[$fafb] := p*16;
      p := (p+1)and 15;
      c := readkey
   until ord(c) = 27;
   clrscr
end.

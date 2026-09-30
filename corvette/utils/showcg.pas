{shows both char sets}
var
   i: byte;
   c: char;
begin
   clrscr;
   gotoxy(1,10);
   for i := 0 to 255 do mem[$fc00 + i] := i;
   repeat until keypressed; while keypressed do c := readkey;
   mem[$fb3a] := 4;
   repeat until keypressed; while keypressed do c := readkey;
   mem[$fb3a] := 0
end.

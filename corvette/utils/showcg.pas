{shows both char sets}
var
   i: byte;
   c: char;
begin
   clrscr;
   for i := 0 to 255 do mem[$fc00 + i] := i;
   repeat until keypressed; while keypressed do c := readkey;
   mem[$fb3a] := $c;
   repeat until keypressed; while keypressed do c := readkey;
   mem[$fb3a] := 8;
end.

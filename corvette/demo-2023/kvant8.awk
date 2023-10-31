/^msg1 +db/ { f = 1 }
/^msg2 +db/ { f = 2 }
/"3"/ && f == 1 {  f = 2; print; next }
/"/ && f == 2 {
   p = index($0, "\"")
   s = substr($0, 1, p)
   for (i = p + 1; i < length($0) - 1; i++) s = s substr($0, i, 1) " "
   s = s substr($0, length($0) - 1)
   print s
   f = 0
   next
}
{ print }

{
  if (index($0,"!") == 1)
    f = 1
  if (!f)
    a[$0] = 1
  else
    for (i in a) {
      p = index($0,i)
      c = index($0,";")
      if (p > 1)
        if (match(substr($0,p-1,1), "[^A-Za-z_0-9]"))
          if (length($0) == p + length(i) - 1 || match(substr($0,p+length(i),1), "[^A-Za-z_0-9]"))
            if (substr($0,p-1,1) != ":" && (c == 0 || c > p))
              print FILENAME, i
    }
}


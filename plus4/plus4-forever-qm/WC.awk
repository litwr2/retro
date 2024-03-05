# wc *.cod *.dat *.mac *.asm | awk -f wc.awk | sort

{ split($4,a,".")
  b[a[1]] += $1
  c[a[1]] += $2
  d[a[1]] += $3
  if (a[2] == "") total = $3 + 0.0001
}

END {
  for (i in b) 
    printf "%8d %8d %8d %8.2f %s\n", b[i], c[i], d[i], 100*d[i]/total, i
}


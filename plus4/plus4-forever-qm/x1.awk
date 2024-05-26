/^[^\\.; ][^:]+:/ {
  p = match($0, "^[^\\.; ][^:]+:")
  print substr($0, p, RLENGTH-1)
}

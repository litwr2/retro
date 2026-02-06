#for gawk
BEGIN {n = 0}
/^seg/ {
    a = $1
    sub("seg", "", a)
    sub("\\(.*:", "", a)
    if ($2 > 0) {
       b = strtonum("0x" a)
       sa[b] = $2
       sar[n++] = b
    }
}
END {
    b = 0xfd00
    sa[b] = 0
    sar[n++] = b
    s = si = 0
    for (i = 0; i < n; i++) {
        k = sar[i]
        z = k + sa[k]
        si += sa[k]
        printf "%x %d %x", k, sa[k], z
        if (i + 1 < n && z < sar[i + 1]) {
            printf " +%d\n", sar[i + 1] - z
            s += sar[i + 1] - z
        }
        else
            printf "\n"
    }
    print n - 1, si, "+" s
}

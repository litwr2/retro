#for gawk
/^seg/ {
    a = $1
    sub("seg", "", a)
    sub("\\(.*:", "", a)
    sa[strtonum("0x" a)] = $2
}
END {
    n = 0
    for (i in sa) sao[n++] = i
    for (i = 0; i < n; i++) {
        z = sao[i] + sa[sao[i]]
        printf "%x %d %x", sao[i], sa[sao[i]], z
        if (i + 1 < n && z < sao[i + 1])
            printf " +%d\n", sao[i + 1] - z
        else
            printf "\n"
    }
}

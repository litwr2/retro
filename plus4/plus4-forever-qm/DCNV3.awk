{
if (x == 1) print $0
x=0
}

/[89]2: f/ {
print $0
x=1
}

/[89]2: e/ {
print $0
}

/[89]2: 6f/ {
print $0
x=1
}


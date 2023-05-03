# li s0 0xDEADBEEF
lui x8 912092
addi x8 x8 -273
#

# li s1 0xCAFFEE
lui x9 3248
addi x9 x9 -18
#

addi x18 x0 -4
mul x5 x9 x8
mul x6 x9 x18
mul x7 x5 x6

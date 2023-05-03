addi x5 x5 2021
lui x6 2731
addi x6 x6 -1298

sh x6 2(x5)  # this instruction should be a nop
sh x6 6(x5)  # this instruction should be a nop
sh x6 10(x5)  # this instruction should be a nop

lw t2 -1(t0) # should behave correctly and store 0xAAEEEEEE in s0.

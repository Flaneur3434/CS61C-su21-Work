main:
    lui s0 0xDEADB
    addi s0 s0 0xEF
    addi s1 x0 9
    addi s2 x0 8
    bne s1 s2 jump_over
    sb s0 32(x0)
    lb s1 32(x0)

jump_over:
    #end

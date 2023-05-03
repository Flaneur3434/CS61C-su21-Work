addi s0 x0 9
addi s1 x0 7
bge s0 s1 success

dummy:
    addi t0 t0 4
    jal x0 dummy

success:
    # just end

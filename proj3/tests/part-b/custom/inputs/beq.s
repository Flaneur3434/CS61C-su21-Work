# Branch to label test
addi s0 x0 9
addi s0 x0 9

beq s0 s1 jump_here
jal ra end

jump_here:
    add s0 x0 x0

end:
    # do nothing lol

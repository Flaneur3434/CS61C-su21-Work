addi s0 x0 1
addi s1 x0 2
addi s2 x0 3 
addi s3 x0 4 
addi s4 x0 5
addi s5 x0 0

bge s4 s0 branch_ge
beq s5 x0 branch_eq
blt s1 s2 branch_lt
bne s4 s0 branch_ne
bltu s1, s2, branch_bltu
bgeu s4, s0, branch_bgeu
auipc ra 76

branch_ge:
    jal ra end
branch_eq:
    jal ra end
branch_lt:
    jal ra end
branch_ne:
    jal ra end
branch_bltu:
    jal ra end
branch_bgeu:
    jal ra end
end:
    #end

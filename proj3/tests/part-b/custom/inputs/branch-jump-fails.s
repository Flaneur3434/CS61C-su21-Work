
addi x8 x0 1	
addi x9 x0 2	
addi x18 x0 3	
addi x19 x0 4	
addi x20 x0 5	
addi x21 x0 0	
addi x22 x0 2020

bge x8 x20 branch_ge	
sw x8 0(x22)	
beq x19 x0 branch_eq
sw x8 4(x22)	
blt x18 x9 branch_lt
sw x8 8(x22)	
bne x21 x8 branch_ne
sw x8 12(x22)	
bltu x18 x9 branch_bltu
sw x8 16(x22)	
bgeu x8 x20 branch_bgeu
auipc x1 76

branch_ge:
    jal x1 end
branch_eq:
    jal x1 end
branch_lt:
    jal x1 end
branch_ne:
    jal x1 end
branch_bltu:
    jal x1 end
branch_bgeu:
    jal x1 end
end:
    #end

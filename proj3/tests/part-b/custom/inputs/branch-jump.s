add x8 x0 x0
addi x10 x0 -1

bne x8 x10 jump_here   # Jump taken

addi x8 x8 -1

jalr x1 x0 end

jump_here:
    addi x8 x8 1
    jal x1 end    # Jump to end

end:
    addi x10 x10 1

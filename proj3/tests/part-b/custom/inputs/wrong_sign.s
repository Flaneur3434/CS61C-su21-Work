addi x12, x0, -1
addi x13 x0, 1

bgeu x12 x13 wrong_branch

addi x14 x0 7 # should not execute
jal ra end

wrong_branch:
    jal ra end

end:
    # end

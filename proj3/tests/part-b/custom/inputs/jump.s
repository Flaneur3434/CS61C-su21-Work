#la s1 test
auipc x9 0
addi x9 x9 24
#

jalr x1 x9 0
addi x9 x9 12 # nop

jump_back:
#jr s1
beq x0 x9 test
jal x1 end
#

test:
	addi x9, x0, 8
    jal x1 jump_back

end:
	#end

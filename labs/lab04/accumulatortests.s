.import lotsofaccumulators.s

.data
inputarrayDefault: .word 1,2,3,4,5,6,7,0
inputarrayFive: .word 0, 1, 2, 3, 4, 5, 6

TestPassed: .asciiz "Test Passed!"
TestFailed: .asciiz "Test Failed!"

.text
# Tests if the given implementation of accumulate is correct.
#Input: a0 contains a pointer to the version of accumulate in question. See lotsofaccumulators.s for more details
#
#
#
#The main function currently runs a simple test that checks if accumulator works on the given input array. All versions of accumulate should pass this.
#Modify the test so that you can catch the bugs in four of the five solutions!
main:
#	addi sp, sp, 20
#    sw s0, 0(sp)
#    sw s1, 4(sp)
#    sw s2, 8(sp)
#    sw s3, 12(sp)
#    sw s4, 16(sp)
#    
#    la s0, accumulatorone
#    la s1, accumulatortwo
#    la s2, accumulatorthree
#    la s3, accumulatorfour
#    la s4, accumulatorfive
#    
#    beq a0, s0, testOne
#    beq a0, s1, testTwo
#    beq a0, s2, testThree
#    beq a0, s3, testFour
#    beq a0, s4, testFive
#    # else
#    j exit
    j testTwo
testOne:
	la a0, inputarrayDefault
	li s0, 100
    jal accumulatorone
    li t0, 28
    beq a0, t0, Pass
    j Fail
testTwo:
	addi sp, sp, -16
    li a1, 100
    li a2, 100
    li a3, 100
    li a4, 100
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw a3, 8(sp)
    sw a4, 12(sp)
    ebreak
	la a0, inputarrayDefault
	li s0, 100
    jal accumulatortwo
    li t0, 28
    beq a0, t0, Pass
    j Fail
testThree:
	la a0, inputarrayDefault
    jal accumulatorthree
    li t0, 28
    beq a0, t0, Pass
    j Fail
testFour:
	la a0, inputarrayDefault
	li t2, 100
    jal accumulatorfour
    li t0, 28
    beq a0, t0, Pass
    j Fail
testFive:
	la a0, inputarrayFive
    jal accumulatorfive
    li t0, 0
    beq a0, t0, Pass
Fail:
    la a0 TestFailed
    jal print_string
    j End
Pass:
    la a0 TestPassed
    jal print_string
End:
    jal exit

print_int:
	mv a1 a0
    li a0 1
    ecall
    jr ra
    
print_string:
	mv a1 a0
    li a0 4
    ecall
    jr ra
    
exit:
    li a0 10
    ecall

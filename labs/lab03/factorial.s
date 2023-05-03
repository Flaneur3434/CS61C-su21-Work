.globl factorial

.data
n: .word 8

.text
main:
    la t0, n 				# t0 = &n
    lw a0, 0(t0)			# a0 = *t0
    jal ra, factorial		# Set return reg / Jump to factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    mv t1, a0			# int t1 = a0
    mv t2, a0			# int t2 = a0 (counter)
loop:
    addi t2, t2, -1 	# t2 = t2 - 1
    beq t2, zero, exit 	# if t2 == 0 jump to exit / else continue loop
    mul t1, t1, t2 		# t1 = t1 * t2
	j loop
exit:
	mv a0, zero 		# a0 = 0
    add a0, zero, t1 	# a0 = t1
	ret
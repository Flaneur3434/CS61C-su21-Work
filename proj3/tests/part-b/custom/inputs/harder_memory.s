addi x5 x5 2021
#li t1 0xAAAAEE
lui x6 2731
addi x6 x6 -1298
#

# So basically read_data is always a full word
# You can pass in unaliaged addresses into DMEM, but read_data will always return the word stored at the alaiged byte
# So the store is working but the load address can only be word aligned ...
sb x6 -1(x5) # this instruction works
#lw s1 -1(t0)

sb x6 0(x5)  # this instruction works
#lw a0 0(t0)

sh x6 1(x5)  # This loads the upper half of the word
lw x8 -1(x5)

# Even though these addresses are different, they all read the same word so the result is the same for all 4 instructions
#lw t2 2(t0)

#lw t2 -1(t0) # should behave correctly and store 0xAAEEEEEE in s0.

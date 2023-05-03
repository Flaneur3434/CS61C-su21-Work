.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 32
# =================================================================
argmax:
    # Prologue
    addi sp, sp, -16            # Make space on stack to store head pointer to arr becasue it gets mutated 
    sw s0, 0(sp)                # Store s0 before use
    sw s1, 4(sp)                # Store s1 before use
    sw s2, 8(sp)                # Store s2 before use
    sw s3, 12(sp)               # Store s3 before use

    li t0, 1                    # t0 = 1
    blt a1, t0, error_code      # if length < t0 jump to error_code


loop_start:
# arr           - a0
# length        - a1
# int i         - s0
# int j         - s1
# int max       - s2
# int index     - s3
#
# int index = argmax(arr, length);
#
# int
# argmax (int *arr, int length)
# {
#   int max = -INT_MAX;
#   int index = 0;
#   int i = 0;
#
#   while (i < length)
#   {
#       int j = *arr;
#       if (j > max)
#       {
#           max = j;
#           index = i;
#       }
#       
#       i++;
#       arr += 1;
#   }
#
#   return index;
# }

	li s0, 0				    # i = 0
    li s2, 0x80000000           # max = neg_infinity (-2^31)
    li s3, 0                    # index = 0

    #ebreak                      # Check if s0, s2, s3 set to 0

loop_continue:
	bge s0, a1, loop_end 		# if (i >= length) jump to loop_end
    lw s1, 0(a0)				# s1 = *arr

    #ebreak                      # check value of s1

    bge s2, s1 skip             # if (max >= j) jump to skip
    add s2, zero, s1            # max = j
    add s3, zero, s0            # index = i

    #ebreak                      # check value of s2, s3
    
skip:
    addi s0, s0, 1				# i++
    addi a0, a0, 4				# arr++ (add 4 because ints are 4 bytes)

    j loop_continue             # Jump back to loop_continue

loop_end:
    # Epilogue
    add a0, zero, s3            # return index
    lw s0, 0(sp)   				# Load head address back into a0
    lw s1, 4(sp)   				
    lw s2, 8(sp)   				
    lw s3, 12(sp)

    #ebreak                      # check value of a0

    addi sp, sp 16
    ret

error_code:
    li a1 32
    jal exit2


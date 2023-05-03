.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 32
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -12			# Make space on stack to store head pointer to arr becasue it gets mutated
    sw a0, 0(sp)				# Store head pointer address on stack
    sw s0, 4(sp)				# Store s0 before use
    sw s1, 8(sp)				# Store s1 before use
    
    li t0, 1					# t0 = 1
    blt a1, t0, error_code		# if t1 < 1 jump to error_code


loop_start:
	# int i 	- 	s0
    # length 	- 	a1
    # arr 		- 	a0
    # int j 	- 	s1
    #
    # void
    # relu (int *arr, int length)
    # {
    #   int i = 0
	#   while (i < length)
    #   {
    #	        int j = *arr;
    #
    # 		    if (j < 0)
    # 		    {
    #			    *arr = 0;
    #		    }
    #
    #           i++;
    #           arr += 1;
    #   }
    # }
	li s0, 0 				    # s0 = 0
    #ebreak 					    # Check if s0 holds 0


loop_continue:
	bge s0, a1, loop_end 		# if (i >= length) jump to loop_end
    lw s1, 0(a0)				# s1 = *arr

    bgtz s1, skip   		    # if (j > 0) jump to skip else ...
    sw zero, 0(a0)				# *arr = 0
    
skip:
    addi a0, a0, 4				# arr++ (add 4 because ints are 4 bytes)
    addi s0, s0, 1				# i++

    j loop_continue             # Jump back to loop_continue

loop_end:
    # Epilogue
    lw a0, 0(sp)				# Load head address back into a0
    lw s0, 4(sp)				
    lw s1, 8(sp)				
    #ebreak 						# Check if a0 is back to holding address to head
    addi sp, sp 12
	ret

error_code:
    li a1 32
    jal exit2


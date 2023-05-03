.globl abs

.text
# =================================================================
# FUNCTION: Given an int return its absolute value.
# Arguments:
# 	a0 (int) is input integer
# Returns:
#	a0 (int) the absolute value of the input
# =================================================================
abs:
    # Prologue
	bge a0, zero, done 	# if a0 == 0 jump to done
    sub a0, zero, a0	# a0 = 0 - a0

    # Epilogue
done:
    ret

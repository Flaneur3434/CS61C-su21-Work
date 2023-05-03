.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 32
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 33
# =======================================================

# i               - s0
# elem1           - s1
# elem2           - s2
# product         - s3
# size            - s4
# temp_product    - t1
# temp_stride     - t2
# vector0         - a0 
# vector1         - a1
# length          - a2
# stride1         - a3
# stride2         - a4
#
# int product = dot(vector0, vector1, length, stride1, stride2);
# 
# int
# dot (int *vector0, int *vector1, int length, int stride1, int stride2)
# {
#     int i = 0;
#     int size = 4;
#     int elem1 = 0;
#     int elem2 = 0;
#     int temp_product = 0;
#     int temp_stride = 0;
#     int product = 0;
# 
#     if (length < 1)
#     {
#         exit2(32);
#     }
# 
#     if (stride1 < 1)
#     {
#         exit2(33);
#     }
# 
#     if (stride2 < 1)
#     {
#         exit2(33);
#     }
# 
#     while (i < length)
#     {
#         elem1 = *vector0;
#         elem2 = *vector1;
# 
#         temp_product = elem1 * elem2;
#         product += temp_product;
# 
#         temp_stride = size * stride1;
#         vector0 += temp_stride;
#         temp_stride = size * stride2;
#         vector1 += temp_stride;
#         i++;
#     }
# }

dot:
    # Prologue
    addi sp, sp, -24            # Make space on stack to store head pointer to arr becasue it gets mutated 
    sw s0, 0(sp)                # Store s0 before use
    sw s1, 4(sp)                # Store s1 before use
    sw s2, 8(sp)                # Store s2 before use
    sw s3, 12(sp)               # Store s3 before use
    sw s4, 16(sp)               # Store s4 before use
    sw a1, 20(sp)               # Store a1 before use

    li t0, 1
    blt a2, t0 error_code_32    # if (length < 1) jump to error_code_32
    blt a3, t0 error_code_33    # if (stride1 < 1) jump to error_code_33
    blt a4, t0 error_code_33    # if (stride1 < 1) jump to error_code_33

    #ebreak                      # Check a2, a3, a4 for values over 1
loop_start:
    li s0, 0                    # int i = 0;
    li s4, 4                    # size = 4;
    li s1, 0                    # int elem1 = 0;
    li s2, 0                    # int elem2 = 0;
    li s3, 0                    # int product = 0;
    li t1, 0                    # int temp_product = 0;
    li t2, 0                    # int temp_stride = 0;

    #ebreak                      # check s0-3 and t1 values are set to 0

loop_continue:
    bge s0, a2, loop_end        # if (i >= length) jump to loop_end

    lw s1, 0(a0)                # elem1 = *vector0;
    lw s2, 0(a1)                # elem2 = *vector1;

    #ebreak                      # Check s1, s2 values

    mul t1, s1, s2              # temp_product = elem1 * elem2;
    add s3, s3, t1              # product += temp_product;

    #ebreak                      # Check s3(product)

    mul t2, s4, a3              # temp_stride = size * stride1
    add a0, a0, t2             # vector0 += temp_stride;

    mul t2, s4, a4              # temp_stride = size * stride2
    add a1, a1, t2             # vector1 += 4;
    
    addi s0, s0, 1              # i++;

    j loop_continue

loop_end:
    # Epilogue
    add a0, zero, s3            # return product
    lw s0, 0(sp)                # Restore s0 before use
    lw s1, 4(sp)                # Restore s1 before use
    lw s2, 8(sp)                # Restore s2 before use
    lw s3, 12(sp)               # Restore s3 before use
    lw s4, 16(sp)               # Restore s4 before use
    lw a1, 20(sp)               # Restore a1 before use

    addi sp, sp, 24
    ret

error_code_32:
    li a1 32
    jal exit2

error_code_33:
    li a1 33
    jal exit2

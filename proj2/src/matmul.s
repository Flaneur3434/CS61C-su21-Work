.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 34
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 34
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 34
# =======================================================

# m0            - a0 -> a0
# m1            - a3 -> a1
# m0_rows       - a1
# m0_colums     - a2 -> a2
# m1_rows       - a4 -> a4
# m1_columns    - a5
# new_mat       - a6
# i             - s0
# k             - s1
# size_elem     - s2
# m0_p          - s3
# m1_p          - s4
# 
# matmul(int *m0, int *m1, int m0_rows, int m0_columns, int m1_rows, int m1_columns, int *new_mat)
# {
#     if (m0_rows < temp)
#     {
#         exit2(34);
#     }
#     if (m0_columns < temp)
#     {
#         exit2(34);
#     }
#     if (m1_rows < temp)
#     {
#         exit2(34);
#     }
#     if (m1_columns < temp)
#     {
#         exit2(34);
#     }
#     if (m0_columns != m1_rows)
#     {
#         exit2(34);
#     }
# 
#     while (i < m0_rows)
#     {
#           k = 0;
#           while (k < m1_columns)
#           {
#               dot_product = dot(m0[i][0], m1[0][k] , m0_columns, 1, m1_columns); // pointer, pointer, length, stride, stride
#
#               new_mat[i][k] = dot_product;
#               
#               k++;
#           }
#           i++;
#     }
# }

matmul:
    # Prologue
    addi sp, sp, -32            # Make space on stack to store head pointer to arr becasue it gets mutated 
    sw s0, 0(sp)                # Store s0 before use
    sw s1, 4(sp)                # Store s1 before use
    sw s2, 8(sp)                # Store s1 before use
    sw s3, 12(sp)               # Store s1 before use
    sw s4, 16(sp)               # Store s1 before use

    sw s5, 20(sp)               # Store s1 before use
    sw s6, 24(sp)               # Store s1 before use
    sw ra, 28(sp)               # Store ra before use

    li t0, 1                    # int temp = 1;
    blt a1, t0 error_code_34    # if (m0_rows < 1)              jump to error_code_34
    blt a2, t0 error_code_34    # if (m0_columns < 1)           jump to error_code_34
    blt a4, t0 error_code_34    # if (m1_rows < 1)              jump to error_code_34
    blt a5, t0 error_code_34    # if (m1_columns < 1)           jump to error_code_34
    bne a2, a4 error_code_34    # if (m0_columns != m1_rows)    jump to error_code_34

    li s0, 0                    # int i = 0;
    li s2, 4                    # int size_elem = 4;

    mv s5, a5
    mv s6, a6

    mv s3, a0                   # m0_p = m0;
    mv s4, a3                   # m1_p = m1;                    // Save origin of m1

outer_loop_start:
    bge s0, a1, outer_loop_end  # if (i >= m0_rows)             jump to outer_loop_end
    li s1, 0                    # k = 0;
    

inner_loop_start:
    bge s1, s5, inner_loop_end  # if (k >= m1_columns)          jump to outer_loop_end

    jal call_dot

    sw a0, 0(s6)                # *new_mat_p = dot_result

    add a3, a3, s2              # m1 = m1 + size_elem;
    add s6, s6, s2              # new_mat = new_mat + size_elem;

    addi s1, s1, 1              # k++;
    j inner_loop_start

inner_loop_end:

    mul t0, a2, s2              # int temp = m0_columns * size_elem;
    add s3, s3, t0              # m0 = &m[i][0]
    add a3, zero, s4            # Reset m1 to point back to the first column

    addi s0, s0, 1              # i++;
    j outer_loop_start

outer_loop_end:
    lw s0, 0(sp)                # Retore s0 before use
    lw s1, 4(sp)                # Retore s1 before use
    lw s2, 8(sp)                # Retore s1 before use
    lw s3, 12(sp)               # Retore s1 before use
    lw s4, 16(sp)               # Retore s1 before use
    lw s5, 20(sp)               # Retore s1 before use
    lw s6, 24(sp)               # Retore s1 before use
    lw ra, 28(sp)               # Retore ra before use

    addi sp, sp, 32 
    ret

error_code_34:
    li a1 34
    jal exit2

# matrix [row x column]

call_dot:
    addi sp, sp, -20
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw a3, 8(sp)
    sw a4, 12(sp)
    sw ra, 16(sp)

    add a0, zero, s3            # a0 = m0 (pointer to matrix 1)
    add a1, zero, a3            # a1 = m1 (pinter to matrix 2)
    add a2, zero, a2            # a2 = a1 (length of vector)
    addi a3, zero, 1            # a3 = 1  (stride of vector 1)
    add a4, zero, s5            # a4 = a5 (stride of vector 2)

    jal dot                     # m0 = dot(m0, m1, m0_columns, 1, m1_columns);

    lw a1, 0(sp)
    lw a2, 4(sp)
    lw a3, 8(sp)
    lw a4, 12(sp)
    lw ra, 16(sp)

    addi sp, sp 20
    jr ra

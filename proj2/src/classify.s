.globl classify

# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)    argc
#   a1 (char**) argv
#   a2 (int)    print_classification, if this is zero, 
#               you should print the classification. Otherwise,
#               this function should not print ANYTHING.
# Returns:
#   a0 (int)    Classification
# Exceptions:
# - If there are an incorrect number of command line args,
#   this function terminates the program with exit code 35
# - If malloc fails, this function terminates the program with exit code 48
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>


# int
# classify (int argc, char *argv[], int print)
# {
#     if (argc < 4)
#     {
#         return 35;
#     }
# 
#     int *m0_rows = malloc(sizeof(int));
#     int *m0_cols = malloc(sizeof(int));
# 
#     int *m1_rows = malloc(sizeof(int));
#     int *m1_cols = malloc(sizeof(int));
# 
#     int *input_rows = malloc(sizeof(int));
#     int *input_cols = malloc(sizeof(int));
# 
#     int *matrix0 = read_matrix(argv[1], m0_rows, m0_cols);
#     int *matrix1 = read_matrix(argv[2], m1_rows, m1_cols);
#     int *input_matrix = read_matrix(argv[3], input_rows, input_cols);
# 
#     int input_m0_size = (*m0_rows) * (*input_cols);
#     int *input_m0_matrix = malloc(sizeof(int) * input_m0_size);
# 
#     if (input_m0_matrix == NULL)
#     {
#         return 48;
#     }
# 
#     matmul(matrix0, *m0_rows, *m0_cols, input_matrix, *input_rows, *input_cols, input_m0_matrix);
#     relu(input_m0_matrix, input_m0_size);
# 
#     int input_m1_size = (*m1_rows) * (*input_cols);
#     int *input_m1_matrix = malloc(sizeof(int) * input_m1_size);
# 
#     if (input_m1_matrix == NULL)
#     {
#         return 48;
#     }
# 
#     matmul(matrix1, *m1_rows, *m1_cols, input_m0_matrix, *m0_rows, *input_cols, input_m1_matrix);
# 
#     write_matrix(argv[4], input_m1_matrix, *m1_rows, *input_cols);
# 
#     int max_score = argmax(input_m1_matrix, input_m1_size);
# 
#     if (print == 0)
#     {
#         printf(max_score);
#     }
# 
#     free(matrix0);
#     free(matrix1);
#     free(input_matrix);
#     free(input_m0_matrix);
#     free(input_m1_matrix);
# }
 
# s0      - int *m0_rows
# s1      - int *m0_cols      -> int input_m1_size
# s2      - int *m1_rows
# s3      - int *m1_cols
# s4      - int *input_rows   -> int *input_m1_matrix
# s5      - int *input_cols
# s6      - int *matrix0
# s7      - int *matrix1
# s8      - int *input_matrix
# s9      - int input_m0_size
# s10     - int *input_m0_matrix
# s11     - int print         -> int max_score
# a0      - int argc
# a1      - char ** argv


.text
classify:
    addi sp, sp, -52
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    sw s10, 40(sp)
    sw s11, 44(sp)
    sw ra, 48(sp)

    ebreak                              # check arg
    # check arg
    li t0, 4
    blt a0, t0 arg_error                # if (argc < 4) jump to arg_error

    mv s11, a2                          # s11 = print <a2>

    ebreak                              # malloc m0 rows / cols
    # malloc rows / cols
    jal call_malloc_int                 # int *m0_rows <a0> = malloc(sizeof(int));
    mv s0, a0                           # s0 = m0_rows <a0>
    jal call_malloc_int                 # int *m0_cols <a0> = malloc(sizeof(int));
    mv s1, a0                           # s1 = m0_cols <a0>

    ebreak                              # malloc m1 rows / cols
    # malloc rows / cols
    jal call_malloc_int                 # int *m1_rows <a0> = malloc(sizeof(int));
    mv s2, a0                           # s0 = m1_rows <a0>
    jal call_malloc_int                 # int *m1_cols <a0> = malloc(sizeof(int));
    mv s3, a0                           # s0 = m1_cols <a0>

    ebreak                              # malloc input rows / cols
    # malloc rows / cols
    jal call_malloc_int                 # int *input_rows <a0> = malloc(sizeof(int));
    mv s4, a0                           # s0 = input_rows <a0>
    jal call_malloc_int                 # int *input_cols <a0> = malloc(sizeof(int));
    mv s5, a0                           # s0 = input_cols <a0>

    ebreak                              # Read m0
    # Read m0
    jal call_read_matrix0               # int *matrix0 <a0> = read_matrix(argv[1], m0_rows, m0_cols);

    ebreak                              # Read m1
    # Read m1
    jal call_read_matrix1               # int *matrix1 <a0> = read_matrix(argv[2], m1_rows, m1_cols);

    ebreak                              # Read input
    # Read input
    jal call_read_input                 # int *input_matrix <a0> = read_matrix(argv[3], input_rows, input_cols);

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    ebreak                              # malloc input_m0_matrix
    # malloc input_m0_matrix
    lw t0, 0(s0)                        # t0 = *m0_rows <s0>
    lw t1, 0(s5)                        # t1 = *input_cols <s5>
    mul s9, t0, t1                      # int input_m0_size = (*m0_rows) * (*input_cols);
    jal call_malloc_input_m0            # int *input_m0_matrix <a0> = malloc(sizeof(int) * input_m0_size);
    beqz s10, malloc_error              # if (input_m0_matrix == NULL) jump to malloc_error

    ebreak                               # 1. LINEAR LAYER:    m0 * input
    # 1. LINEAR LAYER:    m0 * input
    jal call_matmul_m0_input            # matmul(matrix0, *m0_rows, *m0_cols, input_matrix, *input_rows, *input_cols, input_m0_matrix);

    ebreak                              # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    jal call_relu                       # relu(input_m0_matrix, input_m0_size);

    # free allocated memory to reuse regs
    mv a0, s1
    jal call_free                       # free(m0_cols)
    mv a0, s4
    jal call_free                       # free(input_cols)

    ebreak                              # malloc input_m1_matrix
    # malloc input_m0_matrix
    lw t0, 0(s2)                        # t0 = *m1_rows <s2>
    lw t1, 0(s5)                        # t1 = *input_cols <s5>
    mul s1, t0, t1                      # int input_m1_size = (*m1_rows) * (*input_cols); 
    jal call_malloc_input_m1            # int *input_m1_matrix = malloc(sizeof(int) * input_m1_size); 
    beqz s4, malloc_error               # if (input_m1_matrix == NULL) jump to malloc_error

    ebreak                              # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    jal call_matmul_m1_input            # matmul(matrix1, *m1_rows, *m1_cols, input_m0_matrix, *m0_rows, *input_cols, input_m1_matrix); 

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

    ebreak                              # Write output matrix
    # Write output matrix
    jal call_write_matrix               # write_matrix(argv[4], input_m1_matrix, *m1_rows, *input_cols); 

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================

    bnez s11, skip_print                 # if (print != 0) jump to skip_print
    ebreak                              # Call argmax
    # Call argmax
    jal call_argmax                     # int max_score <a0> = argmax(input_m1_matrix, input_m1_size);

    ebreak                              # Print classification
    # Print classification
    #bnez x0, skip_print                # if (print != 0) jump to skip_print
    jal call_print_max                  # printf(max_score);
    jal call_print_newline              # printf(\n);


skip_print:

    mv a0, s0
    jal call_free                           # free(m0_rows)
    mv a0, s2
    jal call_free                           # free(m1_rows)
    mv a0, s3
    jal call_free                           # free(m1_cols)
    mv a0, s4
    jal call_free                           # free(input_m1_matrix)
    mv a0, s5
    jal call_free                           # free(input_cols)
    mv a0, s6
    jal call_free                           # free(matrix0);
    mv a0, s7
    jal call_free                           # free(matrix1);
    mv a0, s8
    jal call_free                           # free(input_matrix);
    mv a0, s10
    jal call_free                           # free(input_m0_matrix);

    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw s9, 36(sp)
    lw s10, 40(sp)
    lw s11, 44(sp)
    lw ra, 48(sp)
    addi sp, sp, 52 

    ret

call_read_matrix0:
    addi sp, sp, -12
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw ra, 8(sp)

    lw a0, 4(a1)                        # a0 = argv[1]
    mv a1, s0                           # a1 = m0_rows <s0>
    mv a2, s1                           # a2 = m0_cols <s1>

    jal read_matrix

    mv s6, a0                           # s6 = matrix0 <a0>

    lw a1, 0(sp)
    lw a2, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12

    ret

call_read_matrix1:
    addi sp, sp, -12
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw ra, 8(sp)

    lw a0, 8(a1)                        # a0 = argv[2]
    mv a1, s2                           # a1 = m1_rows <s2>
    mv a2, s3                           # a2 = m1_cols <s3>

    jal read_matrix

    mv s7, a0                           # s7 = matrix1 <a0>

    lw a1, 0(sp)
    lw a2, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12

    ret

call_read_input:
    addi sp, sp, -12
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw ra, 8(sp)

    lw a0, 12(a1)                       # a0 = argv[3]
    mv a1, s4                           # a1 = input_rows <s4>
    mv a2, s5                           # a2 = input_cols <s5>

    jal read_matrix

    mv s8, a0                           # s8 = input_matrix <a0>

    lw a1, 0(sp)
    lw a2, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12

    ret

call_matmul_m0_input:
    addi sp, sp, -28
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw a3, 8(sp)
    sw a4, 12(sp)
    sw a5, 16(sp)
    sw a6, 20(sp)
    sw ra, 24(sp)

    mv a0, s6                           # a0 = matrix0 <s6>
    lw a1, 0(s0)                        # a1 = m0_rows <s0>
    lw a2, 0(s1)                        # a2 = m0_cols <s1>
    mv a3, s8                           # a3 = input_matrix <s8>
    lw a4, 0(s4)                        # a4 = input_rows <s4>
    lw a5, 0(s5)                        # a5 = input_cols <s5>
    mv a6, s10                          # a6 = input_m0_matrix <s10>

    jal matmul

    lw a1, 0(sp)
    lw a2, 4(sp)
    lw a3, 8(sp)
    lw a4, 12(sp)
    lw a5, 16(sp)
    lw a6, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28

    ret

call_matmul_m1_input:
    addi sp, sp, -28
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw a3, 8(sp)
    sw a4, 12(sp)
    sw a5, 16(sp)
    sw a6, 20(sp)
    sw ra, 24(sp)

    mv a0, s7                           # a0 = matrix1 <s7>
    lw a1, 0(s2)                        # a1 = m1_rows <s2>
    lw a2, 0(s3)                        # a2 = m1_cols <s3>
    mv a3, s10                          # a3 = input_m0_matrix <s10>
    lw a4, 0(s0)                        # a4 = m0_rows <s0>
    lw a5, 0(s5)                        # a5 = input_cols <s5>
    mv a6, s4                           # a6 = input_m1_matrix <s4>

    jal matmul

    lw a1, 0(sp)
    lw a2, 4(sp)
    lw a3, 8(sp)
    lw a4, 12(sp)
    lw a5, 16(sp)
    lw a6, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28

    ret
call_relu:
    addi sp, sp, -8
    sw a1, 0(sp)
    sw ra, 4(sp)

    mv a0, s10                          # a0 = input_m0_matrix
    mv a1, s9                           # a1 = input_m0_size

    jal relu

    lw a1, 0(sp)
    lw ra, 4(sp)
    addi, sp, sp, 8

    ret

call_write_matrix:
    addi sp, sp, -16
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw a3, 8(sp)
    sw ra, 12(sp)

    lw a0, 16(a1)                       # a0 = argv[4]
    mv a1, s4                           # a1 = input_m1_matrix
    lw a2, 0(s2)                        # a2 = *m1_rows
    lw a3, 0(s5)                        # a3 = *input_cols

    jal write_matrix

    lw a1, 0(sp)
    lw a2, 4(sp)
    lw a3, 8(sp)
    lw ra, 12(sp)
    addi, sp, sp, 16

    ret


call_argmax:
    addi sp, sp, -8
    sw a1, 0(sp)
    sw ra, 4(sp)

    mv a0, s4                           # a0 = input_m1_matrix
    mv a1, s1                           # a1 = input_m1_size

    jal argmax

    mv s11, a0                          # s11 = max_score <a0>

    lw a1, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    ret

call_malloc_input_m0:
    addi sp, sp, -8
    sw a1, 0(sp)
    sw ra, 4(sp)

    mv a1, s9               # a1 = input_m0_size
    li a0, 4                # sizeof(int);
    mul a0, a0, a1          # get bytes
    jal malloc              # int *row_column = malloc(sizeof(int) * input_m0_size);

    mv s10, a0              # s10 = input_m0_matrix <a0>

    lw a1, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    ret

call_malloc_input_m1:
    addi sp, sp, -8
    sw a1, 0(sp)
    sw ra, 4(sp)

    mv a1, s1               # a1 = input_m1_size <s1>
    li a0, 4                # sizeof(int);
    mul a0, a0, a1          # get bytes
    jal malloc              # int *row_column = malloc(sizeof(int) * input_m0_size);

    mv s4, a0               # s4 = input_m1_matrix <a0>

    lw a1, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    ret

call_malloc_int:
    addi sp, sp, -8
    sw a1, 0(sp)
    sw ra, 4(sp)

    li a0, 4                # sizeof(int);
    jal malloc              # int *row_column = malloc();

    lw a1, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    ret
call_free:
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw ra, 8(sp)

    jal free

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12

    ret

call_print_max:
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw ra, 8(sp)

    mv a1, s11               # a1 = max_score <s11>
    jal print_int

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12

    ret

call_print_newline:
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw ra, 8(sp)

    li a1, 10
    jal print_char

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12

    ret

call_print_str:
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw s11, 8(sp)
    sw ra, 12(sp)


    mv a1, s11              # a1 = string <s11>
    jal print_str

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw s11, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    ret


arg_error:
    li a1, 35
    jal exit2

malloc_error:
    li a1, 48
    jal exit2   

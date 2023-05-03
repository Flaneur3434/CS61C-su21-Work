.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 64
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 67
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 65
# ==============================================================================

# s0      - FILE *output_file
# s1      - int *matrix
# s2      - int fwrite_result
# s3      - int fclose_result
# s4      - int write_elems
# s5      - int *row_col
# s6      - int *buffer (for fwrite abstraction)
# s7      - int rows
# s8      - int cols
# 
# void
# write_matrix(char *file_name, int *matrix_buffer, int rows, int cols)
# {
#     int *matrix = matrix_buffer;
#     FILE *output_file = fopen(file_name, "w");
# 
#     if (output_file < 0)
#     {
#         return 64;
#     }
# 
#     int *row_col = malloc(sizeof(int) * 2);
# 
#     row_col[0] = rows;
#     row_col[1] = cols;
# 
#     int write_elems = 2;
#     int fwrite_result =  fwrite(output_file, row_col, write_elems, 4);
# 
#     if (fwrite_result != write_elems)
#     {
#         return 67;
#     }
# 
#     write_elems = rows * cols;
#     fwrite_result = fwrite(output_file, matrix, write_elems, 4);
# 
#     if (fwrite_result != write_elems)
#     {
#         return 67;
#     }
# 
#     int fclose_result = fclose(output_file);
# 
#     if (fclose_result < 0)
#     {
#         return 65;
#     }
# 
#     free(row_col);
# }


write_matrix:

    ebreak                      # Prologue
    # Prologue
    addi sp, sp, -40
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw ra, 36(sp)

    mv s1, a1                   # int *matrix = matrix_buffer;
    mv s7, a2                   # s7 = rows <a2>
    mv s8, a3                   # s8 = cols <a3>

    ebreak                      # fopen
    # fopen
    jal call_fopen              # FILE *output_file <a0> = fopen(file_name, "w");
    mv s0, a0                   # s0 = output_file <a0>;
    bltz s0, fopen_error        # if (output_file < 0) jump to fopen_error

    ebreak                      # malloc row_col
    # malloc row_col
    jal call_malloc             # int *row_col <a0> = malloc(sizeof(int) * 2);
    mv s5, a0                   # s5 = row_col <a0>
    beqz s5, malloc_error       # if (row_col == 0) jump to malloc_error
    sw s7, 0(s5)                # row_col[0] = rows;
    sw s8, 4(s5)                # row_col[1] = cols;

    ebreak                      # fwrite row_col
    # fwrite row_col
    li s4, 2                    # int write_elems = 2;
    mv s6, s5                   # int *buffer = row_col;
    jal call_fwrite             # int fwrite_result <a0> =  fwrite(output_file, row_col, write_elems, 4);
    mv s2, a0                   # s2 = fwrite_result <a0>;
    bne s2, s4, fwrite_error    # if (fwrite_result != write_elems) jump to fwrite_error


    ebreak                      # fwrite matrix
    # fwrite matrix
    mul s4, s7, s8              # write_elems = rows * cols;
    mv s6, s1                   # buffer = matrix
    jal call_fwrite             # fwrite_result <a0> = fwrite(output_file, matrix, write_elems, 8);
    mv s2, a0                   # s2 = fwrite_result <a0>;
    bne s2, s4, fwrite_error    # if (fwrite_result != write_elems) jump to fwrite_error

    ebreak                      #fclose
    #fclose
    jal call_fclose             # int fclose_result <a0> = fclose(output_file);
    mv s3, a0                   # s3 = fclose_result <a0>
    bltz s3, fclose_error       # if (fclose_result < 0) jump to fclose_error

    ebreak                      # free
    # free
    jal call_free               # free(row_col);

    ebreak                      # Epilogue
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw s8, 32(sp)
    lw ra, 36(sp)
    addi sp, sp, 40


    ret

call_fopen:
    addi sp, sp, -12
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw ra, 8(sp)

    mv a1, a0               # file descriptor a1 = file_name
    li a2,  1               # permission      a2 = 1
   
    jal fopen               # FILE *matrix_file = fopen(file_name, 1);

    lw a1, 0(sp)
    lw a2, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12

    ret

call_fwrite:
    addi sp, sp, -20
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw a3, 8(sp)
    sw a4, 12(sp)
    sw ra, 16(sp)

    mv a1, s0           # FILE *matrix_file
    mv a2, s6           # int *contents_buffer
    mv a3, s4           # int write_elems
    li a4,  4           # size_t size_of_elems

    jal fwrite

    lw a1, 0(sp)
    lw a2, 4(sp)
    lw a3, 8(sp)
    lw a4, 12(sp)
    lw ra, 16(sp)
    addi sp, sp, 20

    ret

call_fclose:
    addi sp, sp, -8
    sw a1, 0(sp)
    sw ra, 4(sp)

    mv a1, s0           # FILE *matrix_file

    jal fclose

    lw a1, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    ret

call_malloc:
    addi sp, sp, -8
    sw a1, 0(sp)
    sw ra, 4(sp)

    li a0, 8                # sizeof(int) * 2;
    jal malloc              # int *row_column = malloc(sizeof(int) * 2);

    lw a1, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    ret

call_free:
    addi sp, sp, -12
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw ra, 8(sp)

    mv a0, s5           # pointer to allocated memory <s5>
    
    jal free

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12

    ret

fopen_error:
    li a1, 64
    jal exit2

fwrite_error:
    li a1, 67
    jal exit2

fclose_error:
    li a1, 65
    jal exit2

malloc_error:
    li a1, 48
    jal exit2

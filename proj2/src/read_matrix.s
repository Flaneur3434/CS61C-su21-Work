.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 48
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 64
# - If you receive an fread error or eof,
#   this function terminates the program with error code 66
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 65
# ==============================================================================
#s0      - FILE *matrix_file
#s1      - int row
#s2      - int read_bytes
#s3      - int *matrix
#s4      - int *buffer      // more general fread
#s5      - int col
#t0      - int written_bytes
#t1      - int result_fclose
#
#
#int *
#read_matrix(char *file_name, int *num_rows, int *num_cols)
#{
#    FILE *matrix_file = fopen(file_name, "r");
#
#    if(matrix_file < 0)
#    {
#        return 64;
#    }
#
#    int read_bytes = 4;
#
#    int written_bytes = fread(matrix_file, num_rows, read_bytes);
#
#    if(written_bytes != read_bytes)
#    {
#        return 66;
#    }
#
#    written_bytes = fread(matrix_file, num_cols, read_bytes);
#
#    if(written_bytes != read_bytes)
#    {
#        return 66;
#    }
#
#    int rows = *num_rows;
#    int cols = *num_cols;
#
#    int read_bytes = (*num_rows) * (*num_cols) * sizeof(int);
#
#    int *matrix = malloc(read_bytes);
#
#    if (matrix = 0)
#    {
#        return 48;
#    }
#
#    written_bytes = fread(matrix_file, matrix, read_bytes);
#    
#    if(written_bytes != read_bytes)
#    {
#        return 66;
#    }
#    
#    int result_fclose = fclose(matrix_file);
#    
#    if (result_fclose < 0)
#    {
#        return 65;
#    }
#    
#    return matrix;
#}
         
read_matrix:

    #ebreak                  # Prologue
    # Prologue
    addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw ra, 24(sp)

    #jal call_print

    #ebreak                  # fopen
    # fopen
	jal call_fopen          # FILE *matrix_file <a0> = matrix_file = fopen(file_name, "r");
    mv s0, a0               # s0 = matrix_file <a0>;
    bltz s0, fopen_error    # if (matrix_file < 0) jump to fopen_error

    li s2, 4                # int read_bytes = 4;

    #ebreak                  # fread row
    # fread row / column 
    mv s4, a1               # s4 = row;
    jal call_fread          # int written_bytes <a0> = fread(matrix_file, s4, read_bytes);
    mv t0, a0               # t0 = written_bytes <a0>
    bne t0, s2, fread_error # if (written_bytes != read_bytes) jump to fread_error

    #ebreak                  # fread column
    # fread row / column 
    mv s4, a2               # s4 = row;
    jal call_fread          # int written_bytes <a0> = fread(matrix_file, s4, read_bytes);
    mv t0, a0               # t0 = written_bytes <a0>
    bne t0, s2, fread_error # if (written_bytes != read_bytes) jump to fread_error

    #ebreak                  # malloc matrix
    # malloc matrix
    lw t0, 0(a1)            # rows = *num_rows;
    lw t1, 0(a2)            # cols = *num_cols;
    mul s2, t0, t1          # int read_bytes = (*num_rows) * (*num_cols);
    slli s2, s2, 2          # read_bytes *= 4;
    jal call_malloc         # int *matrix <a0> = malloc(read_bytes);
    mv s3, a0               # s3 = matrix <a0>
    beqz s3, malloc_error   # if (matrix = 0) jump to malloc_error

    #ebreak                  # fread matrix
    # fread matrix
    mv s4, s3               # s4 = matrix;
    jal call_fread          # written_bytes <a0> = fread(matrix_file, s4,read_bytes);
    add t0, zero, a0        # t0 = written_bytes <a0>
    bne t0, s2, fread_error # if(written_bytes != read_bytes) jump to fread_error

    #ebreak                  # fclose
    # fclose
    jal call_fclose         # int result_fclose <a0> = fclose(matrix_file);
    add t1, zero, a0        # t1 = result_fclose <a0>
    bltz t1, fclose_error   # if (result_fclose < 0)

    mv a0, s3               # a0 = matrix <s3>

    #ebreak                  # Epilogue
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28

    ret

call_fopen:
    addi sp, sp, -12
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw ra, 8(sp)

    mv a1, a0               # file descriptor a1 = file_name
    li a2,  0               # permission      a2 = 0
    
    jal fopen               # FILE *matrix_file = fopen(file_name, 0);

    lw a1, 0(sp)
    lw a2, 4(sp)
    lw ra, 8(sp)
    addi sp, sp, 12

    ret

call_fread:
    addi sp, sp, -16
    sw a1, 0(sp)
    sw a2, 4(sp)
    sw a3, 8(sp)
    sw ra, 12(sp)

    mv a1, s0               # FILE *matrix_file
    mv a2, s4               # int *buffer
    mv a3, s2               # int read_bytes

    jal fread

    lw a1, 0(sp)
    lw a2, 4(sp)
    lw a3, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16

    ret

call_fclose:
    addi sp, sp, -8
    sw a1, 0(sp)
    sw ra, 4(sp)

    add a1, zero, s0        # FILE *matrix_file

    jal fclose

    lw a1, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    ret

call_malloc:
    addi sp, sp, -8
    sw a1, 0(sp)
    sw ra, 4(sp)

    mv a0, s2                # a0 = read_bytes;
    jal malloc               # int *row_column = malloc(read_bytes);

    lw a1, 0(sp)
    lw ra, 4(sp)
    addi sp, sp, 8

    ret

fopen_error:
    li a1, 64
    jal exit2

fread_error:
    li a1, 66
    jal exit2

fclose_error:
    li a1, 65
    jal exit2

malloc_error:
    li a1, 48
    jal exit2


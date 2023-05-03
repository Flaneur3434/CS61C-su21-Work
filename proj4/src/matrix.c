#include "matrix.h"
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

// Include SSE intrinsics
#if defined(_MSC_VER)
#include <intrin.h>
#elif defined(__GNUC__) && (defined(__x86_64__) || defined(__i386__))
#include <immintrin.h>
#include <x86intrin.h>
#endif

static inline void transpose_matrix(int, matrix *, matrix *);
static inline double vector_mul(int, int, matrix *, matrix *);
static inline void cal_pow(int, matrix *, matrix *);

/* Below are some intel intrinsics that might be useful
 * void _mm256_storeu_pd (double * mem_addr, __m256d a)
 * __m256d _mm256_set1_pd (double a)
 * __m256d _mm256_set_pd (double e3, double e2, double e1, double e0)
 * __m256d _mm256_loadu_pd (double const * mem_addr)
 * __m256d _mm256_add_pd (__m256d a, __m256d b)
 * __m256d _mm256_sub_pd (__m256d a, __m256d b)
 * __m256d _mm256_fmadd_pd (__m256d a, __m256d b, __m256d c)
 * __m256d _mm256_mul_pd (__m256d a, __m256d b)
 * __m256d _mm256_cmp_pd (__m256d a, __m256d b, const int imm8)
 * __m256d _mm256_and_pd (__m256d a, __m256d b)
 * __m256d _mm256_max_pd (__m256d a, __m256d b)
*/

/* Generates a random double between low and high */
double rand_double(double low, double high) {
    double range = (high - low);
    double div = RAND_MAX / range;
    return low + (rand() / div);
}

/* Generates a random matrix */
void rand_matrix(matrix *result, unsigned int seed, double low, double high) {
    srand(seed);
    for (int i = 0; i < result->rows; i++) {
        for (int j = 0; j < result->cols; j++) {
            set(result, i, j, rand_double(low, high));
        }
    }
}

/*
 * Allocates space for a matrix struct pointed to by the double pointer mat with
 * `rows` rows and `cols` columns. You should also allocate memory for the data array
 * and initialize all entries to be zeros. `parent` should be set to NULL to indicate that
 * this matrix is not a slice. You should also set `ref_cnt` to 1.
 * You should return -1 if either `rows` or `cols` or both have invalid values. Return -2 if any
 * call to allocate memory in this function fails. Remember to set the error messages in numc.c.
 * Return 0 upon success.
 */
int 
allocate_matrix(matrix **mat, int rows, int cols)
{
    //puts("allocate_matrix");
    /* if either `rows` or `cols` or both have invalid values */
    if (rows <= 0 || cols <= 0)
        return -1;
        
    *mat = malloc(sizeof(matrix));
    (*mat)->rows = rows;
    (*mat)->cols = cols;
    //(*mat)->data = calloc(rows * cols, sizeof(double));
    (*mat)->data = aligned_alloc(32, rows * cols * sizeof(double));

    if ((*mat)->data == NULL)
        return -2;

    memset((*mat)->data, 0, rows * cols * sizeof(double));
    (*mat)->ref_cnt = 1;
    (*mat)->parent = NULL;

    return 0; /* success */
}

/*
 * Allocates space for a matrix struct pointed to by `mat` with `rows` rows and `cols` columns.
 * Its data should point to the `offset`th entry of `from`'s data (you do not need to allocate memory)
 * for the data field. `parent` should be set to `from` to indicate this matrix is a slice of `from`.
 * You should return -1 if either `rows` or `cols` or both have invalid values. Return -2 if any
 * call to allocate memory in this function fails.
 * Remember to set the error messages in numc.c.
 * Return 0 upon success.
 */
int
allocate_matrix_ref(matrix **mat, matrix *from, int offset, int rows, int cols)
{
    //puts("allocate_matrix_ref");
    /* if either `rows` or `cols` or both have invalid values */
    if (rows <= 0 || cols <= 0)
        return -1;

    if (from == NULL)
        return -2;

    *mat = malloc(sizeof(matrix));
    (*mat)->rows = rows;
    (*mat)->cols = cols;
    (*mat)->data = from->data + offset;
    (*mat)->ref_cnt = 1;
    from->ref_cnt++;
    (*mat)->parent = from;

    return 0; /* success */
}

/*
 * You need to make sure that you only free `mat->data` if `mat` is not a slice and has no existing slices,
 * or that you free `mat->parent->data` if `mat` is the last existing slice of its parent matrix and its parent matrix has no other references
 * (including itself). You cannot assume that mat is not NULL.
 */
void
deallocate_matrix(matrix *mat) 
{
    //puts("deallocate_matrix");
    if (mat == NULL)
        return;

    if (mat->parent == NULL && mat->ref_cnt == 1)
    {
        free(mat->data);
        free(mat);
    }
    else if(mat->parent != NULL && mat->ref_cnt == 1)
    {
        mat->parent->ref_cnt--;
        free(mat);
    }
}

/*
 * Returns the double value of the matrix at the given row and column.
 * You may assume `row` and `col` are valid.
 */
double
get(matrix *mat, int row, int col)
{
    int index = (row * mat->cols) + col;
    return *(mat->data + index);
}

/*
 * Sets the value at the given row and column to val. You may assume `row` and
 * `col` are valid
 */
void
set(matrix *mat, int row, int col, double val) 
{
    int index = (row * mat->cols) + col;
    *(mat->data + index) = val;
}

/*
 * Sets all entries in mat to val
 */
void
fill_matrix(matrix *mat, double val)
{
    //puts("fill_matrix");
    #pragma omp parallel for schedule(static, 8)
    for (int i = 0; i < mat->cols * mat->rows; i++)
    {
        *(mat->data + i) = val;
    }
}

/*
 * Store the result of adding mat1 and mat2 to `result`.
 * Return 0 upon success and a nonzero value upon failure.
 */
int 
add_matrix(matrix *result, matrix *mat1, matrix *mat2) 
{
    if (mat1->rows != mat2->rows || mat1->cols != mat2->cols)
        return -1;

    int NUM_ELMS = (mat1->cols * mat1->rows)/4 * 4;
    __m256d sum_vec = _mm256_setzero_pd();

    #pragma omp parallel for schedule(static, 8)
    for (int i = 0; i < NUM_ELMS; i += 4)
    {
        __m256d mat1_buffer = _mm256_load_pd(mat1->data + i);
        __m256d mat2_buffer = _mm256_load_pd(mat2->data + i);
        sum_vec = _mm256_add_pd(mat1_buffer, mat2_buffer);
        _mm256_store_pd(result->data + i, sum_vec);
    }

    for (int i = NUM_ELMS; i < mat1->cols * mat1->rows; i++)
    {
        *(result->data + i) = *(mat1->data + i) + *(mat2->data + i);
    }

    return 0; /* success */
}

/*
 * (OPTIONAL)
 * Store the result of subtracting mat2 from mat1 to `result`.
 * Return 0 upon success and a nonzero value upon failure.
 */
int
sub_matrix(matrix *result, matrix *mat1, matrix *mat2) 
{
    if (mat1->rows != mat2->rows || mat1->cols != mat2->cols)
        return -1;

    int NUM_ELMS = (mat1->cols * mat1->rows)/4 * 4;
    __m256d sum_vec = _mm256_setzero_pd();

    #pragma omp parallel for schedule(static, 8)
    for (int i = 0; i < NUM_ELMS; i += 4)
    {
        __m256d mat1_buffer = _mm256_load_pd(mat1->data + i);
        __m256d mat2_buffer = _mm256_load_pd(mat2->data + i);
        sum_vec = _mm256_sub_pd(mat1_buffer, mat2_buffer);
        _mm256_store_pd(result->data + i, sum_vec);
    }

    for (int i = NUM_ELMS; i < mat1->cols * mat1->rows; i++)
    {
        *(result->data + i) = *(mat1->data + i) - *(mat2->data + i);
    }

    return 0; /* success */
}

/*
 * Store the result of multiplying mat1 and mat2 to `result`.
 * Return 0 upon success and a nonzero value upon failure.
 * Remember that matrix multiplication is not the same as multiplying individual elements.
 */
int
mul_matrix(matrix *result, matrix *mat1, matrix *mat2) 
{
    //puts("mul_matrix");
    if (mat1->cols != mat2->rows)
        return -1;

    matrix *tmp_mat = NULL;
    allocate_matrix(&tmp_mat, mat2->cols, mat2->rows);
    transpose_matrix(1, tmp_mat, mat2);

    /* vector_mul(int mat1_row, int mat2_col, matrix *mat1, matrix *mat2) */
    #pragma omp parallel for
    for (int mat1_row = 0; mat1_row < mat1->rows; mat1_row++)
    {
        for (int mat2_col = 0; mat2_col < tmp_mat->rows; mat2_col++)
        {
            *(result->data + mat2_col + mat1_row * result->cols) = vector_mul(mat1_row, mat2_col, mat1, tmp_mat);
        }
    }

    return 0; /* success */
}

/*
 * Store the result of raising mat to the (pow)th power to `result`.
 * Return 0 upon success and a nonzero value upon failure.
 * Remember that pow is defined with matrix multiplication, not element-wise multiplication.
 */

int 
pow_matrix(matrix *result, matrix *mat, int pow) 
{
    int pow_max = 0;
    int mul_num = 0;
    matrix *tmp_mat = NULL;
    power_two pt_arr[100]; //buffer lol

    if (mat->rows != mat->cols)
    {
        return -1;
    }

    if (pow < 0)
    {
        return -2;
    }

    if (pow == 0)
    {
        /* 0th power is the identity matrix (1 on the top left to bottom right diagonal and 0 everywhere else). */
        #pragma omp parallel for schedule(static, 8)
        for(int i = 0; i < mat->cols * mat->rows; i += mat->cols + 1)
        {
            *(result->data + i) = 1;
        }

        return 0;
    }

    /* find the biggest power of 2 to speed up pow calculation */
    while (pow > 1)
    {
        if ((pow & (pow - 1)) != 0) /* if pow is not a power of 2 */
        {
            for (int h = pow; h > 0; h--) /* find the biggest power of 2 */
            {
                if ((h & (h - 1)) == 0)
                {
                    pow_max = h;
                    pt_arr[mul_num].num = pow_max;
                    allocate_matrix(&pt_arr[mul_num++].result, mat->rows, mat->cols);
                    break;
                }
            }

            pow -= pow_max;
        }
        else
        {
            pow_max = pow;
            pt_arr[mul_num].num = pow_max;
            allocate_matrix(&pt_arr[mul_num++].result, mat->rows, mat->cols);
            break;
        }
    }

    if (pow == 1)
    {
        pt_arr[mul_num].num = 1;
        allocate_matrix(&pt_arr[mul_num++].result, mat->rows, mat->cols);
    }

    #pragma omp parallel for
    for (int i = 0; i < mul_num; i++)
    {
        cal_pow(pt_arr[i].num, pt_arr[i].result, mat);
    }

    if (mul_num == 1)
    {
        memcpy(result->data, pt_arr[0].result->data, sizeof(double) * pt_arr[0].result->cols * pt_arr[0].result->rows);
        return 0;
    }
    else
    {
        mul_matrix(result, pt_arr[0].result, pt_arr[1].result);
    }

    allocate_matrix(&tmp_mat, mat->rows, mat->cols); 
    memcpy(tmp_mat->data, result->data, sizeof(double) * result->cols * result->rows);

    for (int i = 2; i < mul_num; i++)
    {
        mul_matrix(result, tmp_mat, pt_arr[i].result);
        memcpy(tmp_mat->data, result->data, sizeof(double) * result->cols * result->rows);
    }

    memcpy(result->data, tmp_mat->data, sizeof(double) * result->cols * result->rows);
    deallocate_matrix(tmp_mat);


    /* free stuff */
    #pragma omp parallel for
    for(int i = 0; i < mul_num; i++)
    {
        deallocate_matrix(pt_arr[i].result);
    }
    
    return 0;
}

static inline void
cal_pow(int pow, matrix *result, matrix *mat)
{
    matrix *tmp_mat = NULL;

    if (pow == 1)
    {
        memcpy(result->data, mat->data, sizeof(double) * mat->cols * mat->rows);
        return;
    }

    allocate_matrix(&tmp_mat, mat->rows, mat->cols); 
    memcpy(tmp_mat->data, mat->data, sizeof(double) * mat->cols * mat->rows);

    /* calculate */
    for (int i = pow; i > 1; i /= 2)
    {
        mul_matrix(result, tmp_mat, tmp_mat);
        memcpy(tmp_mat->data, result->data, sizeof(double) * result->cols * result->rows);
    }

    memcpy(result->data, tmp_mat->data, sizeof(double) * result->cols * result->rows);
    deallocate_matrix(tmp_mat);

    return; /* success */
}



/*
 * (OPTIONAL)
 * Store the result of element-wise negating mat's entries to `result`.
 * Return 0 upon success and a nonzero value upon failure.
 */
int neg_matrix(matrix *result, matrix *mat) {
    /* TODO: YOUR CODE HERE */
    return 0;
}

/*
 * Store the result of taking the absolute value element-wise to `result`.
 * Return 0 upon success and a nonzero value upon failure.
 */
int 
abs_matrix(matrix *result, matrix *mat) 
{
    //puts("abs_matrix");
    for (int i = 0; i < mat->cols * mat->rows; i++)
    {
        if (mat->data[i] < 0)
        {
            *(result->data + i) = -(*(mat->data + i));
        }
        else
        {
            *(result->data + i) = *(mat->data + i);
        }
    }

    return 0; /* success */
}

//static inline void
void
transpose_matrix(int blocksize, matrix *dst, matrix *src)
{
    #pragma omp parallel for schedule(static, 8)
    for (int row = 0; row < src->rows; row++) 
    {
        for (int col = 0; col < src->cols; col++) 
        {
            *(dst->data + row + col * dst->cols) = *(src->data + col + row * src->cols);
        }
    }
}

static inline double
vector_mul(int mat1_row, int mat2_col, matrix *mat1, matrix *mat2)
{
    /* remeber that mat2 is transposed */
    #define vec1 mat1->data + mat1_row * mat1->cols
    #define vec2 mat2->data + mat2_col * mat2->cols
    #define max_len (mat1->cols) / 4 * 4

    double result_num = 0, tmp_arr[4] = {0, 0, 0, 0};
    int i, j, h;

    __m256d result_arr = {0, 0, 0, 0};

    for (i = 0; i < max_len; i += 4)
    {
        result_arr = _mm256_add_pd(
                        result_arr,
                        _mm256_mul_pd(
                            _mm256_loadu_pd(vec1 + i),
                            _mm256_loadu_pd(vec2 + i)));
    }

    _mm256_storeu_pd(tmp_arr, result_arr);

    /* tail case */
    for (j = max_len; j < mat1->cols; j++)
    {
        result_num += *(vec1 + j) * *(vec2 + j);
    }


    for (h = 0; h < 4; h++)
    {
        result_num += *(tmp_arr + h);
    }

    return result_num;
}

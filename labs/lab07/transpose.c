#include "transpose.h"

/* The naive transpose function as a reference. */
void transpose_naive(int n, int blocksize, int *dst, int *src) {
    for (int x = 0; x < n; x++) {
        for (int y = 0; y < n; y++) {
            dst[y + x * n] = src[x + y * n];
        }
    }
}

/* Implement cache blocking below. You should NOT assume that n is a
 * multiple of the block size. */
void 
transpose_blocking(int n, int blocksize, int *dst, int *src) 
{
    int step_blocksize_x, step_blocksize_y, x, y, next_x_block = 0, next_y_block = 0;

    for(step_blocksize_y = blocksize, next_y_block = 0; step_blocksize_y <= n; step_blocksize_y += blocksize, next_y_block++)
    {
        /* for uneven matrix whose block sizes are not the multiples of its width */
        if (n - step_blocksize_y > 0 && n - step_blocksize_y < blocksize)
        {
            step_blocksize_y += n - step_blocksize_y;
        }

        for(step_blocksize_x = blocksize, next_x_block = 0; step_blocksize_x <= n; step_blocksize_x += blocksize, next_x_block++)
        {
            /* for uneven matrix whose block sizes are not the multiples of its width */
            if (n - step_blocksize_x > 0 && n - step_blocksize_x < blocksize)
            {
                step_blocksize_x += n - step_blocksize_x;
            }

            for(y = blocksize * next_y_block; y < step_blocksize_y; y++)
            {
                for(x = blocksize * next_x_block; x < step_blocksize_x; x++)
                {
                    /* (x, y) -> (y, x) */
                   dst[y + x * n] = src[x + y * n];
                }
            }
        }
    }
}

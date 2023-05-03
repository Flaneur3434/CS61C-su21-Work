#include <time.h>
#include <stdio.h>
#include <x86intrin.h>
#include "simd.h"

long long int sum(int vals[NUM_ELEMS]) {
    clock_t start = clock();

    long long int sum = 0;
    for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
        for(unsigned int i = 0; i < NUM_ELEMS; i++) {
            if(vals[i] >= 128) {
                sum += vals[i];
            }
        }
    }
    clock_t end = clock();
    printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
    return sum;
}

long long int sum_unrolled(int vals[NUM_ELEMS]) {
    clock_t start = clock();
    long long int sum = 0;

    for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
        for(unsigned int i = 0; i < NUM_ELEMS / 4 * 4; i += 4) {
            if(vals[i] >= 128) sum += vals[i];
            if(vals[i + 1] >= 128) sum += vals[i + 1];
            if(vals[i + 2] >= 128) sum += vals[i + 2];
            if(vals[i + 3] >= 128) sum += vals[i + 3];
        }

        // TAIL CASE, for when NUM_ELEMS isn't a multiple of 4
        // NUM_ELEMS / 4 * 4 is the largest multiple of 4 less than NUM_ELEMS
        // Order is important, since (NUM_ELEMS / 4) effectively rounds down first
        for(unsigned int i = NUM_ELEMS / 4 * 4; i < NUM_ELEMS; i++) {
            if (vals[i] >= 128) {
                sum += vals[i];
            }
        }
    }
    clock_t end = clock();
    printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
    return sum;
}

long long int sum_simd(int vals[NUM_ELEMS]) {
    clock_t start = clock();
    __m128i _127 = _mm_set1_epi32(127); // This is a vector with 127s in it... Why might you need this?
    long long int result = 0;                   // This is where you should put your final result!
    /* DO NOT MODIFY ANYTHING ABOVE THIS LINE (in this function) */

    for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) 
    {
        __m128i sum_vec = _mm_setzero_si128(); /* Initialize sum vector of {0, 0} */

        for(unsigned int i = 0; i < NUM_ELEMS / 4 * 4; i += 4)
        {
            __m128i tmp0 = _mm_load_si128((__m128i *) (vals + i));
            __m128i cmp_vec0 = _mm_cmpgt_epi32(tmp0, _127); /* Create a mask */
            tmp0 = _mm_and_si128(cmp_vec0, tmp0); /* Using the mask to zero out unwanted values */
            sum_vec = _mm_add_epi32(sum_vec, tmp0);
        }

        /* tail case */
        unsigned int num_left = NUM_ELEMS - (NUM_ELEMS / 4 * 4);
        int mask[4]= {0, 0, 0, 0};

        if (num_left != 0)
        {
            unsigned int j = 0; /* Counter for mask, which is seperate from the coutner of vals */
            for(unsigned int i = NUM_ELEMS / 4 * 4; i < NUM_ELEMS; i++)
            {
                mask[j++] += vals[i];
            }

            __m128i tmp1 = _mm_load_si128((__m128i *) mask);
            __m128i cmp_vec1 = _mm_cmpgt_epi32(tmp1, _127);
            tmp1 = _mm_and_si128(cmp_vec1, tmp1);
            sum_vec = _mm_add_epi32(sum_vec, tmp1);
        }

        int ret_vec[4];
        _mm_storeu_si128((__m128i *) ret_vec, sum_vec);

        for (unsigned int i = 0; i < 4; i++)
        {
            result += ret_vec[i];
        }
    }

    /* DO NOT MODIFY ANYTHING BELOW THIS LINE (in this function) */
    clock_t end = clock();
    printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
    return result;
}

long long int sum_simd_unrolled(int vals[NUM_ELEMS]) {
    clock_t start = clock();
    __m128i _127 = _mm_set1_epi32(127);
    long long int result = 0;
    /* DO NOT MODIFY ANYTHING ABOVE THIS LINE (in this function) */

    for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
        __m128i sum_vec = _mm_setzero_si128(); /* Initialize sum vector of {0, 0} */

        for(unsigned int i = 0; i < NUM_ELEMS / 16 * 16; i += 16)
        {
            __m128i tmp0 = _mm_load_si128((__m128i *) (vals + i));
            __m128i tmp1 = _mm_load_si128((__m128i *) (vals + i + 4));
            __m128i tmp2 = _mm_load_si128((__m128i *) (vals + i + 8));
            __m128i tmp3 = _mm_load_si128((__m128i *) (vals + i + 12));

            __m128i cmp_vec0 = _mm_cmpgt_epi32(tmp0, _127); /* Create a mask */
            __m128i cmp_vec1 = _mm_cmpgt_epi32(tmp1, _127);
            __m128i cmp_vec2 = _mm_cmpgt_epi32(tmp2, _127);
            __m128i cmp_vec3 = _mm_cmpgt_epi32(tmp3, _127);

            tmp0 = _mm_and_si128(cmp_vec0, tmp0); /* Using the mask to zero out unwanted values */
            tmp1 = _mm_and_si128(cmp_vec1, tmp1);
            tmp2 = _mm_and_si128(cmp_vec2, tmp2);
            tmp3 = _mm_and_si128(cmp_vec3, tmp3);

            sum_vec = _mm_add_epi32(sum_vec, tmp0);
            sum_vec = _mm_add_epi32(sum_vec, tmp1);
            sum_vec = _mm_add_epi32(sum_vec, tmp2);
            sum_vec = _mm_add_epi32(sum_vec, tmp3);
        }

        /* tail case */
        /* Hint: you'll need 1 or maybe 2 tail cases here. */
        unsigned int num_left = NUM_ELEMS - (NUM_ELEMS / 16 * 16);
        int mask0[4]= {0, 0, 0, 0};
        int mask1[4]= {0, 0, 0, 0};
        int mask2[4]= {0, 0, 0, 0};
        int mask3[4]= {0, 0, 0, 0};

        if (num_left != 0)
        {
            unsigned int j = NUM_ELEMS / 16 * 16; /* Counter for vals, which is seperate from the coutner of mask#s */
            for(unsigned int i = 0; i < 4 && j < NUM_ELEMS; i++)
            {
                mask0[i] += vals[j++];
            }

            for(unsigned int i = 0; i < 4 && j < NUM_ELEMS; i++)
            {
                mask1[i] += vals[j++];
            }

            for(unsigned int i = 0; i < 4 && j < NUM_ELEMS; i++)
            {
                mask2[i] += vals[j++];
            }

            for(unsigned int i = 0; i < 4 && j < NUM_ELEMS; i++)
            {
                mask3[i] += vals[j++];
            }

            __m128i tmp0 = _mm_load_si128((__m128i *) mask0);
            __m128i tmp1 = _mm_load_si128((__m128i *) mask1);
            __m128i tmp2 = _mm_load_si128((__m128i *) mask2);
            __m128i tmp3 = _mm_load_si128((__m128i *) mask3);

            __m128i cmp_vec0 = _mm_cmpgt_epi32(tmp0, _127); /* Create a mask */
            __m128i cmp_vec1 = _mm_cmpgt_epi32(tmp1, _127);
            __m128i cmp_vec2 = _mm_cmpgt_epi32(tmp2, _127);
            __m128i cmp_vec3 = _mm_cmpgt_epi32(tmp3, _127);

            tmp0 = _mm_and_si128(cmp_vec0, tmp0); /* Using the mask to zero out unwanted values */
            tmp1 = _mm_and_si128(cmp_vec1, tmp1);
            tmp2 = _mm_and_si128(cmp_vec2, tmp2);
            tmp3 = _mm_and_si128(cmp_vec3, tmp3);

            sum_vec = _mm_add_epi32(sum_vec, tmp0);
            sum_vec = _mm_add_epi32(sum_vec, tmp1);
            sum_vec = _mm_add_epi32(sum_vec, tmp2);
            sum_vec = _mm_add_epi32(sum_vec, tmp3);
        }

        int ret_vec[4];
        _mm_storeu_si128((__m128i *) ret_vec, sum_vec);

        for (unsigned int i = 0; i < 4; i++)
        {
            result += ret_vec[i];
        }
    }

    /* DO NOT MODIFY ANYTHING BELOW THIS LINE (in this function) */
    clock_t end = clock();
    printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
    return result;
}

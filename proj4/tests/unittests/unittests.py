from utils import *
from unittest import TestCase

"""
- For each operation, you should write tests to test  on matrices of different sizes.
- Keep in mind that the tests provided in the starter code are NOT comprehensive. That is, we strongly
advise you to modify them and add new tests.
- Hint: use dp_mc_matrix to generate dumbpy and numc matrices with the same data and use
      cmp_dp_nc_matrix to compare the results
"""
class TestAdd(TestCase):
    def test_small_add(self):
        # TODO: YOUR CODE HERE
        dp_mat1, nc_mat1 = rand_dp_nc_matrix(2, 2, seed=0)
        dp_mat2, nc_mat2 = rand_dp_nc_matrix(2, 2, seed=1)
        is_correct, speed_up = compute([dp_mat1, dp_mat2], [nc_mat1, nc_mat2], "add")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_medium_add(self):
        dp_mat1, nc_mat1 = rand_dp_nc_matrix(100, 500, seed=5)
        dp_mat2, nc_mat2 = rand_dp_nc_matrix(100, 500, seed=5)
        is_correct, speed_up = compute([dp_mat1, dp_mat2], [nc_mat1, nc_mat2], "add")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_large_add(self):
        dp_mat1, nc_mat1 = rand_dp_nc_matrix(40000, 10000, seed=5)
        dp_mat2, nc_mat2 = rand_dp_nc_matrix(40000, 10000, seed=5)
        is_correct, speed_up = compute([dp_mat1, dp_mat2], [nc_mat1, nc_mat2], "add")
        self.assertTrue(is_correct)
        print_speedup(speed_up)


# (OPTIONAL) Uncomment the following TestSub class if you have implemented matrix subtraction.
class TestSub(TestCase):
   def test_small_sub(self):
       # TODO: YOUR CODE HERE
       dp_mat1, nc_mat1 = rand_dp_nc_matrix(2, 2, seed=0)
       dp_mat2, nc_mat2 = rand_dp_nc_matrix(2, 2, seed=1)
       is_correct, speed_up = compute([dp_mat1, dp_mat2], [nc_mat1, nc_mat2], "sub")
       self.assertTrue(is_correct)
       try:
           nc.Matrix(3, 3) - nc.Matrix(2, 2)
           self.assertTrue(False)
       except ValueError as e:
           print(e)
           pass
       print_speedup(speed_up)

   def test_medium_sub(self):
       # TODO: YOUR CODE HERE
       pass

   def test_large_sub(self):
       # TODO: YOUR CODE HERE
       pass

class TestAbs(TestCase):
    def test_small_abs(self):
        # TODO: YOUR CODE HERE
        dp_mat, nc_mat = rand_dp_nc_matrix(2, 2, seed=0)
        is_correct, speed_up = compute([dp_mat], [nc_mat], "abs")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_medium_abs(self):
        # TODO: YOUR CODE HERE
        pass

    def test_large_abs(self):
        # TODO: YOUR CODE HERE
        pass

# (OPTIONAL) Uncomment the following TestNeg class if you have implemented matrix negation.
# class TestNeg(TestCase):
#    def test_small_neg(self):
#        # TODO: YOUR CODE HERE
#        dp_mat, nc_mat = rand_dp_nc_matrix(2, 2, seed=0)
#        is_correct, speed_up = compute([dp_mat], [nc_mat], "neg")
#        self.assertTrue(is_correct)
#        print_speedup(speed_up)
#    def test_medium_neg(self):
#        # TODO: YOUR CODE HERE
#        pass

#    def test_large_neg(self):
#        # TODO: YOUR CODE HERE
#        pass

class TestMul(TestCase):
    def test_small_mul(self):
        # TODO: YOUR CODE HERE
        #dp_mat1, nc_mat1 = dp_nc_matrix([[1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4]])
        #dp_mat2, nc_mat2 = dp_nc_matrix([[5, 6, 7, 8], [5, 6, 7, 8], [5, 6, 7, 8], [5, 6, 7, 8]])
        dp_mat1, nc_mat1 = dp_nc_matrix([[5, 3, 2, 4, 6], [4, 6, 2, 7, 5], [4, 7, 6, 5, 3], [2, 7, 4, 5, 3], [5, 1, 6, 9, 8]])
        dp_mat2, nc_mat2 = dp_nc_matrix([[1, 2, 3, 4, 5], [1, 2, 3, 4, 5], [1, 2, 3, 4, 5], [1, 2, 3, 4, 5], [1, 2, 3, 4, 5]])
        is_correct, speed_up = compute([dp_mat1, dp_mat2], [nc_mat1, nc_mat2], "mul")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_uneven_mul(self):
        dp_mat1, nc_mat1 = dp_nc_matrix([[1, 2, 3], [1, 2, 3]])
        dp_mat2, nc_mat2 = dp_nc_matrix([[1, 1, 1, 1], [2, 2, 2, 2], [3, 3, 3, 3]])
        is_correct, speed_up = compute([dp_mat1, dp_mat2], [nc_mat1, nc_mat2], "mul")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_fail_mul(self):
        try:
            nc.Matrix(3, 3) * nc.Matrix(2, 2)
            self.assertTrue(False)
        except ValueError as e:
            print(e)
            pass

    def test_medium_mul(self):
        dp_mat1, nc_mat1 = dp_nc_matrix([[1, 2], [3, 4], [ 5, 6]]) # 3 x 2
        dp_mat2, nc_mat2 = dp_nc_matrix([[7, 8, 9], [10, 11, 12]]) # 2 x 3
        is_correct, speed_up = compute([dp_mat1, dp_mat2], [nc_mat1, nc_mat2], "mul")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_large_mul(self):
        dp_mat1, nc_mat1 = rand_dp_nc_matrix(500, 10000, seed=3)
        dp_mat2, nc_mat2 = rand_dp_nc_matrix(10000, 500, seed=1)
        is_correct, speed_up = compute([dp_mat1, dp_mat2], [nc_mat1, nc_mat2], "mul")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

class TestPow(TestCase):
    def test_small_pow_odd(self):
        dp_mat, nc_mat = dp_nc_matrix([[1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4], [1, 2, 3, 4]])
        is_correct, speed_up = compute([dp_mat, 7], [nc_mat, 7], "pow")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_small_neg_val(self):
        dp_mat, nc_mat = dp_nc_matrix([[-1, -2, -3], [-1, -2, -3], [1, 2, 3]])
        is_correct, speed_up = compute([dp_mat, 3], [nc_mat, 3], "pow")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_small_pow_even(self):
        dp_mat, nc_mat = dp_nc_matrix([[1, 2, 3], [1, 2, 3], [1, 2, 3]])
        is_correct, speed_up = compute([dp_mat, 6], [nc_mat, 6], "pow")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_pow_1(self):
        dp_mat, nc_mat = rand_dp_nc_matrix(1, 1, seed=3)
        is_correct, speed_up = compute([dp_mat, 3], [nc_mat, 3], "pow")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_pow_2(self):
        dp_mat, nc_mat = rand_dp_nc_matrix(1, 1, seed=3)
        is_correct, speed_up = compute([dp_mat, 0], [nc_mat, 0], "pow")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_pow_3(self):
        dp_mat, nc_mat = rand_dp_nc_matrix(15, 15, seed=3)
        is_correct, speed_up = compute([dp_mat, 1], [nc_mat, 1], "pow")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_pow_4(self):
        dp_mat, nc_mat = rand_dp_nc_matrix(15, 15, seed=3)
        is_correct, speed_up = compute([dp_mat, 0], [nc_mat, 0], "pow")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_pow_5(self):
        dp_mat, nc_mat = rand_dp_nc_matrix(16, 16, seed=3)
        is_correct, speed_up = compute([dp_mat, 25], [nc_mat, 25], "pow")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_pow_6(self):
        dp_mat, nc_mat = rand_dp_nc_matrix(15, 15, seed=3)
        is_correct, speed_up = compute([dp_mat, 32], [nc_mat, 32], "pow")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_pow_7(self):
        dp_mat, nc_mat = rand_dp_nc_matrix(15, 15, seed=3)
        is_correct, speed_up = compute([dp_mat, 24], [nc_mat, 24], "pow")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_medium_pow(self):
        dp_mat, nc_mat = rand_dp_nc_matrix(100, 100, seed=3)
        is_correct, speed_up = compute([dp_mat, 5], [nc_mat, 5], "pow")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_large_pow(self):
        dp_mat, nc_mat = rand_dp_nc_matrix(1305, 1305, seed=3)
        is_correct, speed_up = compute([dp_mat, 15], [nc_mat, 15], "pow")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_zero_pow(self):
        dp_mat, nc_mat = rand_dp_nc_matrix(1000, 1000, seed=3)
        is_correct, speed_up = compute([dp_mat, 0], [nc_mat, 0], "pow")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_one_pow(self):
        dp_mat, nc_mat = rand_dp_nc_matrix(1000, 1000, seed=3)
        is_correct, speed_up = compute([dp_mat, 1], [nc_mat, 1], "pow")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_dim_one(self):
        dp_mat, nc_mat = rand_dp_nc_matrix(1, 1, seed=3)
        is_correct, speed_up = compute([dp_mat, 3], [nc_mat, 3], "pow")
        self.assertTrue(is_correct)
        print_speedup(speed_up)

    def test_fail_pow_dim(self):
        try:
            dp_mat, nc_mat = rand_dp_nc_matrix(2, 3, seed=3)
            is_correct, speed_up = compute([dp_mat, 2], [nc_mat, 2], "pow")
            self.assertTrue(False)
        except ValueError as e:
            print(e)
            pass

    def test_fail_pow_neg(self):
        try:
            dp_mat, nc_mat = rand_dp_nc_matrix(2, 2, seed=3)
            is_correct, speed_up = compute([dp_mat, -1], [nc_mat, -1], "pow")
            self.assertTrue(False)
        except ValueError as e:
            print(e)
            pass

    def test_fail_pow_int(self):
        try:
            dp_mat, nc_mat = rand_dp_nc_matrix(2, 2, seed=3)
            is_correct, speed_up = compute([dp_mat, 0.3], [nc_mat, 0.3], "pow")
            self.assertTrue(False)
        except TypeError as e:
            print(e)
            pass

class TestGet(TestCase):
    def test_get(self):
        # TODO: YOUR CODE HERE
        dp_mat, nc_mat = rand_dp_nc_matrix(2, 2, seed=0)
        rand_row = np.random.randint(dp_mat.shape[0])
        rand_col = np.random.randint(dp_mat.shape[1])
        self.assertEqual(round(dp_mat.get(rand_row, rand_col), decimal_places),
            round(nc_mat.get(rand_row, rand_col), decimal_places))

class TestSet(TestCase):
    def test_set(self):
        # TODO: YOUR CODE HERE
        dp_mat, nc_mat = rand_dp_nc_matrix(2, 2, seed=0)
        rand_row = np.random.randint(dp_mat.shape[0])
        rand_col = np.random.randint(dp_mat.shape[1])
        dp_mat.set(rand_row, rand_col, 2)
        nc_mat.set(rand_row, rand_col, 2)
        self.assertTrue(cmp_dp_nc_matrix(dp_mat, nc_mat))

    """
    def test_fail_set_range(self):
        try:
            mat = nc.Matrix([[1, 2, 3], [4, 5, 6]])
            slice = mat[0]
            slice[3] = 11
            self.assertTrue(False)
        except IndexError as e:
            print(e)
            pass

    def test_fail_set_value(self):
        try:
            dp_mat, nc_mat = rand_dp_nc_matrix(3, 2, seed=0)
            rand_row = np.random.randint(dp_mat.shape[0])
            rand_col = np.random.randint(dp_mat.shape[1])
            dp_mat.set(rand_row, rand_col, "string")
            self.assertTrue(False)
        except IndexError as e:
            print(e)
            pass
    """

    def test_set_value(self):
        dp_mat, nc_mat = rand_dp_nc_matrix(3, 2, seed=0)
        rand_row = np.random.randint(dp_mat.shape[0])
        rand_col = np.random.randint(dp_mat.shape[1])
        dp_mat.set(rand_row, rand_col, 0.2)
        nc_mat.set(rand_row, rand_col, 0.2)
        self.assertTrue(cmp_dp_nc_matrix(dp_mat, nc_mat))


class TestShape(TestCase):
    def test_shape(self):
        # TODO: YOUR CODE HERE
        dp_mat, nc_mat = rand_dp_nc_matrix(2, 2, seed=0)
        self.assertTrue(dp_mat.shape == nc_mat.shape)

class TestIndexGet(TestCase):
    def test_index_get(self):
        # TODO: YOUR CODE HERE
        dp_mat, nc_mat = rand_dp_nc_matrix(2, 2, seed=0)
        rand_row = np.random.randint(dp_mat.shape[0])
        rand_col = np.random.randint(dp_mat.shape[1])
        self.assertEqual(round(dp_mat[rand_row][rand_col], decimal_places),
            round(nc_mat[rand_row][rand_col], decimal_places))

class TestIndexSet(TestCase):
    def test_set(self):
        # TODO: YOUR CODE HERE
        dp_mat, nc_mat = rand_dp_nc_matrix(2, 2, seed=0)
        rand_row = np.random.randint(dp_mat.shape[0])
        rand_col = np.random.randint(dp_mat.shape[1])
        dp_mat[rand_row][rand_col] = 2.0
        nc_mat[rand_row][rand_col] = 2.0
        self.assertTrue(cmp_dp_nc_matrix(dp_mat, nc_mat))
        self.assertEqual(nc_mat[rand_row][rand_col], 2)

class TestSlice(TestCase):
    def test_slice(self):
        # TODO: YOUR CODE HERE
        dp_mat, nc_mat = rand_dp_nc_matrix(2, 2, seed=0)
        self.assertTrue(cmp_dp_nc_matrix(dp_mat[0], nc_mat[0]))
        self.assertTrue(cmp_dp_nc_matrix(dp_mat[1], nc_mat[1]))

import os
import pathlib
import subprocess
from unittest import TestCase
from framework import AssemblyTest, print_coverage


class TestAbs(TestCase):
    def test_zero(self):
        t = AssemblyTest(self, "abs.s")
        # load 0 into register a0
        t.input_scalar("a0", 0)
        # call the abs function
        t.call("abs")
        # check that after calling abs, a0 is equal to 0 (abs(0) = 0)
        t.check_scalar("a0", 0)
        # generate the `assembly/TestAbs_test_zero.s` file and run it through venus
        t.execute()

    def test_one(self):
        # same as test_zero, but with input 1
        t = AssemblyTest(self, "abs.s")
        t.input_scalar("a0", 1)
        t.call("abs")
        t.check_scalar("a0", 1)
        t.execute()

    def test_minus_one(self):
        # Indicates we are creating the test for the `abs.s` file
        t = AssemblyTest(self, "abs.s")
        # Setting the argument register a0 to have value of -1
        t.input_scalar("a0", -1)
        # Calling the abs function
        t.call("abs")
        # The a0 register is now the return value
        # Checking if a0 is now 1
        t.check_scalar("a0", 1)
        t.execute()

    @classmethod
    def tearDownClass(cls):
        print_coverage("abs.s", verbose=False)


class TestRelu(TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "relu.s")
        # create an array in the data section
        array0 = t.array([1, -2, 3, -4, 5, -6, 7, -8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, -94, 95, 96, 97, 98, 99, 100, 101, 102, -103, 104, 105, 106, 107, 108, 109,
                          110, 111, 112, 113, -114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, -129, 130, 131, 132, 133, 134, 135, -136, -137, 138, 139, 140, 141, -142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, -184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # set a1 to the length of our array
        t.input_scalar("a1", len(array0))
        # call the relu function
        t.call("relu")
        # check that the array0 was changed appropriately
        t.check_array(array0, [1, 0, 3, 0, 5, 0, 7, 0, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 0, 95, 96, 97, 98, 99, 100, 101, 102, 0, 104, 105, 106, 107, 108,
                               109, 110, 111, 112, 113, 0, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 0, 130, 131, 132, 133, 134, 135, 0, 0, 138, 139, 140, 141, 0, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 0, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200])
        # generate the `assembly/TestRelu_test_simple.s` file and run it through venus
        t.execute()

    def test_all_zeros(self):
        t = AssemblyTest(self, "relu.s")
        # create an array in the data section
        array0 = t.array([0, 0, 0, 0, 0, 0, 0, 0, 0])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # set a1 to the length of our array
        t.input_scalar("a1", len(array0))
        # call the relu function
        t.call("relu")
        # check that the array0 was changed appropriately
        t.check_array(array0, [0, 0, 0, 0, 0, 0, 0, 0, 0])
        # generate the `assembly/TestRelu_test_simple.s` file and run it through venus
        t.execute()

    def test_all_neg(self):
        t = AssemblyTest(self, "relu.s")
        # create an array in the data section
        array0 = t.array([-1, -2, -3, -4, -5, -6, -7, -8, -9])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # set a1 to the length of our array
        t.input_scalar("a1", len(array0))
        # call the relu function
        t.call("relu")
        # check that the array0 was changed appropriately
        t.check_array(array0, [0, 0, 0, 0, 0, 0, 0, 0, 0])
        # generate the `assembly/TestRelu_test_simple.s` file and run it through venus
        t.execute()

    def test_max(self):
        t = AssemblyTest(self, "relu.s")
        # create an array in the data section
        array0 = t.array([2 ^ 31, -2, -3, -4, -5, -6, -7, -8, -9])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # set a1 to the length of our array
        t.input_scalar("a1", len(array0))
        # call the relu function
        t.call("relu")
        # check that the array0 was changed appropriately
        t.check_array(array0, [2 ^ 31, 0, 0, 0, 0, 0, 0, 0, 0])
        # generate the `assembly/TestRelu_test_simple.s` file and run it through venus
        t.execute()

    def test_zero_elems(self):
        t = AssemblyTest(self, "relu.s")
        # create an array in the data section
        array0 = t.array([])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # set a1 to the length of our array
        t.input_scalar("a1", len(array0))
        # call the relu function
        t.call("relu")
        # generate the `assembly/TestRelu_test_simple.s` file and run it through venus
        t.execute(code=32)

    def test_one_zero(self):
        t = AssemblyTest(self, "relu.s")
        # create an array in the data section
        array0 = t.array([0])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # set a1 to the length of our array
        t.input_scalar("a1", len(array0))
        # call the relu function
        t.call("relu")
        t.check_array(array0, [0])
        # generate the `assembly/TestRelu_test_simple.s` file and run it through venus
        t.execute(code=0)

    @classmethod
    def tearDownClass(cls):
        print_coverage("relu.s", verbose=False)


class TestArgmax(TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([1, 2, 3, 4])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 3)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()

    def test_zero_elems(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute(code=32)

    def test_same_max(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([4, 2, 3, 4])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 0)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()

    def test_negative_values(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([-1, -2, -3, -4])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 0)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()

    @classmethod
    def tearDownClass(cls):
        print_coverage("argmax.s", verbose=False)


class TestDot(TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        vector0 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        vector1 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        # load array addresses into argument registers
        t.input_array("a0", vector0)
        t.input_array("a1", vector1)
        # load array attributes into argument registers
        t.input_scalar("a2", len(vector0))
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 1)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", 285)
        t.execute()

    def test_no_elems(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        vector0 = t.array([])
        vector1 = t.array([])
        # load array addresses into argument registers
        t.input_array("a0", vector0)
        t.input_array("a1", vector1)
        # load array attributes into argument registers
        t.input_scalar("a2", len(vector0))
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 1)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", 0)
        t.execute(code=32)

    def test_zero_stride1(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        vector0 = t.array([1, 2, 3])
        vector1 = t.array([1, 2, 3])
        # load array addresses into argument registers
        t.input_array("a0", vector0)
        t.input_array("a1", vector1)
        # load array attributes into argument registers
        t.input_scalar("a2", len(vector0))
        t.input_scalar("a3", 0)
        t.input_scalar("a4", 1)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", 0)
        t.execute(code=33)

    def test_zero_stride2(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        vector0 = t.array([1, 2, 3])
        vector1 = t.array([1, 2, 3])
        # load array addresses into argument registers
        t.input_array("a0", vector0)
        t.input_array("a1", vector1)
        # load array attributes into argument registers
        t.input_scalar("a2", len(vector0))  # length
        t.input_scalar("a3", 1)  # stride 1
        t.input_scalar("a4", 0)  # stride 2
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", 0)
        t.execute(code=33)

    def test_stride(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        vector0 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        vector1 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        # load array addresses into argument registers
        t.input_array("a0", vector0)
        t.input_array("a1", vector1)
        # load array attributes into argument registers
        t.input_scalar("a2", 3)  # length
        t.input_scalar("a3", 1)  # stride 1
        t.input_scalar("a4", 2)  # stride 2
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", 22)
        t.execute()

    def test_matrix1(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        vector0 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        vector1 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        # load array addresses into argument registers
        t.input_array("a0", vector0)
        t.input_array("a1", vector1)
        # load array attributes into argument registers
        t.input_scalar("a2", 3)  # length
        t.input_scalar("a3", 1)  # stride 1
        t.input_scalar("a4", 3)  # stride 2
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", 30)
        t.execute()

    @classmethod
    def tearDownClass(cls):
        print_coverage("dot.s", verbose=False)


class TestMatmul(TestCase):

    def do_matmul(self, m0, m0_rows, m0_cols, m1, m1_rows, m1_cols, result, code=0):
        t = AssemblyTest(self, "matmul.s")
        # we need to include (aka import) the dot.s file since it is used by matmul.s
        t.include("dot.s")

        # create arrays for the arguments and to store the result
        array0 = t.array(m0)
        array1 = t.array(m1)
        array_out = t.array([0] * len(result))

        # load address of input matrices and set their dimensions
        t.input_array("a0", array0)
        t.input_scalar("a1", m0_rows)
        t.input_scalar("a2", m0_cols)
        t.input_array("a3", array1)
        t.input_scalar("a4", m1_rows)
        t.input_scalar("a5", m1_cols)
        # load address of output array
        t.input_array("a6", array_out)

        # call the matmul function
        t.call("matmul")

        # check the content of the output array
        t.check_array(array_out, result)

        # generate the assembly file and run it through venus, we expect the simulation to exit with code `code`
        t.execute(code=code)

    def test_simple(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150]
        )

    def test_simple3(self):
        self.do_matmul(
            [1, 2], 1, 2,
            [1, 2], 2, 1,
            [5]
        )

    def test_miss_match_dimensions(self):
        self.do_matmul(
            [1, 2, 3, 5, 6, 7], 3, 2,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [0],
            34
        )

    def test_simple2(self):
        self.do_matmul(
            [1, 2, 5, 6], 2, 2,
            [1, 2, 9, 7], 2, 2,
            [19, 16, 59, 52]
        )

    def test_offbalance(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 2, 5,
            [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 5, 2,
            [95, 110, 220, 260]
        )

    def test_zero_elems(self):
        self.do_matmul(
            [0], 0, 0,
            [0], 0, 0,
            [0],
            34
        )

    def test_length_one_vector(self):
        self.do_matmul(
            [1], 1, 1,
            [1], 1, 1,
            [1],
        )

    def test_large_mat(self):
        self.do_matmul(
            [11, 23, 15, 28, 93, 23, 37, 76, 9, 85, 86,
                46, 55, 3, 54, 46, 63, 2, 82, 87], 5, 4,
            [77, 61, 61, 87, 13, 68, 19, 70, 92, 91, 69, 20], 4, 3,
            [5681, 3952, 4175, 16781, 13806, 12161, 13908, 10848,
             15161, 9708, 10348, 9447, 14500, 15612, 13263]
        )

    @classmethod
    def tearDownClass(cls):
        print_coverage("matmul.s", verbose=False)


class TestReadMatrix(TestCase):

    def do_read_matrix(self, fail='', code=0):
        t = AssemblyTest(self, "read_matrix.s")
        # load address to the name of the input file into register a0
        t.input_read_filename(
            "a0", "inputs/test_read_matrix/test_input.bin")

        # allocate space to hold the rows and cols output parameters
        rows = t.array([-1])
        cols = t.array([-1])

        # load the addresses to the output parameters into the argument registers
        t.input_array("a1", rows)
        t.input_array("a2", cols)

        # call the read_matrix function
        t.call("read_matrix")

        # check the output from the function
        t.check_array_pointer("a0", [1, 2, 3, 4, 5, 6, 7, 8, 9])
        t.check_array(rows, [3])
        t.check_array(cols, [3])

        # generate assembly and run it through venus
        t.execute(fail=fail, code=code)

    def test_simple(self):
        self.do_read_matrix()

    def test_fail_fopen(self):
        self.do_read_matrix('fopen', 64)

    def test_fail_fclose(self):
        self.do_read_matrix('fclose', 65)

    def test_fail_fread(self):
        self.do_read_matrix('fread', 66)

    def test_fail_malloc(self):
        self.do_read_matrix('malloc', 48)

    @classmethod
    def tearDownClass(cls):
        print_coverage("read_matrix.s", verbose=False)


class TestWriteMatrix(TestCase):

    def do_write_matrix(self, fail='', code=0):
        t = AssemblyTest(self, "write_matrix.s")
        outfile = "outputs/test_write_matrix/student.bin"
        # load output file name into a0 register
        t.input_write_filename("a0", outfile)
        # load input array and other arguments
        input_array = t.array(
            [1, 2, 3, 4, 5, 11, 12, 13, 14, 15, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5])
        t.input_array("a1", input_array)
        t.input_scalar("a2", 5)
        t.input_scalar("a3", 4)
        # call `write_matrix` function
        t.call("write_matrix")
        # generate assembly and run it through venus
        t.execute(fail=fail, code=code)
        # compare the output file against the reference
        t.check_file_output(outfile, "outputs/test_write_matrix/uneven.bin")

    def test_simple(self):
        self.do_write_matrix()

    def test_fail_fopen(self):
        self.do_write_matrix('fopen', 64)

    def test_fail_fclose(self):
        self.do_write_matrix('fclose', 65)

    def test_fail_fwrite(self):
        self.do_write_matrix('fwrite', 67)

    def test_fail_malloc(self):
        self.do_write_matrix('malloc', 48)

    @classmethod
    def tearDownClass(cls):
        print_coverage("write_matrix.s", verbose=False)


class TestClassify(TestCase):

    def make_test(self):
        t = AssemblyTest(self, "classify.s")
        t.include("argmax.s")
        t.include("dot.s")
        t.include("matmul.s")
        t.include("read_matrix.s")
        t.include("relu.s")
        t.include("write_matrix.s")
        return t

    def test_simple0_input0(self):
        t = self.make_test()
        out_file = "outputs/test_basic_main/student0.bin"
        ref_file = "outputs/test_basic_main/reference0.bin"
        args = ["inputs/simple0/bin/m0.bin", "inputs/simple0/bin/m1.bin",
                "inputs/simple0/bin/inputs/input0.bin", out_file]
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus
        t.execute(args=args)
        # compare the output file and
        t.check_file_output(out_file, ref_file)
        # compare the classification output with `check_stdout`
        t.check_stdout(2)

    @classmethod
    def tearDownClass(cls):
        print_coverage("classify.s", verbose=False)


# The following are some simple sanity checks:
script_dir = pathlib.Path(os.path.dirname(__file__)).resolve()


def compare_files(test, actual, expected):
    assert os.path.isfile(
        expected), f"Reference file {expected} does not exist!"
    test.assertTrue(os.path.isfile(
        actual), f"It seems like the program never created the output file {actual}!")
    # open and compare the files
    with open(actual, 'rb') as a:
        actual_bin = a.read()
    with open(expected, 'rb') as e:
        expected_bin = e.read()
    test.assertEqual(actual_bin, expected_bin,
                     f"Bytes of {actual} and {expected} did not match!")


class TestMain(TestCase):
    """ This sanity check executes src/main.S using venus and verifies the stdout and the file that is generated.
    """

    def run_main(self, inputs, output_id, label):
        args = [f"{inputs}/m0.bin", f"{inputs}/m1.bin",
                f"{inputs}/inputs/input0.bin",
                f"outputs/test_basic_main/student{output_id}.bin"]
        reference = f"outputs/test_basic_main/reference{output_id}.bin"

        t = AssemblyTest(self, "main.s", no_utils=True)
        t.call("main")
        t.execute(args=args)
        t.check_stdout(label)
        t.check_file_output(args[-1], reference)

    def test0(self):
        self.run_main("inputs/simple0/bin", "0", "2")

    def test1(self):
        self.run_main("inputs/simple1/bin", "1", "1")

# numc.c

* Parsing PyObject *args
  - Even though args seems like it is one object, it actally holds alot of objects inside of it
  - I used the PyArg_UnpackTuple function to retrieve the objects stored in args

* Error Checking
  - Type checking was also pretty easy
  - For numbers I used the individual Check functions to check if the PyObject passed in was the type I wanted
  - For self created types such as the Matrix61c type, I used the PyObject_TypeCheck function

# matrix.c

## Performance

* add / sub
  - I used SSE intrincsics for data level parallisism because I could just linearly add the indexes

* multiply
  - I used a combination of SSE intrincsics and omp multithreading
  - To do matrix multiplications I split up the matrix into vectors and multiplied the vectors individually
    - Used SSE intrinsics
  - This method may be slower than do matrix multiplication directly on the matrix
  - To speed up mul_matrix, I used inlined function calls to reduce the performace loss from function calls
  - I used omp multithreading to run multiple vector multiplications at once

* pow
  - I used an algorithmic optimizations
  - I used the squaring algorithm to reduce the amount of exponintiations I have to do to log2

### Provide answers to the following questions for each set of partners.
- How many hours did you spend on the following tasks?
  - Task 1 (Matrix functions in C): 5
  - Task 2 (Writing the Python-C interface): 5
  - Task 3 (Speeding up matrix operations): 20
- Was this project interesting? What was the most interesting aspect about it?
  - Yes this project was interesting, this was the first time I tried performance programming. The most interesting aspect was that I could take advantage of the underlying hardware to increase my performance.
- What did you learn?
  - I learned how to use intel SIMD, cache blocking, and how to break down problems do be concurrent so I could use multithreading.
- Is there anything you would change?
  - I would make the speed performace lower. I was not able to get full credit (only 65%) on the speed performance test.

### If you worked with a partner:
<b> I did not </b>
- In one short paragraph, describe your contribution(s) to the project.
  - <b>---</b>
- In one short paragraph, describe your partner's contribution(s) to the project.
  - <b>---</b>

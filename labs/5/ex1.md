# Astro 585 Lab 5, Exercise 1

### Performance Comparisons (2/2):  Memory Access & Object Oriented Programming

### 1.  Dense Matrix Multiply
Many problems involve performing linear algebra.  Fortunately, there are excellent libraries that make use of clever algorithms to perform linear algebra efficiently and robustly.  In this exercise, youll write multiple functions to multiply a matrix times a vector to compare their performance.  

a)  Write a function that takes a matrix A (type Array{Float64,2}) and a vector x (type Array{Float64,1}) and returns the product of A times b using Julias default linear algebra routines (accessed by just A*b). 

b) Write a function that takes a matrix A and a vector x and returns the product of A times b, but without using Julias default linear algebra routines.  Youll use two loops.  For this part, let the inner loop run over the columns (i.e., second index) for A.  Test that this function gives the same answer as the function from part 1a (modulo floating point arithmetic).

c) Write a function that takes a matrix A and a vector x and returns the product of A times b, but without using Julias default linear algebra routines.  Youll use two loops.  For this part, let the inner loop run over the rows (i.e., first index) for A.  Test that this function gives the same answer as the function from parts 1a & 1b (modulo floating point arithmetic).

d) Before you benchmark these, think about how the different versions will perform.  Which version of the function do you predict will perform best for large matrices?  Why?  

e) Which version of the functions do you predict will perform best for small matrices?  Why?

f)  Benchmark each of these three functions for a wide range of matrix sizes, including at least one set of small matrices (e.g., 8x8) and one set of large matrices (e.g., 1024x1024 or larger).   

g) Compare the performance of the three functions.  How do the results compare to your predictions?  For any predictions that weren't accurate, try to explain the observed performance behavior.  



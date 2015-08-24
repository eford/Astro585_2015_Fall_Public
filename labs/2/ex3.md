# Astro 585 Lab 2, Exercise 3

# Large linear algebra problems

Consider a modern laptop CPU with 4 GB (=4*2^30) of usable memory and capable performing 20 Gflops/second. Assume it uses 8 bytes of memory to store each floating point number (double precision). [Based on Oliveira & Stewarts Writing Scientific Software, Chapter 5, Problem #6.]

a. What is the largest matrix that the above computer could fit into its available memory at one time?


b. If we use LU factorization to solve a linear system, estimate how long would it take to solve the maximum size linear system that would fit into memory at once. You may assume the computation is maximally efficient, the computer reaches peak performance and the LU decomposition requires 2/3*n^3 flops.

c. For a modern laptop, does memory or compute time limit the size of system that can be practically solved with LU decomposition? 

d. For real life problems, what other considerations are likely to limit performance?

e. How could one practically solve even larger systems?


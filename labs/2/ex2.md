# Astro 585 Lab 2, Exercise 2

# Benchmarking Code, Regression Tests & Algorithmic Optimizations  

### Benchmarking Basic Mathematical Operations

Julia provides several tools for measuring code performance. Perhaps the simplest way is using the `@time` or `@elapsed` macro which can be placed prior to a command, like `@time randn(1000)`. The `@time` macro prints the time, but returns the value of the following expression. The `@elapsed` macro discards the following expressions return value and returns the elapsed time evaluating the expression. 
(For finer control when benchmarking your code, you may want to investigate the `tic()`, `toc()` and `toq()` functions (see the [Julia manual](http://julia.readthedocs.org/en/release-0.3/stdlib/base/?highlight=%40time#Base.tic) for details).)

a) For several common mathematical functions, calculate how many million evaluations your computer performs per second.  
Try a few arithmatic operations, a couple of trig functions, and a logarithm. For example,  
```julia
N = 1000000;
println("rand:  ", 1.0/(@elapsed x = rand(N)), " M evals/sec");
println(".+  :  ",1.0/(@elapsed x.+x), " M evals/sec");
```

How much longer did it take to compute a trig function than simple arithmetic?
How much longer did it take to compute a logarithm than simple arithmetic?
 
### Benchmarking a non-trivial function

For the rest of this exercise, we'll continue to consider the `log_likelihood` function from Lab/HW #1 and exercise 1 of this Lab/HW.
Again, your starting point is  likely similar to the following: 
```julia
srand(42);
Nobs = 100;
z = zeros(Nobs);
sigma = 2. * ones(Nobs);
y = z + sigma .* randn(Nobs);
normal_pdf(z, y, sigma) = exp(-0.5*((y-z)/sigma)^2)/(sqrt(2pi)*sigma);

function log_likelihood_ref(y::Array, sigma::Array, z::Array)
   n = length(y); 
   sum = zero(y[1]); 
   for i in 1:n 
      sum += log(normal_pdf(y[i],z[i],sigma[i])); 
   end; 
   return sum; 
end
```

b) Write a function, `calc_time_log_likelihood(func::Function, Nobs::Int, M::Int = 1)`, that takes two required arguments (the function name and the number of observations) and one optional argument (M, the number of times to repeat the calculation), initializes the y, sigma and z arrays to each have a size Nobs, and returns the time required to evaluate the log_likelihood function M times (ignoring the time required to initialize the arrays).
Remember to commit your new function to your git repository. 

c) Time how long it takes to run your `log_likelihood` function using Nobs=100 and M = 1. Time it again. Compare the two.  Time it a third time.  Why was there such a big difference between the first two times, but not the second and third time?

d) If you were only calling this function a few times with a small array size, then speed wouldn't matter.  But if you were calling it with a very large number of observations or many times, then the performance could be important.   Rerun the above benchmarks but with several values of (N,M).  You want it to perform enough calculations that the timing is accurate, but not so many that it is inconvenient, so probably a run time of order one to ten seconds.  What do your results imply for how you will go about future timing?

e) Next, let's investigate systematically how the run time depends on the size of the array.  You can simply call your `calc_time_log_likelihood` several times and look at the return values.  Or if you have plotting working on your system, you could make a plot of run time versus array size on a log-log scale.
The following example demonstrates how to use: 
1) comprehensions to construct arrays easily, 
2) anonymous functions, 
3) the map function to apply a function to an array of values, and   
4) the PyPlot module (which is just an interface to Python's matplotlib). 
```julia
n_list = Int64[ 2^i for i=1:10 ]
elapsed_list = map(n->calc_time_log_likelihood(log_likelihood_ref,n,100),n_list)

using PyPlot
plot(log10(n_list), log10(elapsed_list), color="red", linewidth=2, marker="+", markersize=12);
xlabel("log N");
ylabel("log (Time/s)");
```

Does the run time increase linearly with the number of observations? If not,
try to explain the origin of the non-linearity. What does this imply for how you will go about future timing.


### Comparing the performance of safe and unsafe versions of a function

f) Use your `calc_time_log_likelihood` function and intuition gained from exercise 1 to compare the performance of your original unsafe implementation of `log_likelihood` to the performance of the safe version `log_likelihood_safe` that includes assert statements.  What does this imply for your future decisions about how often you'll insert assert statements in your future codes?

### Optimizing your code

g) Write a new function `log_likelihood_fast` function that makes use of your knowledge about the normal distribution and properties of logarithms, so as to avoid calling the `exp()` function.  
Remember to commit the file with your new function to your git repository.  
Run your test suite developed above on your new function.  Does it pass?  If not, fix it.
Remember to commit any changes to your git repository.  

h) Congrats on your function passing your previous unit tests.  Now that we have two versions of the same funciton, we can create regression tests!  Write a few additional tests that compare the results computed by your new `log_likelihood_fast` function to the results of your original function (or `log_likelihood_ref`).  

i) Run your regression test(s).  Does your new function pass the regresion tests?  If not, don't panic.  Is it because of your functions?  Or your tests?  Fix your functions and/or tests, so your `log_likelihood_fast` function passes.  
How did this experience affect how you'll test your future science codes when you are optimizing them?

j)  Benchmark the performance of your `log_likelihood_fast` function and compare it to your original implementation. 
How could this influence your future decisions about whether and how to optimize your codes?


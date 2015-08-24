# Astro 585 Lab 2, Exercise 2

# Benchmarking a less trivial function

For the text below, well consider the log_likelihood function and synthetic data from Lab/HW #1, which was probably very similar to the following. 
```julia
srand(42);
Nobs = 100;
z = zeros(Nobs);
sigma = 2. * ones(Nobs);
y = z + sigma .* randn(Nobs);
normal_pdf(z, y, sigma) = exp(-0.5*((y-z)/sigma)^2)/(sqrt(2pi)*sigma);

function log_likelihood(y::Array, sigma::Array, z::Array) 
   n = length(y); 
   sum = zero(y[1]); 
   for i in 1:n 
      sum += log(normal_pdf(y[i],z[i],sigma[i])); 
   end; 
   return sum; 
end
```

a. Write a function, `calc_time_log_likelihood(Nobs::Int, M::Int = 1)`, that takes one required argument (the number of observations) and one optional argument (the number of times to repeat the calculation), initializes the y, sigma and z arrays with the same values each call (with the same Nobs), and returns the time required to evaluate the log_likelihood function M times.

b) Time how long it takes to run `log_likelihood` using Nobs=100 and M = 1. Time it again. Compare the two. Why was there such a big difference?

c) If you were only calling this function a few times, then speed wouldn't matter. But if you were calling it with a very large number of observations or many times, then the performance could be important. Plot the run time versus the size of the array. The following example demonstrates how to use the PyPlot module, comprehensions to construct arrays easily, and the map function to apply a function to an array of values.
```julia
using PyPlot 
n_list = [ 2^i for i=1:10 ] 
elapsed_list = map(calc_time_log_likelihood,n_list) 
plot(log10(n_list), log10(elapsed_list), color="red", linewidth=2, marker="+", markersize=12); 
xlabel("log N"); 
ylabel("log (Time/s)");
```

d. Does the run time increase linearly with the number of observations? If not, try to explain the origin of the non-linearity. What does this imply for how you will go about future timing.


### Assertions

Sometimes a programmer calls a function with arguments that either don't make sense or represent a case that the function was not originally designed to handle properly. The worst possible function behavior in such a case is returning an incorrect result without any warning that something bad has happened. Returning an error at the end is better, but can make it difficult to figure out the problem. Generally, the earlier the problem is spotted, the easier it will be to fix the problem. Therefore, good developers often include assertions to verify that the function arguments are acceptable.

e. Time your current function with Nobs = 100 & M = 100. Then add `@assert` statements to check that the length of the y, z and sigma arrays match. Retime with the same parameters and compare. What does this imply for your future decisions about how often to insert assert statements in your codes?

f. Write a version of the `log_likelihood` and `calc_time_likelihood` functions that take a function as an argument, so that you could use them for distributions other than the normal distribution. Retime and compare. What does this imply for your future decisions about whether to write generic functions that take another function as an argument?

g. Write a version of the log_likelihood function that makes use of your knowledge about the normal distribution, so as to avoid calling the `exp()` function. Retime and compare. How could this influence your future decisions about whether generic or specific functions?

h. Optional (important for IDL & Python gurus): Rewrite the above function without using any for loops. Retime and compare. What does this imply for choosing whether to write loops or vectorized code?

i. Optional (potenetially useful for IDL & Python gurus): Try to improve the performance using either the Devectorize and/or NumericExpressions modules. Retime and compare. Does this change your conclusions from part h? If so, how?


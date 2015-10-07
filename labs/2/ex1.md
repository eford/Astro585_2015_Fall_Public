# Astro 585 Lab 2, Exercise 1

# Developing a Well Tested Function

For this exercise, we'll consider the `log_likelihood` function and synthetic data from Lab/HW #1, which was likely similar to the following. 
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

### Writing Unit Tests

a.  Import the test module that is part of the standard Julia language via 
```julia
using Base.Test
```
Explore how Julia's @test macro works by running code such as
```julia
@test 1==2
@test_approx_eq_eps(1.0,1.001,0.01)
@test_approx_eq_eps(1.0,1.001,0.0001)
```
For further information on using these, see the [Julia manual](http://julia.readthedocs.org/en/release-0.3/stdlib/test/).

b) It's good practice to write unit tests for your functions.  
For example, if `y`, `z` and `sigma` were all an array of ones, then the log likelihood should equal `-0.5*length(sigma)*log(2pi)`, so we could compare that to the results of our function.   
```julia
y = ones(Nobs); 
z = ones(Nobs); 
sigma = ones(Nobs);
@test_approx_eq_eps( log_likelihood_ref(y,sigma,z), -0.5*length(sigma)*log(2pi), 0.0001 )
```

Design and write a set of at least two additional unit tests for the log_likelihood function (using either your function from lab 1 or the one above).  
Remember to place these functions in a file and commit it to a git repository.  
Run your tests.  Do your functions pass all of them?  If not, correct the function (and tests if necessary) and rerun the tests.  
Remember to commit the changes to any functions to your git repository before going on to the next part. 

c)  Often it you may run multiple variations of a test with slightly different parameters (e.g., size of the array).  Similarly, you'll often write multiple versions of a function that does very similar things.  For example, you might write one version that intends to calculate the exact same thing, but more quickly.  Therefore, it would be convenient to have your test packaged as a function, so that it's easy to test different functions several ways.  For example,
```julia
function test_log_likelihood_1(func::Function, Nobs::Integer)
  y = ones(Nobs); 
  z = ones(Nobs); 
  sigma = ones(Nobs);
  isapprox( func(y,sigma,z), -0.5*length(sigma)*log(2pi) )
end

@test test_log_likelihood_1(log_likelihood_ref, 1)
@test test_log_likelihood_1(log_likelihood_ref, 100)
```
Adapt your each of your unit tests from part b into a function similar to the one above.
Confirm that your functions still pass your tests and remember to commit your progress to your git repository.

### Assertions

Sometimes a programmer calls a function with arguments that either don't make sense or represent a case that the function was not originally designed to handle properly. The worst possible function behavior in such a case is returning an incorrect result without any warning that something bad has happened. Returning an error at the end is better, but can make it difficult to figure out the problem. Generally, the earlier the problem is spotted, the easier it will be to fix the problem. Therefore, good developers often include assertions to verify that the function arguments are acceptable.  

For example, the function `test_log_likelihood_1` above can only work if Nobs is finite and non-negative.  Therefore, I might add the lines
```julia
@assert Nobs >= 0 
@assert isfinite(Nobs)
```
just after the function declaration and before the line creating the `y` array. 
(Note that the functions isnan(x), isinf(x) and isfinite(x) allow you to test whether a variable is set to NaN (or -NaN), infinity (or -infinity) or a finite value.) 

d) What are the pre-conditions and post-conditions for the log_likelihood function that you used above? 


e) Create a new function `log_likelihood_safe` based on the function you used above, but adding assertions that enforce the pre-conditions are met (and post-conditions, if appropriate).  Retest your functions.  
Remember to commit your changes to your git repository.


### Testing the assertions!
In the case above, the assertions are probably pretty simple.  But sometimes, the assertions can be complicated enough that you'll need to test that they're working!  When an assert statement is followed by an expression that evaluates to false, then it "throws an exception".  So we want to make sure that is happening when we pass our function invalid arguments.  If you successfully added assertions to make sure the array sizes matched in part e, then it would pass the following test.
```julia
@test_throws Exception log_likelihood_safe(ones(10),ones(20),ones(10))
```

f) Did your previous tests for log_likelihood check the behavior when the pre-conditions and post-conditions are not satisfied?  (Probably not.)  
If not, write more tests to make sure that the function successfully throws an exception when it gets invalid inputs.
Remember to commit any additions/changes to any functions to your git repository. 

g) Optional: Now that you have a bunch of tests, you might like to write a function `runtests_log_likelihood(func::Function)` that performs all of the tests and returns true if they all pass, and false if they don't.  For this, you'll need to use a try...catch statement to "catch" an exceptions that are thrown.  See the [Julia manula](http://julia.readthedocs.org/en/release-0.3/manual/control-flow/#the-try-catch-statement) for help with the syntax.


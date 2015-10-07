# Astro 585 Lab 1, Exercise 5

# Computing Probabilities

A common task is to compute the probability of a set of observations under one or more models.  For example, consider a set of observations ($y_i$'s), each of which can be assumed to follow a normal distribution centered on the true value ($z_i$) with a standard deviation of $\sigma_i$, so 

$$p(y_i | z_i) = e^[-(y_i-z_i)^2/(2\sigma_i^2) / \sqrt{2\pi \sigma_i^2 }$$

When the measurement error for each observation is independent and uncorrelated with the other observations, the probability of a combination of measurements is simply the product of the individual probabilities.  
For example, in this exercise, we will consider a radial velocity planet search that measures the velocity of a target star with a precision of $\sigma_i = 2$ m/s at each of $N_obs$ well-separated observation times.  In the simplest possible model is that the star has no planets and its true velocity is a constant 0 m/s.  

a. Use the functions `srand()`, `zeros()`, `ones()` and `randn()` to seed Julias random number generator with a value of 42, to generate an array of the stars true velocities (assuming it has no planets), generate an array containing the measurement uncertainties, and generate an array containing simulated observations of the stars velocity.  (FYI:  The syntax to perform element-wise multiplication of two arrays and b is  `a .* b` and not simply `a*b`.)  

b. Write a function to calculate the probability of a single measurement value, given the true value and measurement uncertainty, assuming Gaussian measurement uncertainties.
(FYI: You can use the built-in functions `exp(x)` and `sqrt(x)`.  Julia makes it easy to define small functions using the syntax: `add3(a,b,c) = a+b+c` .  )  

c. Write a function to calculate the likelihood of a set of observations, i.e., the probability of an array of measurement values y (first function argument), given arrays of the measurement uncertainties (\sigma; second function argument) and the true values (z; 3rd function argument).  

d. Test your function for $N_obs$ = 100 and $N_obs$ = 600.  Are the results plausible?  If not, whats going wrong?

e.  Write a function that calculates the log of the likelihood for a set of observations (as in 4c).  Compare the results of this function to the log of the results from your function in part 4c.  How could your function be generalized to a case with non-Gaussian measurement uncertainties?  

f.  What lessons does this exercise illustrate that could be important when writing code for your research?  



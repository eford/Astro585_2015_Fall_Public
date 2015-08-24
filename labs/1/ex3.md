# Astro 585 Lab 1, Exercise 3

# Floating Point Arithmetic

Consider an astronomer analyzing data from a large survey or simulation.  A common task is to compute the mean value ($m$) of observations of some quantity ($y_i$) for $N$ different objects and to provide an estimate of the variance of that quantity ($s^2$).   For example, this occurs often when performing Monte Carlo integrations.  In this case, you will investigate some of the potential complications of performing such calculations.

a. Generate an array of simulated data using:
```	srand(42);
	N = 10000;
	true_mean = 10000.;
	y = true_mean+randn(N);
```

The first line seeds a pseudo-random number generator with the value 42 (so that results will be reproducible when run multiple times).  Next two lines create the variable N that contain the integer 10000 and the variable true_mean that contains a floating-point value of 10000.  The fourth line sets a variable y that contains a 1-D array with N values drawn from a normal distribution (i.e., mean true_mean and variance of unity) using the pseudo-random number generator.  Calculate and report the sample mean and sample variance using Julias built in functions:
```
	sample_mean = mean(y);
	sample_var = var(y); 
(sample_mean , sample_var)
```

b.  By default, Julia uses 64 bits of memory to store each floating point value.  To explore the effects of floating point arithmetic, convert the array of y values into arrays of floating point values that use fewer bits to store each value using the following code.   
```
y32bit = convert(Array{Float32,1},y);
y16bit = convert(Array{Float16,1},y);
```
Using Julia's built in mean and var function, compute (and report) the sample mean and sample variance for each of these arrays.  How large are the differences?  Which have the larger errors?  Why?  

c. What do you think would happen if we increased N to 10^5?  What do you think would happen if we increased true_mean to 10^5 (assuming we revert N to 10^4)?  Write down your guesses.   (Its ok if theyre not right.)  

d. Modify the above code to test your hypotheses.  Were your guesses accurate?  If not, explain any differences.  

e. What lessons does this exercise illustrate that could be important when writing similar code for your research?  



# Astro 585 Lab 4, Exercise 2

### Loop vs Vectorized vs Map vs MapReduce vs Devectorized

In many applications, there is some computation that is repeated many, many times with slightly different measurements/initial conditions/model parameters.  There are several ways to tell the computer to perform the calculation many times, each with its own advantages and disadvantages.  In this exercise, you will compare multiple approaches for evaluating an integral over a given region.  

a.  Write a function to evaluate a univariate integrand, f(x).  For starters, we can use the standard normal pdf, exp(-0.5*x^2)/sqrt(2pi).  

b.  Write a function to evaluate the integral, \int_a^b dx f(x) using a for loop.  
[Optionally, what happens if you add @parallel before the for loop (without adding any extra processors)?]

For parts b-e of the items below, the functions should take four parameters, a function, the minimum and maximum limits of integration and an optional specifying the number of function evaluations.  I'll suggest that you start with simple approximation to the function, $(b-a)/N * \sum_i=1^N f( a + i*(b-a)/(N+1) )$.  

It may be useful to use the identify \int_{-a}^{a} dx exp(-0.5*x^2)/sqrt(2pi) = erf(a/sqrt(2))
Benchmark each of the function using 10^4 function evaluations and 10^8 function evaluations (use a combination of a large of evaluations of f(x) inside your function and/or multiple evaluations of the integral), so the run times are at least a tenth of a second.  (I found using >=10^8 total integrand evaluations worked on my laptop.)   
For each part (b-g), remember to commit your function, then perform at least one test that your function is working, and, if necessary, revise and repeat.  

c.  Write a function to evaluate the integral, \int_a^b dx f(x) using vector notation.  

d.  Write a function to evaluate the integral, \int_a^b dx f(x) using the ['map'](http://docs.julialang.org/en/latest/stdlib/base/?highlight=map#Base.map) and [reduce](http://docs.julialang.org/en/latest/stdlib/base/?highlight=map#Base.reduce) functions.

e.  Write a function to evaluate the integral, \int_a^b dx f(x) using the ['mapreduce'](http://docs.julialang.org/en/latest/stdlib/base/?highlight=map#Base.mapreduce) function.  

f.  Write a function to evaluate the integral, \int_a^b dx exp(-0.5*x^2)/sqrt(2pi) using the ['@devec'] macro from the [Devectorize]() package.  (Hint:  For this part, you will need to hardwire the integrand, so you'll remove the function argument to your integrate function.)

g.  Benchmark each of the implementations.  Use a combination of a large number of evaluations of f(x) inside your function and/or repeatedly calling the integration function, so the run times are at least a tenth of a second.  

h.  For at least two of the best performing implementations, profile the code.  Which operations are taking the most time?  Write a few sentances discussing the implications for the prospects for further improving the codes performance.

i.  Repeat parts 2b-2e using a significantly more complex and time consuming function as the integrand.  


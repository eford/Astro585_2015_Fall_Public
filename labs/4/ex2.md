# Astro 585 Lab 4, Exercise 2

### Loop vs Vectorized vs Map vs MapReduce vs Devectorized

In many applications, there is some computation that is repeated many, many times with slightly different values (perhaps measurements or initial conditions or model parameters).  There are several ways to tell the computer to perform the calculation many times, each with its own advantages and disadvantages.  In this exercise, you will compare multiple approaches for evaluating an integral over a given region.  

a.  Write a function to evaluate a univariate integrand, f(x).  For starters, we can use the standard normal pdf, exp(-0.5*x^2)/sqrt(2pi).  

For each of parts b-e, you will write a function to compute the integral should take four parameters, a function, the minimum and maximum limits of integration and an optional specifying the number of function evaluations.  I'll suggest that you start with simple approximation to the function, $(b-a)/N * \sum_i=1^N f( a + i*(b-a)/(N+1) )$.  
Remember to commit each of your functions to your repository, then perform at least one test that your function is working, and, if necessary, revise and repeat.  
For testing your function, it may be useful to use the identity \int_{-a}^{a} dx exp(-0.5*x^2)/sqrt(2pi) = erf(a/sqrt(2))

b.  Write a function to evaluate the integral, \int_a^b dx f(x) using a for loop.  
[Optionally, what happens if you add @parallel before the for loop (without adding any extra processors)?]

c.  Write a function to evaluate the integral, \int_a^b dx f(x) using vector notation.  

d.  Write a function to evaluate the integral, \int_a^b dx f(x) using the ['map'](http://docs.julialang.org/en/release-0.3/stdlib/collections/#Base.map) and [reduce](http://docs.julialang.org/en/release-0.3/stdlib/collections/?highlight=reduce#Base.reduce) functions.

e.  Write a function to evaluate the integral, \int_a^b dx f(x) using the ['mapreduce'](http://docs.julialang.org/en/release-0.3/stdlib/collections/?highlight=mapreduce#Base.mapreduce) function.  

f.  Write a function to evaluate the integral, \int_a^b dx exp(-0.5*x^2)/sqrt(2pi) using the ['@devec'] macro from the [Devectorize](https://github.com/lindahua/Devectorize.jl) package.  (Hint:  For this part, you will need to hardwire the integrand, so you'll remove the function argument to your integrate function.)

g.  Now that each of your integration functions is working, benchmark each of the integration functions using a combination of a large of evaluations of f(x) inside your function and/or multiple evaluations of the integral, so the run times are at least a tenth of a second.  (I found using >=10^8 total integrand evaluations worked on my laptop.)   

h.  For at least two of the best performing implementations, profile the code.  Which operations are taking the most time?  Write a few sentances discussing the implications for the prospects for further improving the codes performance.

i.  Repeat parts 2b-2e using an integrand that is significantly more complex and time consuming to compute.  


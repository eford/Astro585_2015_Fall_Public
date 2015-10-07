# Astro 585 Lab 1, Exercise 4

# Computing Variances

For this exercise, you will compute the variance of the above data using multiple algorithms and compare their relative merits.  Algebraically, the sample mean is calculated via
$m = 1/N \times \sum_{i=1}^{N} y_i$ and the sample variance can be written two ways
$$s^2 = 1/(N-1) \times \sum_{i=1}^N (y_i-m)^2 = 1/(N-1)  \times \left[ \left( \sum_{i=1}^N y_i^2 \right) - N m^2 \right]$$.
In this exercise, you will consider how to calculate the sample variance accurately and efficiently.   

Functions:  It will be useful to write your code as functions.  I strongly recommend you develop a habit of writing code in the form of functions (preferably ones that can be printed on one page of paper).  Julia provides multiple syntaxes for writing functions, as described [here in the Julia manual](http://julia.readthedocs.org/en/latest/manual/functions/). (I suggest deferring the subsections on anonymous function and varargs functions.)  The following example demonstrates how to write a function, a simple for loop and access elements of an array in Julia:
```
function mean_demo(y::Array)  # the syntax ::Array specifies that this function can only be applied if argument is an array.
   n = length(y);             # get the number of elements in the array y
   sum = zero(y[1]);          # set sum to zero.  Using zero(y[1]) makes sum have the same data type as y[1]
   for i in 1:n               # In Julia and Fortran, arrays start a 1, not 0 (like in C arrays and Python lists)
      sum = sum + y[i];
   end;                       # semi-colons are unnecessary, but can be useful when pasting code interactively
   return sum/n;              # return isn't necessary since functions return the last value by default
end
```

This could also be written more succinctly as 
``` mean_demo(y::Array) = sum(y)/length(y); ```
Indeed, Julia comes with a function `mean()` that is written almost identically to this.  

a.  Write a function containing a one-pass algorithm to calculate the variance using a single loop.  

b.  Write a function containing a two-pass algorithm to calculate the variance using two loops over the y_i's.  

c.  Compare the accuracy of the results using N=10^6 and true_mean=10^6.  

d.  What considerations would affect the decision of whether to use the one-pass algorithm or the two-pass algorithm?

e.  Consider a third online 1-pass algorithm for calculating the sample variance given below.  Under what circumstance would it be a good/poor choice to use?
```
function var_online(y::Array)
  n = length(y);
  sum1 = zero(y[1]);
  mean = zero(y[1]);
  M2 = zero(y[1]);
  for i in 1:n
	  diff_by_i = (y[i]-mean)/i;
	  mean = mean +diff_by_i;
	  M2 = M2 + (i-1)*diff_by_i*diff_by_i+(y[i]-mean)*(y[i]-mean); 
  end;  
  variance = M2/(n-1);
end
```


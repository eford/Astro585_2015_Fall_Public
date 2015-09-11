# Astro 585 Lab 4, Exercise 1

### Performance Comparisons (1/2):  Profiling, Loops vs Vectorize vs Map & Branching

1.  Profiling
Julia comes with a sampling (or statistical) profiler.  To profile a function, simply preface the function call with the `@profile macro`.  You can do this for multiple function calls to profile a multi-line section of code or to build up statistics.  To see the results run
`Profile.print()`.  To clear the profile statistics, run `Profile.clear()`.  For more information about how to interpret the results, see the [Profiling section of the Julia manual](http://julia.readthedocs.org/en/release-0.3/stdlib/profile/).

Once you have complex functions calling other functions that call other functions, it can be helpful to visualize the profiling information.  The [ProfileView.jl package](https://github.com/timholy/ProfileView.jl) provides basic functionality.  After installing the package (`Pkg.add("ProfileView")`), importing the package (`using ProfileView`), and profiling your function, you simply call `ProfileView.view()` to see where time is being spent.

a) Pick at least two non-trivial functions to profile.  If youve already know of function(s) that youll be using for your class project, then I'd suggest that you profile them. Otherwise, then I'll suggest that you profile two implementations of the leapfrog integrator from Lab 2.   (You'll find my implementation in leapfrog_eric.jl.  Alternatively, you could also use the `log_likelihood` function from the previous lab.)  For the second implementation, you can use either your implementation or an alternative implementation that I've prepared (based on a previous students submission) in leapfrog_student.jl.  If you use your own implementation, be sure to test it, so it gives nearly identical results to mine.

b)  For each of the functions to be profiled, inspect the code and try to predict which 2-4 lines of code are likely to take the most time.  Estimate what fraction of the time you think those lines will take.  

c)  Profile each function.  Make sure that the profiler has collected enough samples that the results are statistically useful (say at least a thousand samples).  If you need to increase the number of samples, you could: 1) call your function with a longer integration time/larger dataset, 2) call your function several times (without clearing the profiler between calls), and/or 3) change the frequency at which the profiler samples your code (using Profile.init()). 

d) For each of the functions profiled above, identify the portion(s) of your code the computer is spending most of its time.  Explain any differences from your predictions.  

e) Is there anything you could do to improve the performance of the sections of code identified above?  If so, what?  How much of a difference do you think it would make in the overall code run time?  Given the likely effort required, would it be worth your time to try to speed-up that section of the code?

f) Pick at least one idea for optimizing the code to try (whatever you think is most likely to help the performance with a reasonable amount of coding).  Implement your idea.  Remember to check that you've committed your changes to the repository before you starting optimzing.  Once you've attempted the optimizaiton, make sure it still passes your tests, and it still giving the same answer (or as similar as it should be given floating point arithmetic and your problem).  

g) Benchmark and profile the code with your attempted optimizations.  Is there a difference big enough that its consistently faster or slower than the original implementation?  Has the most time consuming part of the code changed?  Or stayed the same?  Describe your best hypothesis for explaining the behavior you observe.


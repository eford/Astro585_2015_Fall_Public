# Astro 585 Lab 2, Exercise 1

# Benchmarking basic mathematical operations

Julia provides several tools for measuring code performance. Perhaps the simplest way is using the `@time` or `@elapsed` macro which can be placed prior to a command, like `@time randn(1000)`. The `@time` macro prints the time, but returns the value of the following expression. The `@elapsed` macro discards the following expressions return value and returns the elapsed time evaluating the expression. For finer control, you can investigate the `tic()`, `toc()` and `toq()` functions (see the Julia manual for details).

For several common mathematical functions, calculate how many million evaluations your computer performs per second. Try at least three arithmatic operations, two trig functions, and a logarithm. For example,  
N = 1000000;
println("rand:  ", 1./(@elapsed x = rand(N)), " M evals/sec");
println(".+  :  ",1./(@elapsed x.+x), " M evals/sec");


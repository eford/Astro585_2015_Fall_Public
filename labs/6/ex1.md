# PsuAstro585:  Lab 6  
# Parallel Computing:  Multi-Core Workstations

## Exercise 1 Multi-core Parallelization Three Ways

## Telling Julia to use multiple processors
a.  Here we'll parallelize some simple code from a previous exercise. I'll walk you though the syntax in Julia and highlight some potential mistakes.

First, check how many processors your computer has. On linux, you can do this by running /cat/cpuinfo from the command line and seeing how many processors are listed. If your machine only has one, then ssh to another computer with Julia installed for the parallel parts.  Next, check how many processor Julia is currently using.
```julia
nprocs()
```

When using the REPL interface, you can tell Julia to use multiple cores on a single workstation by starting it like "julia -p 4". When using IJulia, it's easier to tell it to add N processors from within the notebook with the addprocs(N) command. Using addprocs() without an arguement will tell it to add as many workers as your system (thinks it) has cores.  (Some CPUs give misleading information, presenting more "virtual cores" than "physical cores".)  Tell your current Julia session to add as many workers as your workstation (says it) has.
```julia
addprocs()
```

Now, check how many processor and how many "workers" are active.
```julia
println("nprocs()= ",nprocs())
println("nworkers()= ",nworkers())
println("myid()= ",myid())
```

What's the differences between nprocs() and nworkers()? 
`nprocs()` tells you have many threads your julia session is currently using, while `nworkers()` tells you how many threads Julia is using for worker processes.  When there are multiple threads, one serves as the master thread telling others what to do.  If you're trying to use all of the cores on a given machine for your code, then typically, you'd want either number of worker threads or the number of total threads to equal the number of processor cores.  


### Doing work with a worker
You can explicitly instruct Julia to start a calculation on another node using @spawn or @spawnat.  
Since the whole point is you want multiple processors working at once, you don't want to have to wait until that function finished.
Therefore, these macros return a `RemoteRef` data type, rather than the return value.  You can retreive the returned value using fetch. E.g., 
```julia
ref = @spawn 1+1
fetch(ref)
```

### Parallel for loop
There are macros and functions that make it easy to perform some commone parallel tasks, such as a parallel for loop.  As a first example, we'll parallelize a very simple integration algorithm.  	
Let's define our beloved normal pdf function
```
normal_pdf(x) = exp(-0.5*x.*x)./sqrt(2.*pi)
```
and  define a loop-based integrate function like from the previous lab.
```julia
# Calculate \int_a^b dx func(x) using n function evaluations
# Approximates integral as uniformly spaced rectangles
# Avoids evaluating func at a or b, in case of singularities
function int_normal_pdf_serial(a::Real, b::Real, n::Integer = 100000)
  @assert(n>2)
  integral = 0.
  for i in 1:n
    x = a+i*(b-a)/(n+1)
    integral += normal_pdf(x)
  end
  integral *= (b-a)/n;
end
```

Of course, we need to make tests to ensure that our function is working correctly.  E.g., 
```julia
using Base.Test
function test_int_normal_pdf(func::Function; n::Integer = 100000, eps::Real = 1.0e-6)
  limits = 1:5
  for limit in limits
    @test_approx_eq_eps func(-limit,limit) erf(limit/sqrt(2.0)) eps
  end
end
test_int_normal_pdf(int_normal_pdf_serial)
```

b.  Now, read the [documentation about parallel for loops](http://julia.readthedocs.org/en/latest/manual/parallel-computing/#parallel-map-and-loops).  What do you expect will happen if we try to parallelize the integration function simply by adding the @parallel macro, as in the following code?  
```
function int_normal_pdf(a::Real, b::Real, n::Integer = 100000)
  @assert(n>2)
  integral = 0.
  @parallel for i in 1:n
    x = a+i*(b-a)/(n+1)
    integral += normal_pdf(x)
  end
  integral *= (b-a)/n;
end
```
What do you expect to happen when your run `test_int_normal_pdf(int_normal_pdf)`?
Try it.  Did it do what you expected?  If not, why?


c.  The problem is that we've defined functions on only the master processor.  We need to make sure they're also defined on any other processors that will try to use the functions.  The easiest way to do that is with the [@everywhere macro](http://julia.readthedocs.org/en/latest/stdlib/parallel/?highlight=everywhere#Base.@everywhere).  You can either stick it in front of each function (in your notebook) or save the functions to be run on worker processes in a separate file and load all the functions in that file with `@everywhere include("file.jl")`.  
Redefine the functions to be run on worker processes, but now forcing them to be declared on each processor.
```julia
@everywhere normal_pdf(x) = exp(-0.5*x.*x)./sqrt(2.*pi)
```

Now, what do you expect to happen when your run `test_int_normal_pdf(int_normal_pdf)`?
Try it.  Did it do what you expected?  If not, why?

d.  Now, we've eliminated some of the error messages, but our test still fails.  And it can fail badly.  Why is that?

The computations are  being spread across the different processors, but each thread has its own value of `integral` and the threads are not communicating with each other.  In this case, we want Julia to perform a "reduction" operation.  That is each thread will contribute compute the sum of integrands and then those are to be added together.  This type of operation is so common, that Julia provides a special syntax that makes this kind of loop easy:
```julia
function int_normal_pdf(a::Real, b::Real, n::Integer = 100000)
  @assert(n>2)
  integral = @parallel (+) for i in 1:n
    x = a+i*(b-a)/(n+1)
    normal_pdf(x)
  end
  integral *= (b-a)/n;
end
```
Here Julia is taking the last line of the for loop as the value to be "reduced" by the "+" operator and the result is stored in integral.  Note that the loop is no longer executed in order, since different processors are executing different parts of the loop.

Now, what do you expect to happen when your run `test_int_normal_pdf(int_normal_pdf)`?
Try it.  Did it do what you expected?  If not, why?  

e.  Once you get it working, benchmark the performance of your integration function for serial (i.e., no @parallel instructions), "parallel" but using only one worker, parallel with using 2, 3, 4, 6 or 8 workers.  (If you aren't on a machine that has several cores, then ssh to a machine with several cores for your benchmarks. )  Compare the performance and explain why it behaves that way.   

## Parallel Map (pmap)

f.  Now, reimplement the same algorithm, but using a different pattern for parallelizing the code that uses julia's `pmap` function.  It's described both at the end of the [parallel loops section](
http://julia.readthedocs.org/en/latest/manual/parallel-computing/?highlight=parallel-map-and-loops#parallel-map-and-loops) you read earlier and also in the manual under [pmap](http://julia.readthedocs.org/en/latest/stdlib/parallel/#Base.pmap).  

g.  Before you run your code, do you expect the performance to be better or worse than using a parallel for loop?  What about relative to a non-parallelized algorithm?

h.  Try it.  (In this and subsequent parts, it's probably wise to start with a smaller value of n and work your way up, in case you have code that will take a long time.) After you make sure it's working correctly, benchmark it with 1, 2, 3, or 4 processors.  Compare the performance and explain why it behaves that way.  

i.  Under what circumstances would `pmap` be a good choice for parallelizing some code?


## Distributed Arrays

j.  Next, we'll try parallelizing the same algorithm a third way, using [Distributed Arrays](http://julia.readthedocs.org/en/release-0.3/manual/parallel-computing/#distributed-arrays).  (These are included in the base julia language in v0.3*.  If you're using julia v0.4, then you'll need to add the [DistributedArray package](https://github.com/JuliaParallel/DistributedArrays.jl) first.
A trivial implementation would be
```julia
function int_normal_pdf(a::Real, b::Real, n::Integer = 100000)
  @assert(n>2)
  x = distribute([ a+i*(b-a)/(n+1) for i in 1:n ])
  integral = sum(map(normal_pdf,x)) * (b-a)/n 
end
```
Note that we use the standard `map` on a DistributedArray and not `pmap`.  Julia recognizes that map applied to a DistributedArray should be parallelized.  Test that the code using a DistributedArray works.  

k. How does it's performance compare to previous implementations?  Why?

l.  Now, we'll implement a more efficient parallelization using distribute arrays.  First, let's replace the call to `map` with [mapreduce](http://julia.readthedocs.org/en/latest/stdlib/collections/?highlight=mapreduce#Base.mapreduce).  

m.  Next, let's try to implement an even more efficient way of computing the integral while minimizing unnecessary communications.  
The following functions will likely be useful.
You can look at which processors are storing data for that array with [procs()](http://julia.readthedocs.org/en/release-0.3/stdlib/parallel/?highlight=procs#Base.procs).
You can check which parts of the array are being stored on a given processor using [localpart()](http://julia.readthedocs.org/en/release-0.3/stdlib/parallel/?highlight=localpart#Base.localpart) or [myindexes()](http://julia.readthedocs.org/en/release-0.3/stdlib/parallel/?highlight=localindexes#Base.localindexes)

Then, use [@spawnat](http://julia.readthedocs.org/en/release-0.3/stdlib/parallel/?highlight=spawnat#Base.@spawnat) and [localpart()](http://julia.readthedocs.org/en/release-0.3/stdlib/parallel/?highlight=localpart#Base.localpart) to have a processor operate only on the portion of the distributed array that it has in its own memory.
Finally, combine [fetch](http://julia.readthedocs.org/en/release-0.3/stdlib/parallel/?highlight=fetch#Base.fetch) with [map](http://julia.readthedocs.org/en/release-0.3/stdlib/collections/?highlight=map#Base.map) to retrieve the results from each processor working on it's own portion of the distributed array.
You could use [reduce](http://julia.readthedocs.org/en/release-0.3/stdlib/collections/?highlight=reduce#Base.reduce) to combine all these elements or you could again use l.  Now, we'll implement a more efficient parallelization using distribute arrays.  First, let's replace the call to `map` with [mapreduce](http://julia.readthedocs.org/en/latest/stdlib/collections/?highlight=mapreduce#Base.mapreduce).  

If you get stuck on this part, you can look in the file ex1m_help.md for an example of a solution to this part.  If you do that, then write out a description of each part of the key line of code is doing.  And identify one way that it could still be improved further.  

n.  Once you've tested your function, benchmark your function using different numbers of workers and compare it's performance to the previous implementations.  

o.  When would using a DistributedArray be a good choice for parallelizing your code?

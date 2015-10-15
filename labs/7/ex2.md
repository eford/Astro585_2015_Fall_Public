# PSU Astro585:  Lab 6  
# Parallel Computing:  Distributed Memory Clusters

## Exercise 2 Using Julia's DistributedArrays

In this exercise, you will learn how to use Distributed Arrays to parallelize a computation over processors on a cluster.  Note that DistributedArrays were moved from the base Julia library in v0.3.* to their own package starting in julia v0.4.*.  Below, I'll assume that you're using a v0.4.  

First, make a simple parallel version of our the calc_pi function from the previous exercise.  Using the `@parallel` macro (along with a "reducer" operation).  Since this takes just a second or two, you can test it interactively using a single processor core without submitting a PBS job.  

b.  Once it seems to be working, test it using a PBS job.  You'll need to adapt your PBS script from the previous exercise so the computation can use multiple processors.  To tell PBS your job will use multiple processor cores, change the line `#PBS -l nodes=1` in the PBS script to `#PBS -l nodes=1:ppn=4` (for four processor cores on a single node) or `#PBS -l nodes=4` (for four cores potentially on different nodes).  Second, you'll need to tell Julia to use the processors which PBS assigns to your job.  I think the easiest way to do this is by replacing the line `julia myprog.jl` with `julia --machinefile $PBS_NODEFILE  myprog.jl` (assuming that your new program is stored in the file myprog.jl).  

Alternatively, you could have the PBS script start Julia just on the master node (i.e., `julia myprog.jl`) and then add additional processors.  I've written some simple functions demonstrating this approach that you can access using
```julia
include("/gpfs/home/ebf11/public/pbs.jl")
check_pbs_tasknum_one()
proclist = addprocs_pbs()
print_node_status()
```

c.  Test your PBS script and julia code work when using multiple processors (e.g., 2, 4, 8).  For 2, 4 and 8 try both requesting processors regardless of whether they are on the same node and also requesting all processors to be on the same node.   You can either: 1) modify the script several times or 2) use the command line to override PBS parameters like the nodes and job name.  Remember what time you submitted each of the jobs.  And make sure the different jobs don't all overwrite each others output data.  

How does the time required for the computation vary as a function of the number of processors?  How did the time that you wait before your jobs to start vary with the number of nodes?  

Is the compute time affected by whether you request processors on the same node or allow for them to be on different nodes?  Did the time you waited before your job started depend on whether you request processors on the same node or allow for them to be on different nodes?  

d.  Now, let's create a version that replaces the parallel for loop with a call to [`mapreduce`](http://docs.julialang.org/en/release-0.3/stdlib/collections/?highlight=mapreduce#Base.mapreduce) operating on distributed arrays.  You can easily create a distributed array containing pseudo-random numbers between 0 and 1 using `drand(N)` from the [DistributedArrays](https://github.com/JuliaParallel/DistributedArrays.jl) package.  
Note that with Julia v0.4, you can perform arithmetic on distributed arrays using syntax like `x.*x`, as well as [`map`](http://docs.julialang.org/en/release-0.3/stdlib/collections/?highlight=map#Base.map) or [`mapreduce`](http://docs.julialang.org/en/release-0.3/stdlib/collections/?highlight=mapreduce#Base.mapreduce).
 
e.  Submit the revised code in jobs requesting 1, 2, 4 or 8 processors.  (Again, remember what time you submitted the jobs.)  For 2, 4 and 8 try both requesting processors regardless of whether they are on the same node and also requesting all processors to be on the same node.   

f.  How does the time required for the computation vary as a function of the number of processors?  How did the time that you wait before your jobs to start vary with the number of nodes?  

g.  (Optional)  Collect the results of the previous jobs and make a plot showing run time versus number of cores.  Show both the case where all cores were on the same node and the case where the cores could have been spread over different nodes.  You can use different colors for the lines/points or separate figures.  

1h.  How well does this calculation parallelize over a cluster?  Estimate how many processors spread over different nodes you would need for this calculation to be faster than performing it on a single node with 4 cores.



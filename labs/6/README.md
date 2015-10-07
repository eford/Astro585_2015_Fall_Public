# PsuAstro585:  Lab 6  
# Parallel Computing:  Multi-Core Workstations

## Exercises
1.  First, we'll parallelize some simple code from a previous exercise. I'll walk you though the syntax in Julia and highlight some potential mistakes.

First, check how many processors your computer has. On linux, you can do this by running /cat/cpuinfo from the command line and seeing how many processors are listed. If your machine only has one, then ssh to another computer with Julia installed for the parallel parts.  Next, check how many processor Julia is currently using.
```julia
nprocs()
```

When using the REPL interface, you can tell Julia to use multiple cores on a single workstation by starting it like "julia -p 4". When using IJulia, it's easier to tell it to add processors from within the notebook with the addprocs(N) command. Using addprocs(N) to tell Julia to use as many processors as your workstation has.
```julia
addprocs(4)
```

Now, check how many processor and how many "workers" are active.
```julia
println("nprocs()= ",nprocs())
println("nworkers()= ",nworkers())
println("myid()= ",myid())
```

1a.  What's the differences between nprocs() and nworkers()?

# nprocs() tells you have many available processors there are, nworkers() tells you how many Julia is using.







3.  Make sure to save some time to continue working on your class project.  Hopefully, you've already thought about the big questions (programming at large).  I'd encourage to make significant progress writing and testing code (think back to reading and discussion of programming in the middle) and starting to fill in some of the details.  Remember to commit often.  Once you've finished coding for your project for the week, write a few sentances reflecting on how it's going.  Feel free to include any questions about strategy or to note something you've come to appreciate the value of while applying what you've learned in the class.  



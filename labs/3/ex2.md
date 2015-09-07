# Astro 585 Lab 3, Exercise 2

## Warning:  Still under construction

# File I/O, Part 2

## Reading and Writing Binary Files

a)  Write two functions that open a file, write/read the data from an array in binary to/from the file, close the file.  
Hints:  You could use [write]( http://docs.julialang.org/en/release-0.3/stdlib/io-network/#Base.write) and [read](http://docs.julialang.org/en/release-0.3/stdlib/io-network/#Base.read) or [serialize](http://docs.julialang.org/en/release-0.3/stdlib/io-network/#Base.serialize) and [deserialize](http://docs.julialang.org/en/release-0.3/stdlib/io-network/#Base.deserialize).  
Remember to commit your changes to your git repository.  Write a new function to test your functions for reading/writing binary files.  If the test reveals any bugs, fix them and write a sentence or two about what you learned from the experience.

b) Time how long it takes for both reading and writing of the 1024 and 1024^2 size arrays.  If its practical on your computer, try a significantly larger size like 10*10242 or 100*10242.  (Youll likely use open, close (or a do block), and either read and write or serialize and deserialize.)  How do these times compare to the time required for ASCII files?  How does the resulting file size compare?    


c) Repeat part a, but reading and writing the data to a binary file in the JLD format (built on top of HDF5).  For this, youll need to add and load Julias JLD package:
```julia
Pkg.add("JLD")
using JLD
```
The simplest way is to use the `@save` and `@load` macros like
```julia
 data_1d = rand(1024)
 @save "test.jld" data_1d
 @load "test.jld"
 ```
There are additional options to these macros, as well as more flexible set of functions (e.g., jldopen, write, read, close; h5write and h5read; h5open and dictionary-like interface).  See the [Quickstart section of the JLD documentation](https://github.com/JuliaLang/JLD.jl#quickstart) for more details.  
Test your code.  How does the time required and file sizes compare to the other file formats?  

d) Optional:  Write functions that let the caller read the value of any single array element from a file for each of the file formats above.  When reading an element thats roughly mid-way through the file, how does the time required compare for the different file formats?  

e) Under which circumstances would you be likely to use printing to STDOUT, writing to an ASCII file, or one of the binary file formats from this exercise?




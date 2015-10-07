# Astro 585 Lab 3, Exercise 1

# File I/O, Part 1

## Reading and Writing Text Files

Often you will perform one large calculation that takes a long time to generate some out data beore you repeatedly reanalyze the outputs several different ways.  That requires that your large simulation writes the output data to disk.  Later you want to be able to read the data from disk and process it, trying out several different types of analysis.  In this and the subsequent exercise, you will write functions that print formatted data to the screen, write data to disk (either as ASCII text, raw binary or structured binary formats) and read the data back from disk.  After testing and benchmarking the different methods for different sizes of data, you'll think about what factors will affect choosing which methods is most appropriate for a given situation.

### a) Print text output
Generate a vector of 1024 floating point numbers.  Write a function that print an ASCII representation of an array of floating point numbers to STDOUT, benchmark that function and report how long it takes.  (Youll likely use the `print`, `println` or `show` functions and/or the `@printf` macro, as described in the [Text I/O section of the Julia manual](http://docs.julialang.org/en/release-0.3/stdlib/io-network/#text-i-o).)

### b) Write a text file
Write a function that opens a file, writes the array in an ASCII format to the file and closes the file.  
Hints: You could do this by
calling the [open](http://docs.julialang.org/en/release-0.3/stdlib/io-network/#Base.open) function, 
then using the same functions as in part a bu adding the IOStream object returned by open as the first argument to the print functions and [close](http://docs.julialang.org/en/release-0.3/stdlib/io-network/#Base.close).
Alternatively, you could use the [writecsv](http://docs.julialang.org/en/release-0.3/stdlib/io-network/#Base.writecsv) or [writedlm](http://docs.julialang.org/en/release-0.3/stdlib/io-network/#Base.writedlm) functions to do this with one line of code.  
Alternatively (especially for R or Python Pandas users), you might like to use the [DataFrames package](https://github.com/JuliaStats/DataFrames.jl) which has its own [writetable](https://dataframesjl.readthedocs.org/en/latest/io.html#exporting-data-to-a-tabular-data-file) function.

### c) Read a text file
Write a second function that does the same, but reads in the array from the file you created.  Hints:  Similar to above, you could use the functions from part a, plus the functions [readline](http://docs.julialang.org/en/release-0.3/stdlib/io-network/#Base.readline) and [parse](http://docs.julialang.org/en/release-0.3/stdlib/base/#Base.parse).  (If you had written a 2-d array, you'd also want [split](http://docs.julialang.org/en/release-0.3/stdlib/strings/#split).)
Alternatively, you could use the [readcsv](http://docs.julialang.org/en/release-0.3/stdlib/io-network/#Base.readcsv) or [readdlm](http://docs.julialang.org/en/release-0.3/stdlib/io-network/#Base.readdlm) functions to do this with one line of code, or the [readtable](https://dataframesjl.readthedocs.org/en/latest/io.html#importing-data-from-tabular-data-files) function from the DataFrames package.  (FYI- There's also a young project to create a faster CSV file reader, [CSVReaders](https://github.com/johnmyleswhite/CSVReaders.jl) that you might be interested in trying.)
Remember to commit your work to your git repository.  

### d) Testing Reading and Writing Text Files
Write a function that performs an integration test to make sure that after you write an array to a file and read it back it, you get back the same data as you started with.  If your functions don't pass, then correct your reading, writing and/or test functions, commit the changes to your git repository, and write a sentence or two about what you learned from the experience.  

### Benchmarking Reading/Writing to Text Files
e) Benchmark how long reading and writing the ASCII files takes (separately).  How does writing to a file compare to printing to STDOUT (i.e., the default way command line programs write output text data to your screen)?   How does the time required to read a file change if you read the same file multiple times in a row?   What do you think is causes the differences?  

f)  Increase the size of the array to 1024*1024 floating point numbers and retime the printing to STDOUT, as well as the writing and reading to/from a file.   How do your results differ from part e?  What do you think is causes the differences?  




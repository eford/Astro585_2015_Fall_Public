# Astro 585 Lab 3, Exercise 3

# Documenting your Function

In Julia, the `#` character causes the rest of the line to be interpreted as a comment (except when inside [strings](http://docs.julialang.org/en/release-0.3/manual/strings/) and [non-standard string literals](http://docs.julialang.org/en/release-0.3/manual/strings/#non-standard-string-literals)).  
If you want to have a multi-line comment, you may find it use to use `#=` to start and `=#` to end the commented section like this
```julia
# This is a single line comment.  It's very useful for simple comments.
x = 1   # This line actually binds x to the value 1
# y = 2   This line is just a comment so doesn't affect y
#= This is a multiline comment.
   It can be useful for more lengthy comments, such as 
      - what each of a function's does,
      - references for the algorithm you're using, or
      - writing mathematical equations.
   z = 3
   The above line does not cause z to be bound to the value 3, since it's inside a comment block.
=#
```

a)  Pick a few functions from one of the previous exercises that you will document.  Add embedded documentation of their purpose and interface just above the function definition.
Keep in mind the advice we read from [Best Practices for Scientific Computing](http://arxiv.org/pdf/1210.0530v4.pdf): "Document interfaces and reasons, not implementations".  

b)  Do you functions have any pre-conditions or post-conditions?  If so, then either add `@assert` statements (executable documentation) or if that's not appropriate, a comment stating what the pre/post-condition is.

c) It can be nice to get quick help about how to use a function.  For example, you might remember that the `split` function is useful for reading ASCII files, but forget how to call it.  From the REPL, you could simply run `? split` to get a succinct explanation of the function, its arguments and return values.  

Optional: You can add this feature to your own functions. 
Assuming that you're using Julia version 0.3.*, then you'll need to add, load and initialize the [`Docile`](https://github.com/MichaelHatherly/Docile.jl) package with
```julia
Pkg.add("Docile")
using Docile
@docstrings
```

You could document a simple function like
```julia
@doc "cube(x) returns cube of x." -> cube(x::Real) = x*x*x
```
or a more complex function like
```julia
@doc """Tests writecsv and readcsv functions on an Array of data.
  * Inputs:   
    - data_orig::Array  # Array of data to be used for data
  * Returns: nothing. 
  * Assumes:
    - Size of the input data does not exceed 1024^3 bytes.
  * Asserts:
    - Size of input data matches size of data after writing and reading to/from disk.
    - Each element of the input data is equal to the corresponding element of the data after writing and reading to/from disk.
  * Author: Eric Ford (9/7/2015)
""" -> 
function test_writecsv_readcsv_on_array(data_orig::Array)
  @assert(sizeof(data_orig)<=1024^3)
  writecsv("test.csv",data_orig)
  data_read = readcsv("test.csv")
  @assert(size(data_orig)==size(data_read))
  @assert(all(data_orgi .== data_read))
  return nothing
end
```

Note that this should run without errors.  But, as written, this won't actually work with Julia version v0.3.*, since since Docile documents packages, not functions or files.  With version v0.3.*, you'd have to make your documented function part of a Julia package for `? test_writecsv_readcsv_on_array` to return the above string.  

Fortunately, Julia v0.4 (likely to come out very soon) supports a very similar syntax natively (i.e., without loading Docile) and can be used to document individual functions, even if they're not part of a package.  
While the above syntax still works, v0.4 encourages a slightly simppler syntax (e.g., the `doc` and `->` aren't necessary).  Also, note that some of the features recently addedto Docile aren't included. See the [latest version of the Julia manual](http://julia.readthedocs.org/en/latest/manual/documentation/) for details.)





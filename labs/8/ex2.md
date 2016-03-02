# PSU Astro585:  Lab 8  
# Parallel Computing:  GPU Programming

## Exercise 2:  Performing a Parallel Reduction on the GPU

a.  Compute the integraion of the standard normal distribution between a and b, using N function evaluations which are performed in parallel using the GPU-accelerated version of std_normal_pdf.  For now, you can sum the integrands on the CPU

```julia
include("cuda_basics.jl")  
init_cuda()                
junk = CudaArray(Float64, 1)  # Adding this seems to prevent some issues if you didn't shut down GPU properly last time
md = load_functions()      
#
# Insert your code here
#
@time int_normal_gpu_reduce_on_cpu(-1.0,1.0,1000)
@time int_normal_gpu_reduce_on_cpu(-1.0,1.0,1000)
@time int_normal_gpu_reduce_on_cpu(-1.0,1.0,10000)
@time int_normal_gpu_reduce_on_cpu(-1.0,1.0,100000)
@time int_normal_gpu_reduce_on_cpu(-1.0,1.0,1000000)
@time int_normal_gpu_reduce_on_cpu(-1.0,1.0,10000000)
```

b.  Write a new version that perform most (Optionally: all) of the work for the summation on the GPU.
```julia
@time int_normal_gpu_reduce_on_gpu(-1.0,1.0,1000)
@time int_normal_gpu_reduce_on_gpu(-1.0,1.0,1000)
@time int_normal_gpu_reduce_on_gpu(-1.0,1.0,10000)
@time int_normal_gpu_reduce_on_gpu(-1.0,1.0,100000)
@time int_normal_gpu_reduce_on_gpu(-1.0,1.0,1000000)
@time int_normal_gpu_reduce_on_gpu(-1.0,1.0,10000000)
```

c.  Compare the peformance of the two versions as a function of the number of function evaluations.  
Now how many function evaluations do you need to perform to make it faster on the GPU than on the CPU?

d.  Explain the performancne pattern you observe.  Is this inevitable?  Is there something you could do to speed up the GPU calculation significantly?  Predict how much faster the GPU version would likely be if you went to the trouble of implementing an optimal version of the sumation function.

e.  [Optional]  Adapt your function to have the GPU work in single precission (float in C/CUDA or Float32 in Julia) arithmetic instead of double precission.  How does the performance compare?  What do you think explains these differences?

f.  [Optional]  Write a more efficient kernel to sum the array.  Feel free to look at examples on the web.





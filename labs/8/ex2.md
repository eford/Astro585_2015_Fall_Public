# PSU Astro585:  Lab 8  
# Parallel Computing:  GPU Programming

## Exercise 2:  Performing a Parallel Reduction on the GPU

a.  Write a function to compute the integraion of the standard normal distribution between a and b, using N function evaluations which are performed in parallel using the GPU-accelerated version of std_normal_pdf.  For now, you can sum the integrands on the CPU

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

b.  Adapt your function to have the GPU work in single precission (float in C/CUDA or Float32 in Julia) arithmetic instead of double precission.  How does the performance compare?  What do you think explains these differences?


d.  Write a new version that perform most (Optionally: all) of the work for the summation on the GPU.
```julia
@time int_normal_gpu_reduce_on_gpu(-1.0,1.0,1000)
@time int_normal_gpu_reduce_on_gpu(-1.0,1.0,1000)
@time int_normal_gpu_reduce_on_gpu(-1.0,1.0,10000)
@time int_normal_gpu_reduce_on_gpu(-1.0,1.0,100000)
@time int_normal_gpu_reduce_on_gpu(-1.0,1.0,1000000)
@time int_normal_gpu_reduce_on_gpu(-1.0,1.0,10000000)
```

e.  Compare the peformance of the two versions as a function of the number of function evaluations.  
Now how many function evaluations do you need to perform to make it faster on the GPU than on the CPU?


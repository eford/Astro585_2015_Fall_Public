# PSU Astro585:  Lab 8  
# Parallel Computing:  GPU Programming

## Exercise 1: Calling a simple GPU kernel 

In this exercise, you will learn how to call a simple GPU kernel from Julia.

2.   In this exercise, you will learn how to perform parallel calculations using a GPU.   

a.  Ssh into a machine that has both a CUDA-capable GPU, with both Julia and CUDA installed.  (Currently, thats green.astro.psu.edu.)   First, make sure your working directory has the files for this lab assignment.  Next, make sure that the NVIDIA CUDA compiler is in your path.  If your shell is csh or tcsh and you're using green, you could run `setenv PATH ${PATH}:/usr/local/cuda/bin` or 
or from inside Julia
```julia
if !contains(ENV["PATH"],"cuda")
  ENV["PATH"] = string(ENV["PATH"],":/usr/local/cuda/bin")
end
```

Add the CUDArt julia package
```julia
Pkg.add("CUDArt")
```

b.  Look through the cuda code for one of the GPU kernels in normal_pdf_gpu.cu.   Compile the kernel using 
```julia
run(`nvcc -ptx normal_pdf_kernel.cu`)
```

c.  First, let's perform a familiar calculation on the CPU.

```julia
# Setup input data
min_x = -1.0
max_x = 1.0
n = 10000
h_x = collect(linspace(max_x,min_x,n));  # h_ is a convention to indicate data on the host or GPU

# Perform calculation on CPU for comparison
std_normal_pdf_cpu(x) = exp(-0.5.*x.*x)./sqrt(2pi)
h_y = std_normal_pdf_cpu(h_x)
```

d.  Now, slowly step through the process of performing a computation on the GPU, paying attention to what's happening at each step.
```julia
include("cuda_basics.jl")  # Load functions showing how to setup for using CUDA
init_cuda()                # Initialize a GPU

# Create array on GPU, copying from array on CPU
d_x = CudaArray(h_x)       # d_ is a convention to indicate data on the device or GPU

# Allocate memory for results on GPU
d_y = CudaArray(Float64, (length(d_x)))

# Allocate memory on host for copying results from GPU
h_y_from_gpu = HostArray(Float64, (length(d_x)));


# Load the assembly code for the GPU Kernels 
md = load_functions()   

# Choose parameters about how the GPU will divide up the work 
block_size = choose_block_size(length(d_x))
grid_size = choose_grid_size(length(d_x), block_size)

# Specify a stream, so we can make sure things have finished (either for timing or making sure it's ok to copy data)
stream1 = Stream()

# Actually run the GPU kernel
launch(std_normal_pdf_kernel, grid_size, block_size, (d_x,d_y,length(d_x)), stream=stream1 )

# Copy the results from the GPU to the CPU
copy!(h_y_from_gpu, d_y, stream=stream1)

# Make sure that we wait until all that data has been copied
wait(stream1);

# Compare results from CPU and GPU calculations
maximum(abs(h_y .- h_y_from_gpu))
```

e.  Repeat the above caulations for different values of n (try up to n=100000000), comparing how long it takes to: i) Perform the calculation on the CPU, ii) perform the calculation on the GPU, iii) copy the input data from the CPU to the GPU, iv) copy the output data from the GPU to the CPU, and v) the sum of ii-iv.

f.  How large of a dataset does it take before it's worth using the GPU for this problem, assuming that your data is already on the GPU and the results don't need to be copied to the CPU?
How large of a dataset does it take before it's worth using the GPU for this problem, assuming that you have to copy input data to the GPU and output data to the CPU?  

g.  Before you exit julia, unload the functions from the GPU and reset the GPU
```julia
unload_functions!(md)
close_cuda()
```

